const winston = require('winston');
const LokiTransport = require('winston-loki');

const logger = winston.createLogger({
  transports: [
    new LokiTransport({
      host: 'http://localhost:3100',
      json: true,
      labels: { job: 'nodejs-app' },
      batching: true,
      interval: 5,
    }),
    new winston.transports.Console({
      format: winston.format.simple(),
    }),
  ],
});

// Improved flush method with timeout and error handling
logger.flush = function(timeout = 10000) {
  return new Promise((resolve, reject) => {
    const timeoutId = setTimeout(() => {
      reject(new Error('Flush timeout after ' + timeout + 'ms'));
    }, timeout);

    const lokiTransport = this.transports.find(t => t instanceof LokiTransport);
    if (!lokiTransport) {
      clearTimeout(timeoutId);
      resolve();
      return;
    }

    try {
      console.log("flushing...");
      lokiTransport.flush((err) => {
        clearTimeout(timeoutId);
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    } catch (error) {
      clearTimeout(timeoutId);
      reject(error);
    }
  });
};

module.exports = logger;