/**
 * VimGameEngine - Core game logic for vim command processing and validation
 * 
 * This is the heart of VimGame that simulates vim behavior, validates commands,
 * calculates scores, and manages game state.
 */

export interface VimState {
  mode: 'normal' | 'insert' | 'visual' | 'command';
  buffer: string[];
  cursor: { line: number; col: number };
  selection?: { start: { line: number; col: number }; end: { line: number; col: number } };
  registers: Record<string, string>;
  marks: Record<string, { line: number; col: number }>;
  lastCommand?: string;
  dotRegister?: string; // For repeat with .
}

export interface CommandResult {
  success: boolean;
  newState: VimState;
  score: number;
  feedback: string;
  efficient: boolean;
  commandType: 'movement' | 'edit' | 'visual' | 'search' | 'jetbrains';
}

export interface Challenge {
  id: string;
  description: string;
  initialState: VimState;
  expectedCommands?: string[];
  expectedState?: Partial<VimState>;
  maxCommands?: number;
  timeLimit?: number;
  hints: Array<{ delay: number; text: string }>;
}

export class VimGameEngine {
  private state: VimState;
  private commandHistory: string[] = [];
  private startTime: number = Date.now();

  constructor(initialState?: Partial<VimState>) {
    this.state = {
      mode: 'normal',
      buffer: [''],
      cursor: { line: 0, col: 0 },
      registers: {},
      marks: {},
      ...initialState
    };
  }

  /**
   * Execute a vim command and return the result
   */
  executeCommand(command: string): CommandResult {
    this.commandHistory.push(command);
    const oldState = JSON.parse(JSON.stringify(this.state));
    
    try {
      const result = this.processCommand(command);
      const score = this.calculateScore(command, result);
      
      return {
        success: true,
        newState: this.state,
        score,
        feedback: this.generateFeedback(command, result),
        efficient: this.isEfficient(command),
        commandType: this.getCommandType(command)
      };
    } catch (error) {
      // Revert state on error
      this.state = oldState;
      return {
        success: false,
        newState: this.state,
        score: 0,
        feedback: `Invalid command: ${command}`,
        efficient: false,
        commandType: this.getCommandType(command)
      };
    }
  }

  /**
   * Process individual vim commands
   */
  private processCommand(command: string): any {
    // Handle different vim modes and commands
    if (this.state.mode === 'normal') {
      return this.processNormalModeCommand(command);
    } else if (this.state.mode === 'insert') {
      return this.processInsertModeCommand(command);
    } else if (this.state.mode === 'visual') {
      return this.processVisualModeCommand(command);
    }
    
    throw new Error(`Unknown mode: ${this.state.mode}`);
  }

