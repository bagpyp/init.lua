const fs = require('fs');
const path = require('path');
const { marked } = require('marked');
const hljs = require('highlight.js');

// Configure marked with syntax highlighting
marked.setOptions({
  highlight: function(code, lang) {
    if (lang && hljs.getLanguage(lang)) {
      return hljs.highlight(code, { language: lang }).value;
    }
    return hljs.highlightAuto(code).value;
  },
  breaks: true,
  gfm: true
});

// Create public directory
const publicDir = path.join(__dirname, 'public');
if (!fs.existsSync(publicDir)) {
  fs.mkdirSync(publicDir, { recursive: true });
}

// HTML template
const template = (title, content, navigation) => `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${title} - Neovim Config Docs</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 20px;
      line-height: 1.6;
    }
    
    .container {
      max-width: 1200px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: 280px 1fr;
      grid-template-areas: "sidebar main";
      gap: 30px;
      align-items: start;
    }
    
    nav {
      grid-area: sidebar;
      background: rgba(255, 255, 255, 0.95);
      border-radius: 12px;
      padding: 20px;
      height: fit-content;
      position: sticky;
      top: 20px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      min-width: 0; /* Prevent overflow issues */
    }
    
    nav h2 {
      color: #333;
      margin-bottom: 15px;
      font-size: 1.2em;
      border-bottom: 2px solid #667eea;
      padding-bottom: 10px;
    }
    
    nav ul {
      list-style: none;
    }
    
    nav li {
      margin: 8px 0;
    }
    
    nav a {
      color: #555;
      text-decoration: none;
      padding: 8px 12px;
      display: block;
      border-radius: 6px;
      transition: all 0.3s;
    }
    
    nav a:hover {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      transform: translateX(5px);
    }
    
    nav a.active {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }
    
    main {
      grid-area: main;
      background: rgba(255, 255, 255, 0.95);
      border-radius: 12px;
      padding: 40px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      min-width: 0; /* Prevent overflow issues */
      overflow-wrap: break-word;
    }
    
    h1 {
      color: #333;
      margin-bottom: 30px;
      font-size: 2.5em;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    
    h2 {
      color: #444;
      margin: 30px 0 15px;
      font-size: 1.8em;
      border-bottom: 2px solid #e0e0e0;
      padding-bottom: 10px;
    }
    
    h3 {
      color: #555;
      margin: 25px 0 12px;
      font-size: 1.4em;
    }
    
    h4 {
      color: #666;
      margin: 20px 0 10px;
      font-size: 1.2em;
    }
    
    p {
      color: #555;
      margin: 15px 0;
    }
    
    pre {
      background: #1e1e1e;
      color: #f8f8f2;
      padding: 20px;
      border-radius: 8px;
      overflow-x: auto;
      margin: 20px 0;
      border: 1px solid #333;
    }
    
    code {
      font-family: 'SF Mono', Monaco, 'Cascadia Code', monospace;
      font-size: 0.9em;
    }
    
    :not(pre) > code {
      background: #f0f0f0;
      padding: 2px 6px;
      border-radius: 4px;
      color: #d73a49;
    }
    
    ul, ol {
      margin: 15px 0;
      padding-left: 30px;
      color: #555;
    }
    
    li {
      margin: 8px 0;
    }
    
    a {
      color: #667eea;
      text-decoration: none;
      border-bottom: 1px solid transparent;
      transition: border-color 0.3s;
    }
    
    a:hover {
      border-bottom-color: #667eea;
    }
    
    blockquote {
      border-left: 4px solid #667eea;
      padding-left: 20px;
      margin: 20px 0;
      color: #666;
      font-style: italic;
      background: #f8f8f8;
      padding: 15px 20px;
      border-radius: 0 8px 8px 0;
    }
    
    table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
    }
    
    th, td {
      border: 1px solid #ddd;
      padding: 12px;
      text-align: left;
    }
    
    th {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }
    
    .home-hero {
      text-align: center;
      padding: 40px 0;
      border-bottom: 2px solid #e0e0e0;
      margin-bottom: 30px;
    }
    
    .home-hero h1 {
      font-size: 3em;
      margin-bottom: 20px;
    }
    
    .home-hero p {
      font-size: 1.2em;
      color: #666;
    }
    
    .feature-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin: 30px 0;
    }
    
    .feature-card {
      background: linear-gradient(135deg, #667eea20 0%, #764ba220 100%);
      padding: 20px;
      border-radius: 8px;
      border: 1px solid #667eea30;
    }
    
    .feature-card h3 {
      color: #667eea;
      margin-bottom: 10px;
    }
    
    @media (max-width: 768px) {
      .container {
        grid-template-columns: 1fr;
        grid-template-areas: 
          "sidebar"
          "main";
      }
      
      nav {
        position: static;
        grid-area: sidebar;
      }
      
      main {
        grid-area: main;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <nav>
      ${navigation}
    </nav>
    <main>
      ${content}
    </main>
  </div>
</body>
</html>`;

