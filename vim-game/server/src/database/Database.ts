import Database from 'better-sqlite3';
import { readFileSync } from 'fs';
import { join } from 'path';

/**
 * Database manager for VimGame
 * Handles SQLite database operations with better-sqlite3
 */
export class GameDatabase {
  private db: Database.Database;
  private static instance: GameDatabase;

  private constructor(dbPath: string = ':memory:') {
    this.db = new Database(dbPath);
    this.initialize();
  }

  public static getInstance(dbPath?: string): GameDatabase {
    if (!GameDatabase.instance) {
      GameDatabase.instance = new GameDatabase(dbPath);
    }
    return GameDatabase.instance;
  }

  private initialize(): void {
    // Enable foreign keys
    this.db.pragma('foreign_keys = ON');
    
    // Load schema
    const schemaPath = join(__dirname, 'schema.sql');
    const schema = readFileSync(schemaPath, 'utf8');
    this.db.exec(schema);
    
    console.log('Database initialized successfully');
  }

  // User operations
  public createUser(userData: {
    username: string;
    email?: string;
    passwordHash: string;
    timezone?: string;
  }) {
    const stmt = this.db.prepare(`
      INSERT INTO users (username, email, password_hash, timezone)
      VALUES (?, ?, ?, ?)
    `);
    
    return stmt.run(
      userData.username,
      userData.email,
      userData.passwordHash,
      userData.timezone || 'UTC'
    );
  }

  public getUserByUsername(username: string) {
    const stmt = this.db.prepare('SELECT * FROM users WHERE username = ?');
    return stmt.get(username);
  }

  public getUserById(id: number) {
    const stmt = this.db.prepare('SELECT * FROM users WHERE id = ?');
    return stmt.get(id);
  }

  // Lesson progress operations
  public updateLessonProgress(data: {
    userId: number;
    lessonId: string;
    status?: string;
    currentChallengeId?: string;
    score?: number;
    timeSpent?: number;
    attempts?: number;
    efficiencyScore?: number;
  }) {
    const stmt = this.db.prepare(`
      INSERT OR REPLACE INTO lesson_progress 
      (user_id, lesson_id, status, current_challenge_id, score, max_score, time_spent, attempts, efficiency_score, last_attempt_at)
      VALUES (?, ?, ?, ?, ?, MAX(COALESCE((SELECT max_score FROM lesson_progress WHERE user_id = ? AND lesson_id = ?), 0), ?), ?, ?, ?, CURRENT_TIMESTAMP)
    `);
    
    return stmt.run(
      data.userId,
      data.lessonId,
      data.status || 'in_progress',
      data.currentChallengeId,
      data.score || 0,
      data.userId,
      data.lessonId,
      data.score || 0,
      data.timeSpent || 0,
      data.attempts || 0,
      data.efficiencyScore || 0.0
    );
  }

  public getLessonProgress(userId: number, lessonId: string) {
    const stmt = this.db.prepare(`
      SELECT * FROM lesson_progress 
      WHERE user_id = ? AND lesson_id = ?
    `);
    return stmt.get(userId, lessonId);
  }

  public getUserProgress(userId: number) {
    const stmt = this.db.prepare(`
      SELECT * FROM lesson_progress 
      WHERE user_id = ? 
      ORDER BY last_attempt_at DESC
    `);
    return stmt.all(userId);
  }

  // Challenge progress operations
  public updateChallengeProgress(data: {
    userId: number;
    lessonId: string;
    challengeId: string;
    status?: string;
    score?: number;
    timeSpent?: number;
    attempts?: number;
    bestCommandSequence?: string[];
  }) {
    const stmt = this.db.prepare(`
      INSERT OR REPLACE INTO challenge_progress 
      (user_id, lesson_id, challenge_id, status, score, time_spent, attempts, best_command_sequence, completed_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);
    
    const completedAt = data.status === 'completed' ? new Date().toISOString() : null;
    
    return stmt.run(
      data.userId,
      data.lessonId,
      data.challengeId,
      data.status || 'in_progress',
      data.score || 0,
      data.timeSpent || 0,
      data.attempts || 0,
      data.bestCommandSequence ? JSON.stringify(data.bestCommandSequence) : null,
      completedAt
    );
  }

  // Achievement operations
  public awardAchievement(userId: number, achievementId: string, metadata?: any) {
    const stmt = this.db.prepare(`
      INSERT OR IGNORE INTO user_achievements 
      (user_id, achievement_id, metadata)
      VALUES (?, ?, ?)
    `);
    
    return stmt.run(userId, achievementId, metadata ? JSON.stringify(metadata) : null);
  }

  public getUserAchievements(userId: number) {
    const stmt = this.db.prepare(`
      SELECT * FROM user_achievements 
      WHERE user_id = ? 
      ORDER BY earned_at DESC
    `);
    return stmt.all(userId);
  }

  public hasAchievement(userId: number, achievementId: string): boolean {
    const stmt = this.db.prepare(`
      SELECT 1 FROM user_achievements 
      WHERE user_id = ? AND achievement_id = ?
    `);
    return !!stmt.get(userId, achievementId);
  }

  // Command history
  public recordCommand(data: {
    userId: number;
    lessonId?: string;
    challengeId?: string;
    sessionId: string;
    command: string;
    success: boolean;
    points?: number;
    vimStateBefore: any;
    vimStateAfter: any;
  }) {
    const stmt = this.db.prepare(`
      INSERT INTO command_history 
      (user_id, lesson_id, challenge_id, session_id, command, success, points, vim_state_before, vim_state_after)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);
    
    return stmt.run(
      data.userId,
      data.lessonId,
      data.challengeId,
      data.sessionId,
      data.command,
      data.success,
      data.points || 0,
      JSON.stringify(data.vimStateBefore),
      JSON.stringify(data.vimStateAfter)
    );
  }