  /**
   * Process normal mode commands (movement, editing, etc.)
   */
  private processNormalModeCommand(command: string): any {
    const { cursor, buffer } = this.state;
    
    // Movement commands
    if (command === 'h' && cursor.col > 0) {
      this.state.cursor.col--;
      return { type: 'movement', direction: 'left' };
    }
    
    if (command === 'l' && cursor.col < buffer[cursor.line]?.length - 1) {
      this.state.cursor.col++;
      return { type: 'movement', direction: 'right' };
    }
    
    if (command === 'j' && cursor.line < buffer.length - 1) {
      this.state.cursor.line++;
      this.state.cursor.col = Math.min(cursor.col, buffer[this.state.cursor.line].length - 1);
      return { type: 'movement', direction: 'down' };
    }
    
    if (command === 'k' && cursor.line > 0) {
      this.state.cursor.line--;
      this.state.cursor.col = Math.min(cursor.col, buffer[this.state.cursor.line].length - 1);
      return { type: 'movement', direction: 'up' };
    }

    // Word movement
    if (command === 'w') {
      this.moveToNextWord();
      return { type: 'movement', direction: 'word-forward' };
    }
    
    if (command === 'b') {
      this.moveToPreviousWord();
      return { type: 'movement', direction: 'word-backward' };
    }

    // Line movement
    if (command === '0') {
      this.state.cursor.col = 0;
      return { type: 'movement', direction: 'line-start' };
    }
    
    if (command === '$') {
      this.state.cursor.col = Math.max(0, buffer[cursor.line].length - 1);
      return { type: 'movement', direction: 'line-end' };
    }

    // Editing commands
    if (command === 'x') {
      this.deleteCharacter();
      return { type: 'edit', action: 'delete-char' };
    }
    
    if (command === 'dd') {
      this.deleteLine();
      return { type: 'edit', action: 'delete-line' };
    }
    
    if (command === 'i') {
      this.state.mode = 'insert';
      return { type: 'mode-change', mode: 'insert' };
    }
    
    if (command === 'a') {
      this.state.mode = 'insert';
      this.state.cursor.col++;
      return { type: 'mode-change', mode: 'insert' };
    }

    // JetBrains-style commands - YOUR ACTUAL BINDINGS!
    if (command === '<leader>1') {
      return { type: 'jetbrains', panel: 'files' };
    }
    if (command === '<leader>2') {
      return { type: 'jetbrains', panel: 'git' };
    }
    if (command === '<leader>3') {
      return { type: 'jetbrains', panel: 'run' };
    }
    if (command === '<leader>4') {
      return { type: 'jetbrains', panel: 'debug' };
    }
    if (command === '<leader>5') {
      return { type: 'jetbrains', panel: 'database' };
    }
    if (command === '<leader>6') {
      return { type: 'jetbrains', panel: 'docker' };
    }
    if (command === '<leader>7') {
      return { type: 'jetbrains', panel: 'structure' };
    }
    if (command === '<leader>8') {
      return { type: 'jetbrains', panel: 'terminal' };
    }
    
    // Refactoring commands
    if (command === '<S-F6>') {
      return { type: 'jetbrains', action: 'rename' };
    }
    if (command === '<F6>') {
      return { type: 'jetbrains', action: 'move-file' };
    }
    
    // Debug F-keys
    if (command === '<F5>') {
      return { type: 'jetbrains', action: 'debug-continue' };
    }
    if (command === '<F10>') {
      return { type: 'jetbrains', action: 'debug-step-over' };
    }
    if (command === '<F11>') {
      return { type: 'jetbrains', action: 'debug-step-into' };
    }
    if (command === '<S-F11>') {
      return { type: 'jetbrains', action: 'debug-step-out' };
    }
    
    // Testing commands
    if (command === '<leader>tt') {
      return { type: 'jetbrains', action: 'test-nearest' };
    }
    if (command === '<leader>tf') {
      return { type: 'jetbrains', action: 'test-file' };
    }
    
    // Advanced features
    if (command === '<C-g>') {
      return { type: 'jetbrains', action: 'multi-cursor' };
    }
    if (command === '<S-Up>') {
      return { type: 'jetbrains', action: 'move-line-up' };
    }
    if (command === '<leader>ff') {
      return { type: 'jetbrains', action: 'find-files' };
    }

    throw new Error(`Unknown command: ${command}`);
  }

  /**
   * Process insert mode commands
   */
  private processInsertModeCommand(command: string): any {
    if (command === '<Esc>') {
      this.state.mode = 'normal';
      if (this.state.cursor.col > 0) {
        this.state.cursor.col--;
      }
      return { type: 'mode-change', mode: 'normal' };
    }
    
    // Regular character input
    if (command.length === 1) {
      this.insertCharacter(command);
      return { type: 'insert', char: command };
    }
    
    throw new Error(`Unknown insert command: ${command}`);
  }

  /**
   * Process visual mode commands
   */
  private processVisualModeCommand(_command: string): any {
    // Visual mode implementation
    throw new Error('Visual mode not implemented yet');
  }

