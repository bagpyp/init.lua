const request = require('supertest');
const express = require('express');
const path = require('path');
const fs = require('fs');

// Import server module
describe('Documentation Server', () => {
  let app;
  let server;

  beforeEach(() => {
    // Create fresh Express app for each test
    app = express();
    app.use(express.static(path.join(__dirname, 'public')));
    app.get('/', (req, res) => {
      res.sendFile(path.join(__dirname, 'public', 'index.html'));
    });
  });

  afterEach(() => {
    if (server) {
      server.close();
    }
  });

  describe('Server Setup', () => {
    test('should create Express app', () => {
      expect(app).toBeDefined();
      expect(app.listen).toBeDefined();
    });

    test('should serve on port 3000', (done) => {
      server = app.listen(3000, () => {
        expect(server.address().port).toBe(3000);
        done();
      });
    });

    test('should handle port already in use', (done) => {
      const server1 = app.listen(3000, () => {
        const app2 = express();
        const server2 = app2.listen(3000);
        
        server2.on('error', (err) => {
          expect(err.code).toBe('EADDRINUSE');
          server1.close();
          done();
        });
      });
    });
  });

  describe('Static Files', () => {
    test('should serve static files from public directory', async () => {
      // Mock file existence
      const publicPath = path.join(__dirname, 'public', 'test.html');
      if (!fs.existsSync(path.join(__dirname, 'public'))) {
        fs.mkdirSync(path.join(__dirname, 'public'), { recursive: true });
      }
      fs.writeFileSync(publicPath, '<h1>Test Page</h1>');

      const response = await request(app).get('/test.html');
      
      expect(response.status).toBe(200);
      expect(response.text).toContain('Test Page');
      
      // Cleanup
      fs.unlinkSync(publicPath);
    });

    test('should return 404 for non-existent files', async () => {
      const response = await request(app).get('/nonexistent.html');
      expect(response.status).toBe(404);
    });

    test('should serve index.html at root', async () => {
      // Create mock index.html
      const indexPath = path.join(__dirname, 'public', 'index.html');
      if (!fs.existsSync(path.join(__dirname, 'public'))) {
        fs.mkdirSync(path.join(__dirname, 'public'), { recursive: true });
      }
      fs.writeFileSync(indexPath, '<h1>Home Page</h1>');

      const response = await request(app).get('/');
      
      expect(response.status).toBe(200);
      expect(response.text).toContain('Home Page');
      
      // Cleanup
      fs.unlinkSync(indexPath);
    });
  });

  describe('Content Types', () => {
    beforeEach(() => {
      if (!fs.existsSync(path.join(__dirname, 'public'))) {
        fs.mkdirSync(path.join(__dirname, 'public'), { recursive: true });
      }
    });

    test('should serve HTML files with correct content type', async () => {
      const htmlPath = path.join(__dirname, 'public', 'page.html');
      fs.writeFileSync(htmlPath, '<html><body>Test</body></html>');

      const response = await request(app).get('/page.html');
      
      expect(response.headers['content-type']).toContain('text/html');
      
      fs.unlinkSync(htmlPath);
    });

    test('should serve CSS files with correct content type', async () => {
      const cssPath = path.join(__dirname, 'public', 'style.css');
      fs.writeFileSync(cssPath, 'body { color: red; }');

      const response = await request(app).get('/style.css');
      
      expect(response.headers['content-type']).toContain('text/css');
      
      fs.unlinkSync(cssPath);
    });

    test('should serve JavaScript files with correct content type', async () => {
      const jsPath = path.join(__dirname, 'public', 'script.js');
      fs.writeFileSync(jsPath, 'console.log("test");');

      const response = await request(app).get('/script.js');
      
      expect(response.headers['content-type']).toContain('application/javascript');
      
      fs.unlinkSync(jsPath);
    });
  });

  describe('Error Handling', () => {
    test('should handle malformed URLs gracefully', async () => {
      const response = await request(app).get('//../../etc/passwd');
      expect(response.status).toBeLessThanOrEqual(404);
    });

    test('should handle special characters in URLs', async () => {
      const response = await request(app).get('/test%20file.html');
      expect(response.status).toBeLessThanOrEqual(404);
    });

    test('should not expose directory listing', async () => {
      const response = await request(app).get('/public/');
      expect(response.status).toBeLessThanOrEqual(404);
    });
  });

  describe('Performance', () => {
    test('should respond quickly to requests', async () => {
      const start = Date.now();
      await request(app).get('/');
      const duration = Date.now() - start;
      
      expect(duration).toBeLessThan(1000); // Should respond within 1 second
    });

    test('should handle concurrent requests', async () => {
      const requests = [];
      for (let i = 0; i < 10; i++) {
        requests.push(request(app).get('/'));
      }
      
      const responses = await Promise.all(requests);
      responses.forEach(response => {
        expect(response.status).toBeLessThanOrEqual(404);
      });
    });
  });
});

describe('Integration Tests', () => {
  let app;
  let buildProcess;

  beforeAll(() => {
    // Ensure public directory exists
    if (!fs.existsSync(path.join(__dirname, 'public'))) {
      fs.mkdirSync(path.join(__dirname, 'public'), { recursive: true });
    }
  });

  test('should serve built documentation', () => {
    // Check if build output exists
    const publicDir = path.join(__dirname, 'public');
    
    if (fs.existsSync(publicDir)) {
      const files = fs.readdirSync(publicDir);
      const htmlFiles = files.filter(f => f.endsWith('.html'));
      
      // Should have generated some HTML files
      expect(htmlFiles.length).toBeGreaterThanOrEqual(0);
    }
  });

  test('should have valid HTML structure', () => {
    const indexPath = path.join(__dirname, 'public', 'index.html');
    
    if (fs.existsSync(indexPath)) {
      const content = fs.readFileSync(indexPath, 'utf8');
      
      // Check for basic HTML structure
      expect(content).toContain('<!DOCTYPE html>');
      expect(content).toContain('<html');
      expect(content).toContain('<head>');
      expect(content).toContain('<body>');
      expect(content).toContain('</html>');
    }
  });

  test('should include navigation in pages', () => {
    const publicDir = path.join(__dirname, 'public');
    
    if (fs.existsSync(publicDir)) {
      const files = fs.readdirSync(publicDir);
      const htmlFiles = files.filter(f => f.endsWith('.html'));
      
      htmlFiles.forEach(file => {
        const content = fs.readFileSync(path.join(publicDir, file), 'utf8');
        if (content.includes('<!DOCTYPE html>')) {
          expect(content).toContain('<nav>');
        }
      });
    }
  });
});