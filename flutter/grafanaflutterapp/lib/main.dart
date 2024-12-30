import 'package:flutter/material.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Grafana Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Grafana Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final logger = LokiLogger();
  //final tracer = Tracer();
  int _counter = 0;

  void _incrementCounter() {
    //final span = tracer.startSpan('increment_counter');
    
    try {
      setState(() {
        _counter++;
      });

      // logger.info('Counter incremented', {
      //   'counter_value': _counter,
      //   'timestamp': DateTime.now().toIso8601String(),
      // });
    } finally {
      //span.end();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () async {
                //await logger.flush();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logs flushed to Loki')),
                );
              },
              child: const Text('Flush Logs'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}