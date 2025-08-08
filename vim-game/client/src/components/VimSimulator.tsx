import React, { useState, useEffect, useRef, useCallback } from 'react';
import { useHotkeys } from 'react-hotkeys-hook';
import { motion, AnimatePresence } from 'framer-motion';
import clsx from 'clsx';

// Types matching the backend
interface VimState {
  mode: 'normal' | 'insert' | 'visual' | 'command';
  buffer: string[];
  cursor: { line: number; col: number };
  selection?: { start: { line: number; col: number }; end: { line: number; col: number } };
  registers: Record<string, string>;
  marks: Record<string, { line: number; col: number }>;
  lastCommand?: string;
}

interface CommandResult {
  success: boolean;
  newState: VimState;
  score: number;
  feedback: string;
  efficient: boolean;
  commandType: 'movement' | 'edit' | 'visual' | 'search' | 'jetbrains';
}

interface Challenge {
  id: string;
  description: string;
  initialState: VimState;
  expectedCommands?: string[];
  expectedState?: Partial<VimState>;
  maxCommands?: number;
  timeLimit?: number;
  hints: Array<{ delay: number; text: string }>;
}

interface VimSimulatorProps {
  challenge: Challenge;
  onCommandExecuted: (result: CommandResult) => void;
  onChallengeComplete: (success: boolean, stats: any) => void;
  className?: string;
}

