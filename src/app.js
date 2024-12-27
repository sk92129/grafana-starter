// Must be the first import to set up tracing
require('./tracing');

const express = require('express');
const logger = require('./logger');

const app = express();
const port = 3001;

app.get('/', (req, res) => {
  logger.info('Homepage accessed', {
    path: req.path,
    method: req.method,
    userAgent: req.headers['user-agent'],
  });
  res.send('Hello World!');
});

app.get('/error', (req, res) => {
  logger.error('Error endpoint accessed', {
    path: req.path,
    error: 'Test error',
  });
  res.status(500).send('Error test');
});

app.listen(port, () => {
  logger.info(`App listening on port ${port}`);
}); 