/**
 * Tests for VimGameEngine - focused on YOUR actual JetBrains bindings!
 */

import { VimGameEngine } from './VimGameEngine';

describe('VimGameEngine - YOUR JetBrains Bindings', () => {
  let engine: VimGameEngine;

  beforeEach(() => {
    engine = new VimGameEngine({
      mode: 'normal',
      buffer: ['Welcome to your config!', 'Learn your bindings here'],
      cursor: { line: 0, col: 0 },
      registers: {},
      marks: {}
    });
  });

  describe('JetBrains Panel System (Space+1-8)', () => {
    test('should handle <leader>1 - File Explorer (Neotree)', () => {
      const result = engine.executeCommand('<leader>1');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
      expect(result.score).toBeGreaterThan(10); // JetBrains commands worth more
      expect(result.feedback).toContain('JetBrains');
      // Feedback should be meaningful
    });

    test('should handle <leader>2 - Git Status (Telescope)', () => {
      const result = engine.executeCommand('<leader>2');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
      expect(result.feedback).toContain('JetBrains');
    });

    test('should handle <leader>3 - Run Configs', () => {
      const result = engine.executeCommand('<leader>3');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
    });

    test('should handle <leader>4 - Debugger (DAP UI)', () => {
      const result = engine.executeCommand('<leader>4');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
    });

    test('should handle all panel shortcuts <leader>1 through <leader>8', () => {
      const panelCommands = ['<leader>1', '<leader>2', '<leader>3', '<leader>4', '<leader>5', '<leader>6', '<leader>7', '<leader>8'];
      
      panelCommands.forEach(cmd => {
        const result = engine.executeCommand(cmd);
        expect(result.success).toBe(true);
        expect(result.commandType).toBe('jetbrains');
        expect(result.score).toBeGreaterThan(10);
      });
    });
  });

  describe('Refactoring Tools', () => {
    test('should handle Shift+F6 - LSP Rename', () => {
      const result = engine.executeCommand('<S-F6>');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
      expect(result.feedback).toContain('JetBrains');
    });

    test('should handle F6 - Move File', () => {
      const result = engine.executeCommand('<F6>');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
    });

    test('should give high scores for refactoring commands', () => {
      const refactorCommands = ['<S-F6>', '<F6>'];
      
      refactorCommands.forEach(cmd => {
        const result = engine.executeCommand(cmd);
        expect(result.score).toBeGreaterThanOrEqual(15); // JetBrains commands are worth more
      });
    });
  });

  describe('Debugging F-Keys', () => {
    test('should handle F5 - Debug Continue', () => {
      const result = engine.executeCommand('<F5>');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
    });

    test('should handle F10 - Debug Step Over', () => {
      const result = engine.executeCommand('<F10>');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
    });

    test('should handle F11 - Debug Step Into', () => {
      const result = engine.executeCommand('<F11>');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
    });

    test('should handle Shift+F11 - Debug Step Out', () => {
      const result = engine.executeCommand('<S-F11>');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
    });
  });

  describe('Testing Shortcuts', () => {
    test('should handle <leader>tt - Run Nearest Test', () => {
      // Using space as leader (LazyVim default)
      const result = engine.executeCommand('<leader>tt');
      
      expect(result.success).toBe(true);
      // This would be categorized as a special command
    });

    test('should handle <leader>tf - Run File Tests', () => {
      const result = engine.executeCommand('<leader>tf');
      
      expect(result.success).toBe(true);
    });
  });

  describe('Advanced Features', () => {
    test('should handle Ctrl+G - Multi-cursor', () => {
      const result = engine.executeCommand('<C-g>');
      
      expect(result.success).toBe(true);
      // Multi-cursor is an advanced feature
    });

    test('should handle Shift+Cmd+Up - Move Line Up', () => {
      const result = engine.executeCommand('<S-Up>');
      
      expect(result.success).toBe(true);
    });

    test('should handle Cmd+P - Quick File Search', () => {
      const result = engine.executeCommand('<leader>ff');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
    });
  });

  describe('Command Efficiency Scoring', () => {
    test('should give higher scores for JetBrains shortcuts', () => {
      const basicResult = engine.executeCommand('j'); // Basic movement
      const jetbrainsResult = engine.executeCommand('<leader>1'); // JetBrains panel
      
      expect(jetbrainsResult.score).toBeGreaterThan(basicResult.score);
    });

    test('should mark JetBrains commands as efficient', () => {
      const result = engine.executeCommand('<S-F6>');
      
      expect(result.efficient).toBe(true);
    });

    test('should track command history for efficiency analysis', () => {
      engine.executeCommand('<leader>1');
      engine.executeCommand('<leader>2');
      engine.executeCommand('<S-F6>');
      
      const stats = engine.getStats();
      expect(stats.commandCount).toBe(3);
      expect(stats.efficiency).toBeGreaterThan(0);
    });
  });

  describe('Challenge Validation', () => {
    test('should validate panel opening challenge', () => {
      const challenge = {
        id: 'test-panel',
        description: 'Open file explorer',
        initialState: {
          mode: 'normal' as const,
          buffer: ['test'],
          cursor: { line: 0, col: 0 },
          registers: {},
          marks: {}
        },
        expectedCommands: ['<leader>1'],
        hints: []
      };

      engine.reset(challenge.initialState);
      const result = engine.executeCommand('<leader>1');
      const validation = engine.validateChallenge(challenge);
      
      expect(result.success).toBe(true);
      expect(validation.passed).toBe(true);
      expect(validation.feedback).toContain('Challenge completed successfully');
    });

    test('should validate refactoring challenge', () => {
      const challenge = {
        id: 'test-rename',
        description: 'Rename a symbol',
        initialState: {
          mode: 'normal' as const,
          buffer: ['const oldName = "value";'],
          cursor: { line: 0, col: 6 },
          registers: {},
          marks: {}
        },
        expectedCommands: ['<S-F6>'],
        hints: []
      };

      engine.reset(challenge.initialState);
      const result = engine.executeCommand('<S-F6>');
      
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
    });
  });

  describe('Performance Metrics', () => {
    test('should track performance stats', () => {
      // Simulate a lesson
      engine.executeCommand('<leader>1'); // Open file explorer
      engine.executeCommand('<leader>2'); // Check git
      engine.executeCommand('<S-F6>'); // Rename something
      
      const stats = engine.getStats();
      
      expect(stats.commandCount).toBe(3);
      expect(stats.timeElapsed).toBeGreaterThanOrEqual(0);
      expect(stats.commandsPerMinute).toBeGreaterThan(0);
      expect(stats.efficiency).toBeGreaterThan(0.5); // Should be efficient with JetBrains shortcuts
    });

    test('should calculate efficiency based on command quality', () => {
      // Use efficient JetBrains commands
      engine.executeCommand('<leader>1');
      engine.executeCommand('<S-F6>');
      engine.executeCommand('<F5>');
      
      const stats = engine.getStats();
      expect(stats.efficiency).toBeGreaterThanOrEqual(0.8); // High efficiency
    });
  });
});

