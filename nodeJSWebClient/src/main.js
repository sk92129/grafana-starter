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
  const currentTime = new Date().toISOString();
  const strTime = currentTime.split('T')[1].split('.')[0];
  const msg = `Hello World! ${strTime}`;
  res.send(msg);
});

app.get('/flush', async (req, res) => {
  try {
    logger.info('Homepage accessed flushed', {
      path: req.path,
      method: req.method,
      userAgent: req.headers['user-agent'],
    });
    
    await logger.flush();  // Now has a 5-second timeout
    res.send("Flushed successfully");
  } catch (error) {
    console.error('Flush error:', error);
    res.status(500).send(`Flush failed: ${error.message}`);
  }
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