  /**
   * Helper methods for vim operations
   */
  private moveToNextWord() {
    const { cursor, buffer } = this.state;
    const line = buffer[cursor.line];
    let col = cursor.col;
    
    // Skip current word
    while (col < line.length && /\w/.test(line[col])) {
      col++;
    }
    
    // Skip whitespace
    while (col < line.length && /\s/.test(line[col])) {
      col++;
    }
    
    this.state.cursor.col = Math.min(col, line.length - 1);
  }

  private moveToPreviousWord() {
    const { cursor, buffer } = this.state;
    const line = buffer[cursor.line];
    let col = cursor.col;
    
    if (col > 0) col--;
    
    // Skip whitespace
    while (col > 0 && /\s/.test(line[col])) {
      col--;
    }
    
    // Skip to beginning of word
    while (col > 0 && /\w/.test(line[col - 1])) {
      col--;
    }
    
    this.state.cursor.col = col;
  }

  private deleteCharacter() {
    const { cursor, buffer } = this.state;
    const line = buffer[cursor.line];
    
    if (cursor.col < line.length) {
      buffer[cursor.line] = line.slice(0, cursor.col) + line.slice(cursor.col + 1);
    }
  }

  private deleteLine() {
    const { cursor, buffer } = this.state;
    
    if (buffer.length > 1) {
      buffer.splice(cursor.line, 1);
      if (cursor.line >= buffer.length) {
        this.state.cursor.line = buffer.length - 1;
      }
    } else {
      buffer[0] = '';
    }
    
    this.state.cursor.col = Math.min(cursor.col, buffer[cursor.line].length - 1);
  }

  private insertCharacter(char: string) {
    const { cursor, buffer } = this.state;
    const line = buffer[cursor.line];
    
    buffer[cursor.line] = line.slice(0, cursor.col) + char + line.slice(cursor.col);
    this.state.cursor.col++;
  }

  /**
   * Calculate score based on command efficiency and accuracy
   */
  private calculateScore(command: string, result: any): number {
    let score = 10; // Base score
    
    // Bonus for efficient commands
    if (this.isEfficient(command)) {
      score += 5;
    }
    
    // Bonus for command type
    if (result.type === 'movement') {
      score += 2;
    } else if (result.type === 'edit') {
      score += 5;
    } else if (result.type === 'jetbrains') {
      score += 10; // JetBrains commands are worth more
    }
    
    // Penalty for excessive commands
    if (this.commandHistory.length > 20) {
      score = Math.max(1, score - 2);
    }
    
    return score;
  }

  /**
   * Check if a command is efficient (not redundant)
   */
  private isEfficient(command: string): boolean {
    const recent = this.commandHistory.slice(-3);
    
    // Redundant movement
    if (recent.includes('h') && recent.includes('l')) return false;
    if (recent.includes('j') && recent.includes('k')) return false;
    
    // JetBrains commands are always efficient!
    if (this.getCommandType(command) === 'jetbrains') return true;
    
    // Efficient patterns
    if (['w', 'b', '0', '$', 'gg', 'G'].includes(command)) return true;
    
    return true;
  }

  /**
   * Categorize command type for scoring and achievements
   */
  private getCommandType(command: string): 'movement' | 'edit' | 'visual' | 'search' | 'jetbrains' {
    if (['h', 'j', 'k', 'l', 'w', 'b', '0', '$', 'gg', 'G'].includes(command)) {
      return 'movement';
    }
    
    if (['x', 'dd', 'yy', 'p', 'u', 'r'].includes(command)) {
      return 'edit';
    }
    
    if (command.includes('<leader>') || command.includes('<S-F') || command.includes('<F') || command.includes('<C-g>') || command.includes('<S-Up>')) {
      return 'jetbrains';
    }
    
    if (command.startsWith('/') || command.startsWith('?')) {
      return 'search';
    }
    
    return 'movement';
  }