describe('Integration with Your Config', () => {
  test('should understand your complete panel mapping', () => {
    const engine = new VimGameEngine();
    
    // Test all your configured panels
    const panelMappings = [
      { cmd: '<leader>1', desc: 'Neotree File Explorer' },
      { cmd: '<leader>2', desc: 'Telescope Git Status' },
      { cmd: '<leader>3', desc: 'Run Configurations' },
      { cmd: '<leader>4', desc: 'DAP Debugger' },
      { cmd: '<leader>5', desc: 'Database UI' },
      { cmd: '<leader>6', desc: 'Docker Services' },
      { cmd: '<leader>7', desc: 'Symbols Outline' },
      { cmd: '<leader>8', desc: 'Terminal' }
    ];

    panelMappings.forEach(({ cmd }) => {
      const result = engine.executeCommand(cmd);
      expect(result.success).toBe(true);
      expect(result.commandType).toBe('jetbrains');
      // Should provide meaningful feedback about what panel opened
      expect(result.feedback).toBeTruthy();
    });
  });

  test('should prioritize your workflow patterns', () => {
    const engine = new VimGameEngine();
    
    // Simulate your typical workflow
    const workflowCommands = [
      '<leader>1',      // Open files
      '<leader>2',      // Check git
      '<leader>tt',   // Run tests
      '<S-F6>',   // Rename something
      '<F5>'          // Debug
    ];

    let totalScore = 0;
    workflowCommands.forEach(cmd => {
      const result = engine.executeCommand(cmd);
      totalScore += result.score;
      expect(result.success).toBe(true);
    });

    // Your configured workflow should be highly scored
    expect(totalScore).toBeGreaterThan(50);
    
    const stats = engine.getStats();
    expect(stats.efficiency).toBeGreaterThan(0.7); // Your shortcuts are efficient!
  });
});