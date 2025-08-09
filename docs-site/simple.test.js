const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

describe('Documentation Site Tests', () => {
  describe('Build Process', () => {
    test('build script exists', () => {
      const buildPath = path.join(__dirname, 'build.js');
      expect(fs.existsSync(buildPath)).toBe(true);
    });

    test('can run build without errors', () => {
      const result = execSync('node build.js', { 
        cwd: __dirname,
        encoding: 'utf8' 
      });
      expect(result).toContain('Documentation site built successfully');
    });

    test('creates public directory', () => {
      const publicPath = path.join(__dirname, 'public');
      expect(fs.existsSync(publicPath)).toBe(true);
    });

    test('generates HTML files', () => {
      const publicPath = path.join(__dirname, 'public');
      const files = fs.readdirSync(publicPath);
      const htmlFiles = files.filter(f => f.endsWith('.html'));
      expect(htmlFiles.length).toBeGreaterThan(0);
    });

    test('generates index.html', () => {
      const indexPath = path.join(__dirname, 'public', 'index.html');
      expect(fs.existsSync(indexPath)).toBe(true);
    });

    test('index.html has correct structure', () => {
      const indexPath = path.join(__dirname, 'public', 'index.html');
      const content = fs.readFileSync(indexPath, 'utf8');
      
      expect(content).toContain('<!DOCTYPE html>');
      expect(content).toContain('Neovim');
      expect(content).toContain('<nav>');
      expect(content).toContain('Documentation');
    });

    test('includes CSS styling', () => {
      const indexPath = path.join(__dirname, 'public', 'index.html');
      const content = fs.readFileSync(indexPath, 'utf8');
      
      expect(content).toContain('<style>');
      expect(content).toContain('linear-gradient');
      expect(content).toContain('#667eea');
    });

    test('includes navigation links', () => {
      const indexPath = path.join(__dirname, 'public', 'index.html');
      const content = fs.readFileSync(indexPath, 'utf8');
      
      expect(content).toContain('<a href=');
      expect(content).toContain('.html');
    });
  });

  describe('Server', () => {
    test('server script exists', () => {
      const serverPath = path.join(__dirname, 'server.js');
      expect(fs.existsSync(serverPath)).toBe(true);
    });

    test('package.json has required dependencies', () => {
      const packagePath = path.join(__dirname, 'package.json');
      const packageJson = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
      
      expect(packageJson.dependencies).toHaveProperty('express');
      expect(packageJson.dependencies).toHaveProperty('marked');
      expect(packageJson.dependencies['highlight.js']).toBeDefined();
    });

    test('package.json has test scripts', () => {
      const packagePath = path.join(__dirname, 'package.json');
      const packageJson = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
      
      expect(packageJson.scripts).toHaveProperty('test');
      expect(packageJson.scripts).toHaveProperty('build');
      expect(packageJson.scripts).toHaveProperty('dev');
      expect(packageJson.scripts).toHaveProperty('start');
    });

    test('Node version requirement is set', () => {
      const packagePath = path.join(__dirname, 'package.json');
      const packageJson = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
      
      expect(packageJson.engines).toHaveProperty('node');
      expect(packageJson.engines.node).toContain('20');
    });
  });

  describe('Generated Content', () => {
    test('converts markdown to HTML', () => {
      const publicFiles = fs.readdirSync(path.join(__dirname, 'public'));
      const htmlFiles = publicFiles.filter(f => f.endsWith('.html'));
      
      // Check at least one file for converted markdown
      if (htmlFiles.length > 1) { // Skip just index
        const sampleFile = htmlFiles.find(f => f !== 'index.html');
        if (sampleFile) {
          const content = fs.readFileSync(
            path.join(__dirname, 'public', sampleFile), 
            'utf8'
          );
          // Should have paragraph tags from markdown conversion
          expect(content).toMatch(/<[hp]\d?>/);
        }
      }
    });

    test('includes syntax highlighting', () => {
      const indexPath = path.join(__dirname, 'public', 'index.html');
      const content = fs.readFileSync(indexPath, 'utf8');
      
      expect(content).toContain('highlight.js');
      expect(content).toContain('github-dark');
    });

    test('responsive design is included', () => {
      const indexPath = path.join(__dirname, 'public', 'index.html');
      const content = fs.readFileSync(indexPath, 'utf8');
      
      expect(content).toContain('@media');
      expect(content).toContain('max-width');
      expect(content).toContain('grid-template-columns');
    });

    test('feature cards are present', () => {
      const indexPath = path.join(__dirname, 'public', 'index.html');
      const content = fs.readFileSync(indexPath, 'utf8');
      
      expect(content).toContain('feature-card');
      expect(content).toContain('JetBrains');
      expect(content).toContain('Refactoring');
    });
  });

  describe('Documentation Coverage', () => {
    test('README is processed', () => {
      const publicFiles = fs.readdirSync(path.join(__dirname, 'public'));
      const readmeFile = publicFiles.find(f => 
        f.toLowerCase().includes('readme') && f.endsWith('.html')
      );
      expect(readmeFile).toBeDefined();
    });

    test('multiple documentation pages exist', () => {
      const publicFiles = fs.readdirSync(path.join(__dirname, 'public'));
      const htmlFiles = publicFiles.filter(f => f.endsWith('.html'));
      
      // Should have at least index + some docs
      expect(htmlFiles.length).toBeGreaterThanOrEqual(2);
    });

    test('navigation includes key documentation pages', () => {
      const indexPath = path.join(__dirname, 'public', 'index.html');
      const content = fs.readFileSync(indexPath, 'utf8');
      
      // Check that navigation exists and has important pages
      expect(content).toContain('<nav>');
      expect(content).toContain('readme-main.html');
      
      // Check navigation has multiple links
      const linkMatches = content.match(/<a href="[^"]+\.html"/g) || [];
      expect(linkMatches.length).toBeGreaterThanOrEqual(5);
      
      // Check key sections are linked
      const keyPages = ['readme-main', 'keymap-cheatsheet', 'docs-workflows'];
      keyPages.forEach(page => {
        const hasPage = content.includes(`${page}`) || 
                       content.includes(page.replace('-', ' '));
        expect(hasPage).toBe(true);
      });
    });
  });
});