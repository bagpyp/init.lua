const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3000;

// Serve static files from public directory
app.use(express.static(path.join(__dirname, 'public')));

// Fallback to index.html
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Start server
app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════╗
║     🚀 Neovim Config Docs Server           ║
╚════════════════════════════════════════════╝

  📚 Documentation available at:
  
     http://localhost:${PORT}
  
  Press Ctrl+C to stop the server
  `);
});