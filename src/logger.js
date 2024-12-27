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

module.exports = logger; 