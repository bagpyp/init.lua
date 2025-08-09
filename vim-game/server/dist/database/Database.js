import Database from 'better-sqlite3';
import { readFileSync } from 'fs';
import { join } from 'path';
/**
 * Database manager for VimGame
 * Handles SQLite database operations with better-sqlite3
 */
export class GameDatabase {
    db;
    static instance;
    constructor(dbPath = ':memory:') {
        this.db = new Database(dbPath);
        this.initialize();
    }
    static getInstance(dbPath) {
        if (!GameDatabase.instance) {
            GameDatabase.instance = new GameDatabase(dbPath);
        }
        return GameDatabase.instance;
    }
    initialize() {
        // Enable foreign keys
        this.db.pragma('foreign_keys = ON');
        // Load schema
        const schemaPath = join(__dirname, 'schema.sql');
        const schema = readFileSync(schemaPath, 'utf8');
        this.db.exec(schema);
        console.log('Database initialized successfully');
    }
    // User operations
    createUser(userData) {
        const stmt = this.db.prepare(`
      INSERT INTO users (username, email, password_hash, timezone)
      VALUES (?, ?, ?, ?)
    `);
        return stmt.run(userData.username, userData.email, userData.passwordHash, userData.timezone || 'UTC');
    }
    getUserByUsername(username) {
        const stmt = this.db.prepare('SELECT * FROM users WHERE username = ?');
        return stmt.get(username);
    }
    getUserById(id) {
        const stmt = this.db.prepare('SELECT * FROM users WHERE id = ?');
        return stmt.get(id);
    }
    // Lesson progress operations
    updateLessonProgress(data) {
        const stmt = this.db.prepare(`
      INSERT OR REPLACE INTO lesson_progress 
      (user_id, lesson_id, status, current_challenge_id, score, max_score, time_spent, attempts, efficiency_score, last_attempt_at)
      VALUES (?, ?, ?, ?, ?, MAX(COALESCE((SELECT max_score FROM lesson_progress WHERE user_id = ? AND lesson_id = ?), 0), ?), ?, ?, ?, CURRENT_TIMESTAMP)
    `);
        return stmt.run(data.userId, data.lessonId, data.status || 'in_progress', data.currentChallengeId, data.score || 0, data.userId, data.lessonId, data.score || 0, data.timeSpent || 0, data.attempts || 0, data.efficiencyScore || 0.0);
    }
    getLessonProgress(userId, lessonId) {
        const stmt = this.db.prepare(`
      SELECT * FROM lesson_progress 
      WHERE user_id = ? AND lesson_id = ?
    `);
        return stmt.get(userId, lessonId);
    }
    getUserProgress(userId) {
        const stmt = this.db.prepare(`
      SELECT * FROM lesson_progress 
      WHERE user_id = ? 
      ORDER BY last_attempt_at DESC
    `);
        return stmt.all(userId);
    }
    // Challenge progress operations
    updateChallengeProgress(data) {
        const stmt = this.db.prepare(`
      INSERT OR REPLACE INTO challenge_progress 
      (user_id, lesson_id, challenge_id, status, score, time_spent, attempts, best_command_sequence, completed_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);
        const completedAt = data.status === 'completed' ? new Date().toISOString() : null;
        return stmt.run(data.userId, data.lessonId, data.challengeId, data.status || 'in_progress', data.score || 0, data.timeSpent || 0, data.attempts || 0, data.bestCommandSequence ? JSON.stringify(data.bestCommandSequence) : null, completedAt);
    }
    // Achievement operations
    awardAchievement(userId, achievementId, metadata) {
        const stmt = this.db.prepare(`
      INSERT OR IGNORE INTO user_achievements 
      (user_id, achievement_id, metadata)
      VALUES (?, ?, ?)
    `);
        return stmt.run(userId, achievementId, metadata ? JSON.stringify(metadata) : null);
    }
    getUserAchievements(userId) {
        const stmt = this.db.prepare(`
      SELECT * FROM user_achievements 
      WHERE user_id = ? 
      ORDER BY earned_at DESC
    `);
        return stmt.all(userId);
    }
    hasAchievement(userId, achievementId) {
        const stmt = this.db.prepare(`
      SELECT 1 FROM user_achievements 
      WHERE user_id = ? AND achievement_id = ?
    `);
        return !!stmt.get(userId, achievementId);
    }
    // Command history
    recordCommand(data) {
        const stmt = this.db.prepare(`
      INSERT INTO command_history 
      (user_id, lesson_id, challenge_id, session_id, command, success, points, vim_state_before, vim_state_after)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);
        return stmt.run(data.userId, data.lessonId, data.challengeId, data.sessionId, data.command, data.success, data.points || 0, JSON.stringify(data.vimStateBefore), JSON.stringify(data.vimStateAfter));
    }
    // Daily stats
    updateDailyStats(userId, updates) {
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
        return stmt.run(userId, userId, updates.challengesCompleted || 0, userId, updates.pointsEarned || 0, userId, updates.timeSpent || 0, userId, updates.commandsExecuted || 0, userId, updates.perfectScores || 0);
    }
    // Leaderboard operations
    getLeaderboard(category = 'overall', limit = 100) {
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
    updateLeaderboard(category, periodStart, periodEnd) {
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
    getUserStats(userId) {
        const stmt = this.db.prepare('SELECT * FROM user_stats WHERE id = ?');
        return stmt.get(userId);
    }
    getLessonStats(lessonId) {
        if (lessonId) {
            const stmt = this.db.prepare('SELECT * FROM lesson_stats WHERE lesson_id = ?');
            return stmt.get(lessonId);
        }
        else {
            const stmt = this.db.prepare('SELECT * FROM lesson_stats ORDER BY total_attempts DESC');
            return stmt.all();
        }
    }
    getGameConfig(key) {
        const stmt = this.db.prepare('SELECT value FROM game_config WHERE key = ?');
        const result = stmt.get(key);
        return result?.value;
    }
    setGameConfig(key, value, description) {
        const stmt = this.db.prepare(`
      INSERT OR REPLACE INTO game_config (key, value, description)
      VALUES (?, ?, ?)
    `);
        return stmt.run(key, value, description);
    }
    // Session management
    createSession(sessionId, userId, userAgent, ipAddress) {
        const stmt = this.db.prepare(`
      INSERT INTO user_sessions (session_id, user_id, user_agent, ip_address)
      VALUES (?, ?, ?, ?)
    `);
        return stmt.run(sessionId, userId, userAgent, ipAddress);
    }
    endSession(sessionId, stats) {
        const stmt = this.db.prepare(`
      UPDATE user_sessions
      SET ended_at = CURRENT_TIMESTAMP,
          duration = ?,
          lessons_attempted = ?,
          lessons_completed = ?,
          points_earned = ?
      WHERE session_id = ?
    `);
        return stmt.run(stats.duration, stats.lessonsAttempted, stats.lessonsCompleted, stats.pointsEarned, sessionId);
    }
    // Database maintenance
    vacuum() {
        this.db.exec('VACUUM');
    }
    close() {
        this.db.close();
    }
}
//# sourceMappingURL=Database.js.map