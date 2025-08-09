/**
 * VimGameEngine - Core game logic for vim command processing and validation
 *
 * This is the heart of VimGame that simulates vim behavior, validates commands,
 * calculates scores, and manages game state.
 */
export interface VimState {
    mode: 'normal' | 'insert' | 'visual' | 'command';
    buffer: string[];
    cursor: {
        line: number;
        col: number;
    };
    selection?: {
        start: {
            line: number;
            col: number;
        };
        end: {
            line: number;
            col: number;
        };
    };
    registers: Record<string, string>;
    marks: Record<string, {
        line: number;
        col: number;
    }>;
    lastCommand?: string;
    dotRegister?: string;
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
    hints: Array<{
        delay: number;
        text: string;
    }>;
}
export declare class VimGameEngine {
    private state;
    private commandHistory;
    private startTime;
    constructor(initialState?: Partial<VimState>);
    /**
     * Execute a vim command and return the result
     */
    executeCommand(command: string): CommandResult;
    /**
     * Process individual vim commands
     */
    private processCommand;
    /**
     * Process normal mode commands (movement, editing, etc.)
     */
    private processNormalModeCommand;
    /**
     * Process insert mode commands
     */
    private processInsertModeCommand;
    /**
     * Process visual mode commands
     */
    private processVisualModeCommand;
    /**
     * Helper methods for vim operations
     */
    private moveToNextWord;
    private moveToPreviousWord;
    private deleteCharacter;
    private deleteLine;
    private insertCharacter;
    /**
     * Calculate score based on command efficiency and accuracy
     */
    private calculateScore;
    /**
     * Check if a command is efficient (not redundant)
     */
    private isEfficient;
    /**
     * Categorize command type for scoring and achievements
     */
    private getCommandType;
    /**
     * Generate helpful feedback for the user
     */
    private generateFeedback;
    /**
     * Validate if current state matches expected challenge outcome
     */
    validateChallenge(challenge: Challenge): {
        passed: boolean;
        feedback: string;
    };
    /**
     * Get current game state
     */
    getState(): VimState;
    /**
     * Reset to initial state
     */
    reset(initialState: Partial<VimState>): void;
    /**
     * Get performance stats
     */
    getStats(): {
        commandCount: number;
        timeElapsed: number;
        commandsPerMinute: number;
        efficiency: number;
    };
}
//# sourceMappingURL=VimGameEngine.d.ts.map