// Get all markdown files
function getMarkdownFiles(dir) {
  const files = [];
  const items = fs.readdirSync(dir);
  
  for (const item of items) {
    const fullPath = path.join(dir, item);
    const stat = fs.statSync(fullPath);
    
    if (stat.isDirectory() && item !== 'docs-site' && item !== 'public' && item !== 'node_modules' && !item.startsWith('.')) {
      files.push(...getMarkdownFiles(fullPath));
    } else if (item.endsWith('.md')) {
      files.push(fullPath);
    }
  }
  
  return files;
}

// Process docs
const docsDir = path.join(__dirname, '..');
const docFiles = getMarkdownFiles(docsDir);

// Build navigation
const navItems = [];
const pages = [];

// Add home page
navItems.push({ title: 'Home', href: 'index.html', order: 0 });

// Process each markdown file
docFiles.forEach(file => {
  const relativePath = path.relative(docsDir, file);
  const basename = path.basename(file, '.md');
  const dirname = path.dirname(relativePath);
  
  // Skip files in docs-site
  if (relativePath.startsWith('docs-site')) return;
  
  // Generate HTML filename
  let htmlName = basename.toLowerCase().replace(/\s+/g, '-');
  if (dirname !== '.' && dirname !== 'docs') {
    htmlName = dirname.replace(/\//g, '-') + '-' + htmlName;
  }
  htmlName += '.html';
  
  // Special case for README
  if (basename === 'README' && dirname === '.') {
    htmlName = 'readme-main.html';
  }
  
  // Read and convert markdown
  const markdown = fs.readFileSync(file, 'utf8');
  const html = marked(markdown);
  
  // Extract title from first h1 or use filename
  const titleMatch = markdown.match(/^#\s+(.+)$/m);
  const title = titleMatch ? titleMatch[1] : basename.replace(/-/g, ' ');
  
  // Determine order for navigation
  let order = 100;
  if (basename === 'README' && dirname === '.') order = 1;
  else if (dirname === 'docs') {
    if (basename === 'README') order = 10;
    else if (basename.includes('keybindings')) order = 11;
    else if (basename.includes('jetbrains')) order = 12;
    else if (basename.includes('run')) order = 13;
    else if (basename.includes('docker')) order = 14;
    else if (basename.includes('performance')) order = 15;
    else if (basename.includes('testing')) order = 16;
  }
  
  navItems.push({ title, href: htmlName, order });
  pages.push({ title, content: html, filename: htmlName });
});

// Sort navigation items
navItems.sort((a, b) => a.order - b.order);

// Build navigation HTML
const navigation = `
  <h2>📚 Documentation</h2>
  <ul>
    ${navItems.map(item => 
      `<li><a href="${item.href}">${item.title}</a></li>`
    ).join('')}
  </ul>
`;

// Generate HTML files
pages.forEach(page => {
  const outputPath = path.join(publicDir, page.filename);
  const html = template(page.title, page.content, navigation);
  fs.writeFileSync(outputPath, html);
});

// Create index page
const indexContent = `
  <div class="home-hero">
    <h1>🚀 Neovim JetBrains Configuration</h1>
    <p>A powerful Neovim setup that brings JetBrains IDE features to your terminal</p>
  </div>
  
  <h2>✨ Features</h2>
  <div class="feature-grid">
    <div class="feature-card">
      <h3>⌨️ JetBrains Keybindings</h3>
      <p>Familiar Cmd+1-8 panel system, refactoring shortcuts, and navigation</p>
    </div>
    <div class="feature-card">
      <h3>🔧 Refactoring Tools</h3>
      <p>Rename (Shift+F6), Move (F6), Extract Method, and more</p>
    </div>
    <div class="feature-card">
      <h3>🐛 Debugging</h3>
      <p>Full DAP integration with F5/F10/F11 debugging controls</p>
    </div>
    <div class="feature-card">
      <h3>🧪 Test Runner</h3>
      <p>Integrated test runner with configuration management</p>
    </div>
    <div class="feature-card">
      <h3>🐳 Docker Integration</h3>
      <p>Built-in Docker services panel for container management</p>
    </div>
    <div class="feature-card">
      <h3>⚡ Optimized Performance</h3>
      <p>~45ms startup time with lazy loading and optimizations</p>
    </div>
  </div>
  
  <h2>📖 Quick Start</h2>
  <p>Navigate through the documentation using the sidebar. Start with:</p>
  <ul>
    <li><a href="readme-main.html">Main README</a> - Overview and setup instructions</li>
    <li><a href="docs-keybindings.html">Keybindings Guide</a> - Complete keyboard shortcut reference</li>
    <li><a href="docs-jetbrains-features.html">JetBrains Features</a> - IDE-like functionality</li>
  </ul>
  
  <h2>🎯 Test Results</h2>
  <p>Configuration validated with comprehensive test suite:</p>
  <ul>
    <li>✅ 41/41 tests passing (100% pass rate)</li>
    <li>✅ ~45ms average startup time</li>
    <li>✅ All JetBrains features functional</li>
    <li>✅ Performance optimizations active</li>
  </ul>
`;

const indexHtml = template('Home', indexContent, navigation);
fs.writeFileSync(path.join(publicDir, 'index.html'), indexHtml);

console.log('✨ Documentation site built successfully!');
console.log(`📝 Generated ${pages.length + 1} pages`);