  // Daily stats
  public updateDailyStats(userId: number, updates: {
    challengesCompleted?: number;
    pointsEarned?: number;
    timeSpent?: number;
    commandsExecuted?: number;
    perfectScores?: number;
  }) {
    const stmt = this.db.prepare(`
      INSERT OR REPLACE INTO daily_stats 
      (user_id, date, challenges_completed, points_earned, time_spent, commands_executed, perfect_scores)
      VALUES (
        ?, DATE('now'), 
        COALESCE((SELECT challenges_completed FROM daily_stats WHERE user_id = ? AND date = DATE('now')), 0) + ?,
        COALESCE((SELECT points_earned FROM daily_stats WHERE user_id = ? AND date = DATE('now')), 0) + ?,
        COALESCE((SELECT time_spent FROM daily_stats WHERE user_id = ? AND date = DATE('now')), 0) + ?,
        COALESCE((SELECT commands_executed FROM daily_stats WHERE user_id = ? AND date = DATE('now')), 0) + ?,
        COALESCE((SELECT perfect_scores FROM daily_stats WHERE user_id = ? AND date = DATE('now')), 0) + ?
      )
    `);
    
    return stmt.run(
      userId, userId, updates.challengesCompleted || 0,
      userId, updates.pointsEarned || 0,
      userId, updates.timeSpent || 0,
      userId, updates.commandsExecuted || 0,
      userId, updates.perfectScores || 0
    );
  }

  // Leaderboard operations
  public getLeaderboard(category: string = 'overall', limit: number = 100) {
    const stmt = this.db.prepare(`
      SELECT u.username, le.score, le.rank, u.total_points
      FROM leaderboard_entries le
      JOIN users u ON le.user_id = u.id
      WHERE le.category = ?
      ORDER BY le.rank ASC
      LIMIT ?
    `);
    
    return stmt.all(category, limit);
  }

  public updateLeaderboard(category: string, periodStart?: string, periodEnd?: string) {
    // This would implement leaderboard calculation logic
    // For now, we'll use total_points for overall leaderboard
    const stmt = this.db.prepare(`
      INSERT OR REPLACE INTO leaderboard_entries (user_id, category, score, rank, period_start, period_end)
      SELECT 
        id as user_id,
        ? as category,
        total_points as score,
        ROW_NUMBER() OVER (ORDER BY total_points DESC) as rank,
        ? as period_start,
        ? as period_end
      FROM users
      WHERE total_points > 0
    `);
    
    return stmt.run(category, periodStart, periodEnd);
  }

  // Utility methods
  public getUserStats(userId: number) {
    const stmt = this.db.prepare('SELECT * FROM user_stats WHERE id = ?');
    return stmt.get(userId);
  }

  public getLessonStats(lessonId?: string) {
    if (lessonId) {
      const stmt = this.db.prepare('SELECT * FROM lesson_stats WHERE lesson_id = ?');
      return stmt.get(lessonId);
    } else {
      const stmt = this.db.prepare('SELECT * FROM lesson_stats ORDER BY total_attempts DESC');
      return stmt.all();
    }
  }

  public getGameConfig(key: string) {
    const stmt = this.db.prepare('SELECT value FROM game_config WHERE key = ?');
    const result = stmt.get(key) as { value?: string } | undefined;
    return result?.value;
  }

  public setGameConfig(key: string, value: string, description?: string) {
    const stmt = this.db.prepare(`
      INSERT OR REPLACE INTO game_config (key, value, description)
      VALUES (?, ?, ?)
    `);
    return stmt.run(key, value, description);
  }

  // Session management
  public createSession(sessionId: string, userId: number, userAgent?: string, ipAddress?: string) {
    const stmt = this.db.prepare(`
      INSERT INTO user_sessions (session_id, user_id, user_agent, ip_address)
      VALUES (?, ?, ?, ?)
    `);
    
    return stmt.run(sessionId, userId, userAgent, ipAddress);
  }

  public endSession(sessionId: string, stats: {
    duration?: number;
    lessonsAttempted?: number;
    lessonsCompleted?: number;
    pointsEarned?: number;
  }) {
    const stmt = this.db.prepare(`
      UPDATE user_sessions
      SET ended_at = CURRENT_TIMESTAMP,
          duration = ?,
          lessons_attempted = ?,
          lessons_completed = ?,
          points_earned = ?
      WHERE session_id = ?
    `);
    
    return stmt.run(
      stats.duration,
      stats.lessonsAttempted,
      stats.lessonsCompleted,
      stats.pointsEarned,
      sessionId
    );
  }

  // Database maintenance
  public vacuum() {
    this.db.exec('VACUUM');
  }

  public close() {
    this.db.close();
  }
}