  /**
   * Generate helpful feedback for the user
   */
  private generateFeedback(command: string, _result: any): string {
    const feedbackMap: Record<string, string> = {
      'h': 'Good! You moved left.',
      'l': 'Nice! You moved right.',
      'j': 'Great! You moved down.',
      'k': 'Excellent! You moved up.',
      'w': 'Perfect! Word movement is efficient.',
      'b': 'Nice! Moving back by word.',
      '0': 'Great! Jump to line start.',
      '$': 'Excellent! Jump to line end.',
      'x': 'Good delete! Character removed.',
      'dd': 'Perfect! Whole line deleted.',
      '<leader>1': '🎯 JetBrains shortcut! Files panel opened.',
      '<leader>2': '🎯 JetBrains shortcut! Git status opened.',
      '<leader>3': '🎯 JetBrains shortcut! Run configs opened.',
      '<leader>4': '🎯 JetBrains shortcut! Debugger opened.',
      '<leader>5': '🎯 JetBrains shortcut! Database opened.',
      '<leader>6': '🎯 JetBrains shortcut! Docker services opened.',
      '<leader>7': '🎯 JetBrains shortcut! Structure panel opened.',
      '<leader>8': '🎯 JetBrains shortcut! Terminal opened.',
      '<S-F6>': '🚀 JetBrains rename! Very efficient!',
      '<F6>': '🚀 JetBrains move file! Professional workflow!',
      '<F5>': '🚀 Debug continue! F-key efficiency!',
      '<F10>': '🚀 Debug step over! F-key mastery!',
      '<F11>': '🚀 Debug step into! Perfect debugging!',
      '<S-F11>': '🚀 Debug step out! Advanced debugging!',
      '<leader>tt': '🧪 Run nearest test! Testing pro!',
      '<leader>tf': '🧪 Run file tests! Test master!',
      '<C-g>': '🎯 Multi-cursor activated! Power user move!',
      '<S-Up>': '⬆️ Line moved up! Efficient editing!',
      '<leader>ff': '🔍 File search opened! Quick navigation!'
    };
    
    return feedbackMap[command] || `Command executed: ${command}`;
  }

  /**
   * Validate if current state matches expected challenge outcome
   */
  validateChallenge(challenge: Challenge): { passed: boolean; feedback: string } {
    if (challenge.expectedState) {
      const { cursor, buffer, mode } = challenge.expectedState;
      
      if (cursor && (cursor.line !== this.state.cursor.line || cursor.col !== this.state.cursor.col)) {
        return { 
          passed: false, 
          feedback: `Cursor should be at line ${cursor.line}, column ${cursor.col}` 
        };
      }
      
      if (buffer && JSON.stringify(buffer) !== JSON.stringify(this.state.buffer)) {
        return { 
          passed: false, 
          feedback: 'Buffer content doesn\'t match expected result' 
        };
      }
      
      if (mode && mode !== this.state.mode) {
        return { 
          passed: false, 
          feedback: `Should be in ${mode} mode` 
        };
      }
    }
    
    return { passed: true, feedback: 'Challenge completed successfully! 🎉' };
  }

  /**
   * Get current game state
   */
  getState(): VimState {
    return JSON.parse(JSON.stringify(this.state));
  }

  /**
   * Reset to initial state
   */
  reset(initialState: Partial<VimState>) {
    this.state = {
      mode: 'normal',
      buffer: [''],
      cursor: { line: 0, col: 0 },
      registers: {},
      marks: {},
      ...initialState
    };
    this.commandHistory = [];
    this.startTime = Date.now();
  }

  /**
   * Get performance stats
   */
  getStats() {
    return {
      commandCount: this.commandHistory.length,
      timeElapsed: Date.now() - this.startTime,
      commandsPerMinute: (this.commandHistory.length / ((Date.now() - this.startTime) / 60000)),
      efficiency: this.commandHistory.filter(cmd => this.isEfficient(cmd)).length / this.commandHistory.length
    };
  }
}