export const VimSimulator: React.FC<VimSimulatorProps> = ({
  challenge,
  onCommandExecuted,
  onChallengeComplete,
  className
}) => {
  // Ensure buffer is always an array of strings, not a string with \n
  const normalizeInitialState = (initialState: VimState): VimState => {
    const buffer = Array.isArray(initialState.buffer) 
      ? initialState.buffer 
      : typeof initialState.buffer === 'string' 
        ? initialState.buffer.split('\n')
        : [''];
    
    return {
      ...initialState,
      buffer
    };
  };
  
  const [state, setState] = useState<VimState>(normalizeInitialState(challenge.initialState));
  const [commandHistory, setCommandHistory] = useState<string[]>([]);
  const [currentCommand, setCurrentCommand] = useState('');
  const [feedback, setFeedback] = useState<string>('');
  const [score, setScore] = useState(0);
  const [hints, setHints] = useState<string[]>([]);
  const [startTime] = useState(Date.now());
  const [isComplete, setIsComplete] = useState(false);
  
  const terminalRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  // Focus the input when component mounts
  useEffect(() => {
    inputRef.current?.focus();
  }, []);

  // Update state when challenge changes
  useEffect(() => {
    setState(normalizeInitialState(challenge.initialState));
    setCommandHistory([]);
    setCurrentCommand('');
    setFeedback('');
    setScore(0);
    setHints([]);
    setIsComplete(false);
  }, [challenge]);

  // Auto-focus on click
  const handleTerminalClick = useCallback(() => {
    inputRef.current?.focus();
  }, []);

  // Handle hint display
  useEffect(() => {
    const hintTimers = challenge.hints.map(hint => 
      setTimeout(() => {
        setHints(prev => [...prev, hint.text]);
      }, hint.delay)
    );

    return () => hintTimers.forEach(clearTimeout);
  }, [challenge]);

  // Simulate vim command processing (simplified version of backend logic)
  const processCommand = useCallback((command: string): CommandResult => {
    const newState = { ...state };
    let success = true;
    let feedback = '';
    let score = 10;
    let commandType: CommandResult['commandType'] = 'movement';

    try {
      // Basic movement commands
      if (command === 'j' && newState.cursor.line < newState.buffer.length - 1) {
        newState.cursor.line++;
        newState.cursor.col = Math.min(newState.cursor.col, newState.buffer[newState.cursor.line].length - 1);
        feedback = 'Moved down';
        commandType = 'movement';
      } else if (command === 'k' && newState.cursor.line > 0) {
        newState.cursor.line--;
        newState.cursor.col = Math.min(newState.cursor.col, newState.buffer[newState.cursor.line].length - 1);
        feedback = 'Moved up';
        commandType = 'movement';
      } else if (command === 'h' && newState.cursor.col > 0) {
        newState.cursor.col--;
        feedback = 'Moved left';
        commandType = 'movement';
      } else if (command === 'l' && newState.cursor.col < newState.buffer[newState.cursor.line].length - 1) {
        newState.cursor.col++;
        feedback = 'Moved right';
        commandType = 'movement';
      }
      
      // Word movement
      else if (command === 'w') {
        moveToNextWord(newState);
        feedback = 'Moved to next word';
        commandType = 'movement';
        score += 5; // Efficient movement
      } else if (command === 'b') {
        moveToPreviousWord(newState);
        feedback = 'Moved to previous word';
        commandType = 'movement';
        score += 5;
      }
      
      // Line movement
      else if (command === '0') {
        newState.cursor.col = 0;
        feedback = 'Moved to line start';
        commandType = 'movement';
        score += 3;
      } else if (command === '$') {
        newState.cursor.col = Math.max(0, newState.buffer[newState.cursor.line].length - 1);
        feedback = 'Moved to line end';
        commandType = 'movement';
        score += 3;
      }
      
      // Mode changes
      else if (command === 'i') {
        newState.mode = 'insert';
        feedback = 'Entered insert mode';
        commandType = 'edit';
      } else if (command === '<Esc>') {
        newState.mode = 'normal';
        if (newState.cursor.col > 0) {
          newState.cursor.col--;
        }
        feedback = 'Back to normal mode';
        commandType = 'edit';
      }
      
      // Editing
      else if (command === 'x') {
        deleteCharacter(newState);
        feedback = 'Character deleted';
        commandType = 'edit';
        score += 5;
      } else if (command === 'dd') {
        deleteLine(newState);
        feedback = 'Line deleted';
        commandType = 'edit';
        score += 8;
      }
      
      // JetBrains commands
      else if (command.includes('<Cmd-')) {
        feedback = `🚀 JetBrains shortcut: ${command}`;
        commandType = 'jetbrains';
        score += 15; // JetBrains commands worth more
      }
      
      // Character input in insert mode
      else if (newState.mode === 'insert' && command.length === 1) {
        insertCharacter(newState, command);
        feedback = `Inserted '${command}'`;
        commandType = 'edit';
        score += 2;
      }
      
      else {
        throw new Error(`Unknown command: ${command}`);
      }

    } catch (error) {
      success = false;
      feedback = `Invalid command: ${command}`;
      score = 0;
    }

    return {
      success,
      newState,
      score,
      feedback,
      efficient: isEfficientCommand(command, commandHistory),
      commandType
    };
  }, [state, commandHistory]);

  // Vim operation helpers
  const moveToNextWord = (state: VimState) => {
    const line = state.buffer[state.cursor.line];
    let col = state.cursor.col;
    
    // Skip current word
    while (col < line.length && /\w/.test(line[col])) {
      col++;
    }
    // Skip whitespace
    while (col < line.length && /\s/.test(line[col])) {
      col++;
    }
    
    state.cursor.col = Math.min(col, Math.max(0, line.length - 1));
  };

  const moveToPreviousWord = (state: VimState) => {
    const line = state.buffer[state.cursor.line];
    let col = state.cursor.col;
    
    if (col > 0) col--;
    
    // Skip whitespace
    while (col > 0 && /\s/.test(line[col])) {
      col--;
    }
    // Skip to beginning of word
    while (col > 0 && /\w/.test(line[col - 1])) {
      col--;
    }
    
    state.cursor.col = col;
  };

  const deleteCharacter = (state: VimState) => {
    const line = state.buffer[state.cursor.line];
    if (state.cursor.col < line.length) {
      state.buffer[state.cursor.line] = line.slice(0, state.cursor.col) + line.slice(state.cursor.col + 1);
    }
  };

  const deleteLine = (state: VimState) => {
    if (state.buffer.length > 1) {
      state.buffer.splice(state.cursor.line, 1);
      if (state.cursor.line >= state.buffer.length) {
        state.cursor.line = state.buffer.length - 1;
      }
    } else {
      state.buffer[0] = '';
    }
    state.cursor.col = Math.min(state.cursor.col, Math.max(0, state.buffer[state.cursor.line].length - 1));
  };

  const insertCharacter = (state: VimState, char: string) => {
    const line = state.buffer[state.cursor.line];
    state.buffer[state.cursor.line] = line.slice(0, state.cursor.col) + char + line.slice(state.cursor.col);
    state.cursor.col++;
  };

  const isEfficientCommand = (command: string, history: string[]): boolean => {
    const recent = history.slice(-3);
    // Redundant movement patterns
    if (recent.includes('h') && recent.includes('l')) return false;
    if (recent.includes('j') && recent.includes('k')) return false;
    // Efficient commands
    return ['w', 'b', '0', '$', 'gg', 'G'].includes(command);
  };

  // Check if challenge is complete
  const checkChallengeComplete = useCallback((currentState: VimState): boolean => {
    if (challenge.expectedState) {
      const { cursor, buffer, mode } = challenge.expectedState;
      
      if (cursor && (cursor.line !== currentState.cursor.line || cursor.col !== currentState.cursor.col)) {
        return false;
      }
      
      if (buffer && JSON.stringify(buffer) !== JSON.stringify(currentState.buffer)) {
        return false;
      }
      
      if (mode && mode !== currentState.mode) {
        return false;
      }
    }
    
    return true;
  }, [challenge]);

  // Handle command execution
  const executeCommand = useCallback((command: string) => {
    if (isComplete) return;
    
    const result = processCommand(command);
    const newHistory = [...commandHistory, command];
    
    setCommandHistory(newHistory);
    setState(result.newState);
    setFeedback(result.feedback);
    setScore(prev => prev + result.score);
    setCurrentCommand('');
    
    onCommandExecuted(result);

    // Check if challenge is complete
    if (checkChallengeComplete(result.newState)) {
      setIsComplete(true);
      const stats = {
        commandCount: newHistory.length,
        timeElapsed: Date.now() - startTime,
        totalScore: score + result.score,
        efficiency: newHistory.filter(cmd => isEfficientCommand(cmd, newHistory)).length / newHistory.length
      };
      onChallengeComplete(true, stats);
    }
    
    // Check for failure conditions
    if (challenge.maxCommands && newHistory.length >= challenge.maxCommands && !checkChallengeComplete(result.newState)) {
      setIsComplete(true);
      onChallengeComplete(false, { reason: 'Too many commands' });
    }
  }, [commandHistory, isComplete, processCommand, onCommandExecuted, checkChallengeComplete, onChallengeComplete, challenge, score, startTime]);

  // Handle special key combinations
  const handleKeyDown = useCallback((e: React.KeyboardEvent) => {
    e.preventDefault();
    
    let command = '';
    
    // Handle special keys
    if (e.key === 'Escape') {
      command = '<Esc>';
    } else if (e.key === 'Enter') {
      command = '<Enter>';
    } else if (e.key === 'Backspace') {
      command = '<BS>';
    } else if (e.key === 'Tab') {
      command = '<Tab>';
    }
    // JetBrains shortcuts
    else if (e.metaKey && e.key >= '1' && e.key <= '8') {
      command = `<Cmd-${e.key}>`;
    } else if (e.shiftKey && e.key === 'F6') {
      command = '<Shift-F6>';
    } else if (e.key === 'F6') {
      command = '<F6>';
    }
    // Regular keys
    else if (e.key.length === 1) {
      command = e.key;
    }
    
    if (command) {
      setCurrentCommand(command);
      executeCommand(command);
    }
  }, [executeCommand]);

  // Set up hotkeys for JetBrains shortcuts
  useHotkeys('cmd+1', () => executeCommand('<Cmd-1>'), { preventDefault: true });
  useHotkeys('cmd+2', () => executeCommand('<Cmd-2>'), { preventDefault: true });
  useHotkeys('cmd+3', () => executeCommand('<Cmd-3>'), { preventDefault: true });
  useHotkeys('cmd+4', () => executeCommand('<Cmd-4>'), { preventDefault: true });
  useHotkeys('cmd+5', () => executeCommand('<Cmd-5>'), { preventDefault: true });
  useHotkeys('cmd+6', () => executeCommand('<Cmd-6>'), { preventDefault: true });
  useHotkeys('cmd+7', () => executeCommand('<Cmd-7>'), { preventDefault: true });
  useHotkeys('cmd+8', () => executeCommand('<Cmd-8>'), { preventDefault: true });
  useHotkeys('shift+f6', () => executeCommand('<Shift-F6>'), { preventDefault: true });

  return (
    <div className={clsx('vim-simulator', className)}>
      {/* Terminal Header */}
      <div className="bg-gray-900 text-white p-3 rounded-t-lg flex justify-between items-center">
        <div className="flex items-center space-x-2">
          <div className="w-3 h-3 bg-red-500 rounded-full"></div>
          <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
          <div className="w-3 h-3 bg-green-500 rounded-full"></div>
          <span className="ml-4 text-sm">VimGame Terminal</span>
        </div>
        <div className="flex items-center space-x-4 text-sm">
          <span className={clsx('px-2 py-1 rounded text-xs', {
            'bg-green-600': state.mode === 'normal',
            'bg-blue-600': state.mode === 'insert',
            'bg-purple-600': state.mode === 'visual',
            'bg-orange-600': state.mode === 'command'
          })}>
            {state.mode.toUpperCase()}
          </span>
          <span>Score: {score}</span>
          <span>Commands: {commandHistory.length}</span>
        </div>
      </div>

      {/* Terminal Content */}
      <div 
        ref={terminalRef}
        className="bg-black text-green-400 p-4 font-mono text-sm h-96 overflow-auto cursor-text"
        onClick={handleTerminalClick}
      >
        {/* Buffer Display */}
        {state.buffer.map((line, lineIndex) => (
          <div key={lineIndex} className="flex">
            <span className="text-gray-600 mr-2 w-8 text-right select-none">
              {lineIndex + 1}
            </span>
            <div className="flex-1 relative">
              {line.split('').map((char, charIndex) => (
                <span
                  key={charIndex}
                  className={clsx('relative', {
                    'bg-green-400 text-black': 
                      state.cursor.line === lineIndex && state.cursor.col === charIndex,
                  })}
                >
                  {char === '\n' ? <br /> : char}
                  {/* Cursor */}
                  {state.cursor.line === lineIndex && state.cursor.col === charIndex && (
                    <motion.span
                      initial={{ opacity: 0 }}
                      animate={{ opacity: [0, 1, 0] }}
                      transition={{ duration: 1, repeat: Infinity }}
                      className="absolute inset-0 bg-green-400 text-black"
                    >
                      {char === '\n' ? ' ' : (char || ' ')}
                    </motion.span>
                  )}
                </span>
              ))}
              {/* End-of-line cursor */}
              {state.cursor.line === lineIndex && state.cursor.col === line.length && (
                <motion.span
                  initial={{ opacity: 0 }}
                  animate={{ opacity: [0, 1, 0] }}
                  transition={{ duration: 1, repeat: Infinity }}
                  className="bg-green-400 text-black ml-0"
                >
                  _
                </motion.span>
              )}
            </div>
          </div>
        ))}
      </div>

      {/* Command Input (Hidden but captures keystrokes) */}
      <input
        ref={inputRef}
        className="absolute opacity-0 pointer-events-none"
        onKeyDown={handleKeyDown}
        autoFocus
      />

      {/* Feedback Panel */}
      <div className="bg-gray-800 text-white p-3 rounded-b-lg">
        <AnimatePresence mode="wait">
          {feedback && (
            <motion.div
              key={feedback}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              className="mb-2 text-sm"
            >
              {feedback}
            </motion.div>
          )}
        </AnimatePresence>

        {/* Hints */}
        <AnimatePresence>
          {hints.map((hint, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 20 }}
              className="text-yellow-300 text-sm mb-1 flex items-center"
            >
              <span className="mr-2">💡</span>
              {hint}
            </motion.div>
          ))}
        </AnimatePresence>

        {/* Command History */}
        {commandHistory.length > 0 && (
          <div className="mt-2 text-xs text-gray-400">
            <span>Commands: </span>
            {commandHistory.slice(-10).map((cmd, index) => (
              <span key={index} className="mr-1 px-1 bg-gray-700 rounded">
                {cmd}
              </span>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};