import Database from 'better-sqlite3';
/**
 * Database manager for VimGame
 * Handles SQLite database operations with better-sqlite3
 */
export declare class GameDatabase {
    private db;
    private static instance;
    private constructor();
    static getInstance(dbPath?: string): GameDatabase;
    private initialize;
    createUser(userData: {
        username: string;
        email?: string;
        passwordHash: string;
        timezone?: string;
    }): Database.RunResult;
    getUserByUsername(username: string): unknown;
    getUserById(id: number): unknown;
    updateLessonProgress(data: {
        userId: number;
        lessonId: string;
        status?: string;
        currentChallengeId?: string;
        score?: number;
        timeSpent?: number;
        attempts?: number;
        efficiencyScore?: number;
    }): Database.RunResult;
    getLessonProgress(userId: number, lessonId: string): unknown;
    getUserProgress(userId: number): unknown[];
    updateChallengeProgress(data: {
        userId: number;
        lessonId: string;
        challengeId: string;
        status?: string;
        score?: number;
        timeSpent?: number;
        attempts?: number;
        bestCommandSequence?: string[];
    }): Database.RunResult;
    awardAchievement(userId: number, achievementId: string, metadata?: any): Database.RunResult;
    getUserAchievements(userId: number): unknown[];
    hasAchievement(userId: number, achievementId: string): boolean;
    recordCommand(data: {
        userId: number;
        lessonId?: string;
        challengeId?: string;
        sessionId: string;
        command: string;
        success: boolean;
        points?: number;
        vimStateBefore: any;
        vimStateAfter: any;
    }): Database.RunResult;
    updateDailyStats(userId: number, updates: {
        challengesCompleted?: number;
        pointsEarned?: number;
        timeSpent?: number;
        commandsExecuted?: number;
        perfectScores?: number;
    }): Database.RunResult;
    getLeaderboard(category?: string, limit?: number): unknown[];
    updateLeaderboard(category: string, periodStart?: string, periodEnd?: string): Database.RunResult;
    getUserStats(userId: number): unknown;
    getLessonStats(lessonId?: string): unknown;
    getGameConfig(key: string): string | undefined;
    setGameConfig(key: string, value: string, description?: string): Database.RunResult;
    createSession(sessionId: string, userId: number, userAgent?: string, ipAddress?: string): Database.RunResult;
    endSession(sessionId: string, stats: {
        duration?: number;
        lessonsAttempted?: number;
        lessonsCompleted?: number;
        pointsEarned?: number;
    }): Database.RunResult;
    vacuum(): void;
    close(): void;
}
//# sourceMappingURL=Database.d.ts.map