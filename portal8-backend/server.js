// server.js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello, World! This is the root route.');
});

// Make sure to listen on the correct port
const port = process.env.PORT || 10000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
