const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello, World! This is the root route.');
});

// Optional: catch-all route for undefined paths
app.use((req, res) => {
  res.status(404).send('Not Found');
});

const port = process.env.PORT || 10000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
