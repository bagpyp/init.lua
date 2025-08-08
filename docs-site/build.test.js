const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Mock the file system for testing
jest.mock('fs');
jest.mock('child_process');

describe('Documentation Build Process', () => {
  const mockFiles = {
    '/Users/robbie/.config/nvim/README.md': '# Main README\nThis is the main readme.',
    '/Users/robbie/.config/nvim/docs/keybindings.md': '# Keybindings\nKeyboard shortcuts.',
    '/Users/robbie/.config/nvim/docs/jetbrains-features.md': '# JetBrains Features\nIDE features.',
    '/Users/robbie/.config/nvim/docs/performance.md': '# Performance\nOptimization guide.',
    '/Users/robbie/.config/nvim/docs/testing.md': '# Testing\nTest documentation.'
  };

  beforeEach(() => {
    // Reset mocks
    jest.clearAllMocks();
    
    // Mock fs.existsSync
    fs.existsSync.mockReturnValue(false);
    
    // Mock fs.mkdirSync
    fs.mkdirSync.mockImplementation(() => {});
    
    // Mock fs.readdirSync
    fs.readdirSync.mockImplementation((dir) => {
      if (dir.includes('docs-site')) return [];
      if (dir.includes('docs')) {
        return ['keybindings.md', 'jetbrains-features.md', 'performance.md', 'testing.md'];
      }
      return ['README.md', 'docs', 'lua', 'test'];
    });
    
    // Mock fs.statSync
    fs.statSync.mockImplementation((filePath) => ({
      isDirectory: () => !filePath.endsWith('.md'),
      isFile: () => filePath.endsWith('.md')
    }));
    
    // Mock fs.readFileSync
    fs.readFileSync.mockImplementation((filePath) => {
      // Find matching mock file
      for (const [mockPath, content] of Object.entries(mockFiles)) {
        if (filePath.includes(path.basename(mockPath))) {
          return content;
        }
      }
      return '# Default Content\nDefault markdown content.';
    });
    
    // Mock fs.writeFileSync
    fs.writeFileSync.mockImplementation(() => {});
  });

  describe('File Discovery', () => {
    test('should find all markdown files', () => {
      const build = require('./build');
      
      // Check that readdirSync was called
      expect(fs.readdirSync).toHaveBeenCalled();
    });

    test('should skip docs-site directory', () => {
      const build = require('./build');
      
      // Verify no files from docs-site were processed
      const writeCalls = fs.writeFileSync.mock.calls;
      const docsWritten = writeCalls.filter(call => 
        call[0].includes('docs-site')
      );
      
      // Should only write to public directory inside docs-site
      expect(docsWritten.every(call => call[0].includes('/public/'))).toBe(true);
    });

    test('should skip hidden directories', () => {
      fs.readdirSync.mockReturnValueOnce(['.git', '.github', 'docs']);
      
      const build = require('./build');
      
      // Hidden directories should not be processed
      expect(fs.statSync).not.toHaveBeenCalledWith(expect.stringContaining('.git'));
    });
  });

  describe('Markdown Processing', () => {
    test('should convert markdown to HTML', () => {
      const build = require('./build');
      
      // Check that files were written
      expect(fs.writeFileSync).toHaveBeenCalled();
      
      // Verify HTML conversion happened (check for HTML tags in output)
      const writeCalls = fs.writeFileSync.mock.calls;
      const htmlFiles = writeCalls.filter(call => call[0].endsWith('.html'));
      
      expect(htmlFiles.length).toBeGreaterThan(0);
    });

    test('should extract title from markdown h1', () => {
      const build = require('./build');
      
      // Check that proper titles were extracted
      const writeCalls = fs.writeFileSync.mock.calls;
      const indexWrite = writeCalls.find(call => call[0].includes('index.html'));
      
      if (indexWrite) {
        const content = indexWrite[1];
        expect(content).toContain('Keybindings');
        expect(content).toContain('Performance');
      }
    });

    test('should apply syntax highlighting to code blocks', () => {
      fs.readFileSync.mockReturnValueOnce(`
# Test File
\`\`\`javascript
const test = "hello";
console.log(test);
\`\`\`
      `);
      
      const build = require('./build');
      
      // Verify highlighted code appears in output
      const writeCalls = fs.writeFileSync.mock.calls;
      const hasHighlighting = writeCalls.some(call => 
        call[1].includes('hljs') || call[1].includes('highlight')
      );
      
      expect(hasHighlighting).toBe(true);
    });
  });

  describe('HTML Generation', () => {
    test('should create public directory if not exists', () => {
      fs.existsSync.mockReturnValueOnce(false);
      
      const build = require('./build');
      
      expect(fs.mkdirSync).toHaveBeenCalledWith(
        expect.stringContaining('public'),
        expect.objectContaining({ recursive: true })
      );
    });

    test('should generate navigation menu', () => {
      const build = require('./build');
      
      const writeCalls = fs.writeFileSync.mock.calls;
      const htmlFiles = writeCalls.filter(call => call[0].endsWith('.html'));
      
      // Check that navigation is included
      htmlFiles.forEach(([path, content]) => {
        expect(content).toContain('<nav>');
        expect(content).toContain('Documentation');
      });
    });

    test('should create index page with features', () => {
      const build = require('./build');
      
      const writeCalls = fs.writeFileSync.mock.calls;
      const indexWrite = writeCalls.find(call => call[0].includes('index.html'));
      
      expect(indexWrite).toBeDefined();
      expect(indexWrite[1]).toContain('JetBrains');
      expect(indexWrite[1]).toContain('Features');
      expect(indexWrite[1]).toContain('Quick Start');
    });

    test('should include CSS styling', () => {
      const build = require('./build');
      
      const writeCalls = fs.writeFileSync.mock.calls;
      const htmlFiles = writeCalls.filter(call => call[0].endsWith('.html'));
      
      htmlFiles.forEach(([path, content]) => {
        expect(content).toContain('<style>');
        expect(content).toContain('linear-gradient');
      });
    });
  });

  describe('Output Validation', () => {
    test('should generate correct number of pages', () => {
      const build = require('./build');
      
      const writeCalls = fs.writeFileSync.mock.calls;
      const htmlFiles = writeCalls.filter(call => call[0].endsWith('.html'));
      
      // Should have at least index + markdown files
      expect(htmlFiles.length).toBeGreaterThanOrEqual(Object.keys(mockFiles).length);
    });

    test('should handle special characters in filenames', () => {
      fs.readdirSync.mockReturnValueOnce(['test-file.md', 'another_file.md']);
      
      const build = require('./build');
      
      const writeCalls = fs.writeFileSync.mock.calls;
      const htmlFiles = writeCalls.map(call => path.basename(call[0]));
      
      // Check that files are properly named
      expect(htmlFiles.some(f => f.includes('test-file'))).toBe(true);
    });

    test('should log success message', () => {
      const consoleSpy = jest.spyOn(console, 'log').mockImplementation();
      
      const build = require('./build');
      
      expect(consoleSpy).toHaveBeenCalledWith(
        expect.stringContaining('Documentation site built successfully')
      );
      
      consoleSpy.mockRestore();
    });
  });
});