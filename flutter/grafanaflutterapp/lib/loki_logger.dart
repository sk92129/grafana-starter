import 'dart:async';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LokiLogger {
  static final LokiLogger _instance = LokiLogger._internal();
  final Queue<LogEntry> _logCache = Queue();
  final int _maxCacheSize = 100; // Adjust this value based on your needs
  final String _lokiUrl = 'http://192.168.1.16:3100/loki/api/v1/push';
  Timer? _batchTimer;

  factory LokiLogger() {
    return _instance;
  }

  LokiLogger._internal() {
    // Start periodic flush every 10 seconds
    _batchTimer = Timer.periodic(const Duration(seconds: 10), (_) => _flushLogs());
  }

  void log(String message, {Map<String, String> labels = const {}}) {
    final timestamp = DateTime.now().microsecondsSinceEpoch * 1000; // Convert to nanoseconds
    print("timestamp: $timestamp");
    _logCache.add(LogEntry(timestamp, message, labels));

    if (_logCache.length >= _maxCacheSize) {
      _flushLogs();
    }
    print("logCache length: ${_logCache.length}");
  }

  Future<void> _flushLogs() async {
    if (_logCache.isEmpty) return;

    print("flushLogs");
    final streams = <Map<String, dynamic>>[];
    final Map<String, List<List<String>>> streamGroups = {};

    // Group logs by labels
    while (_logCache.isNotEmpty) {
      final entry = _logCache.removeFirst();
      final labelKey = jsonEncode(entry.labels);
      
      streamGroups.putIfAbsent(labelKey, () => []);
      streamGroups[labelKey]!.add([
        entry.timestamp.toString(),
        entry.message,
      ]);
    }

    // Create streams from groups
    streamGroups.forEach((labelJson, values) {
      streams.add({
        'stream': json.decode(labelJson),
        'values': values,
      });
    });

    final payload = {'streams': streams};
    print("payload: $payload");

    print("encoded payload: ${json.encode(payload)}");
    try {
      print("sending logs to url Loki: $_lokiUrl");
      final response = await http.post(
        Uri.parse(_lokiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode != 204) {
        print('Failed to send logs to Loki: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending logs to Loki: $e');

      // Re-add failed logs back to the queue
      // You might want to implement a more sophisticated retry mechanism
    }
  }

  void dispose() {
    _batchTimer?.cancel();
    _flushLogs();
  }
}

class LogEntry {
  final int timestamp;
  final String message;
  final Map<String, String> labels;

  LogEntry(this.timestamp, this.message, this.labels);
} 