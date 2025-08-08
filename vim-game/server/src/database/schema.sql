-- VimGame Database Schema
-- SQLite database for storing user progress, achievements, and game state

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_points INTEGER DEFAULT 0,
    current_streak INTEGER DEFAULT 0,
    max_streak INTEGER DEFAULT 0,
    last_active DATE,
    timezone TEXT DEFAULT 'UTC',
    preferences TEXT -- JSON blob for user preferences
);

-- User progress on lessons
CREATE TABLE IF NOT EXISTS lesson_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    lesson_id TEXT NOT NULL,
    status TEXT CHECK(status IN ('not_started', 'in_progress', 'completed')) DEFAULT 'not_started',
    current_challenge_id TEXT,
    score INTEGER DEFAULT 0,
    max_score INTEGER DEFAULT 0,
    time_spent INTEGER DEFAULT 0, -- seconds
    attempts INTEGER DEFAULT 0,
    efficiency_score REAL DEFAULT 0.0, -- 0.0 to 1.0
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    last_attempt_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(user_id, lesson_id)
);

-- Individual challenge progress within lessons
CREATE TABLE IF NOT EXISTS challenge_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    lesson_id TEXT NOT NULL,
    challenge_id TEXT NOT NULL,
    status TEXT CHECK(status IN ('not_started', 'in_progress', 'completed')) DEFAULT 'not_started',
    score INTEGER DEFAULT 0,
    time_spent INTEGER DEFAULT 0,
    attempts INTEGER DEFAULT 0,
    best_command_sequence TEXT, -- JSON array of optimal commands
    completed_at TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(user_id, lesson_id, challenge_id)
);

-- User achievements/badges
CREATE TABLE IF NOT EXISTS user_achievements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    achievement_id TEXT NOT NULL,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress REAL DEFAULT 1.0, -- For progressive achievements
    metadata TEXT, -- JSON blob for additional data
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(user_id, achievement_id)
);

-- Daily activity tracking
CREATE TABLE IF NOT EXISTS daily_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    date DATE NOT NULL,
    lessons_completed INTEGER DEFAULT 0,
    challenges_completed INTEGER DEFAULT 0,
    points_earned INTEGER DEFAULT 0,
    time_spent INTEGER DEFAULT 0,
    commands_executed INTEGER DEFAULT 0,
    perfect_scores INTEGER DEFAULT 0,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(user_id, date)
);

-- Command history for analytics and replay
CREATE TABLE IF NOT EXISTS command_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    lesson_id TEXT,
    challenge_id TEXT,
    session_id TEXT NOT NULL,
    command TEXT NOT NULL,
    success BOOLEAN NOT NULL,
    points INTEGER DEFAULT 0,
    vim_state_before TEXT, -- JSON blob
    vim_state_after TEXT,  -- JSON blob
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Leaderboard entries
CREATE TABLE IF NOT EXISTS leaderboard_entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    category TEXT NOT NULL, -- 'overall', 'weekly', 'monthly', 'lesson_specific'
    score INTEGER NOT NULL,
    rank INTEGER,
    period_start DATE,
    period_end DATE,
    lesson_id TEXT, -- For lesson-specific leaderboards
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- User sessions for analytics
CREATE TABLE IF NOT EXISTS user_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT UNIQUE NOT NULL,
    user_id INTEGER NOT NULL,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP,
    duration INTEGER, -- seconds
    lessons_attempted INTEGER DEFAULT 0,
    lessons_completed INTEGER DEFAULT 0,
    points_earned INTEGER DEFAULT 0,
    ip_address TEXT,
    user_agent TEXT,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Game configuration and feature flags
CREATE TABLE IF NOT EXISTS game_config (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_user ON lesson_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_lesson ON lesson_progress(lesson_id);
CREATE INDEX IF NOT EXISTS idx_challenge_progress_user ON challenge_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_challenge_progress_lesson ON challenge_progress(lesson_id);
CREATE INDEX IF NOT EXISTS idx_user_achievements_user ON user_achievements(user_id);
CREATE INDEX IF NOT EXISTS idx_user_achievements_achievement ON user_achievements(achievement_id);
CREATE INDEX IF NOT EXISTS idx_daily_stats_user_date ON daily_stats(user_id, date);
CREATE INDEX IF NOT EXISTS idx_command_history_user ON command_history(user_id);
CREATE INDEX IF NOT EXISTS idx_command_history_session ON command_history(session_id);
CREATE INDEX IF NOT EXISTS idx_leaderboard_category ON leaderboard_entries(category);
CREATE INDEX IF NOT EXISTS idx_leaderboard_score ON leaderboard_entries(score DESC);
CREATE INDEX IF NOT EXISTS idx_user_sessions_user ON user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_started ON user_sessions(started_at);

-- Initial game configuration
INSERT OR IGNORE INTO game_config (key, value, description) VALUES
    ('max_daily_streak_bonus', '100', 'Maximum bonus points for daily streaks'),
    ('lesson_completion_multiplier', '1.5', 'Score multiplier for lesson completion'),
    ('perfect_score_bonus', '50', 'Bonus points for perfect challenge completion'),
    ('speed_bonus_threshold', '30', 'Seconds under which speed bonus applies'),
    ('leaderboard_refresh_minutes', '15', 'How often leaderboards refresh'),
    ('achievement_notification_delay', '2', 'Seconds to show achievement notifications');

-- Views for common queries
CREATE VIEW IF NOT EXISTS user_stats AS
SELECT 
    u.id,
    u.username,
    u.total_points,
    u.current_streak,
    u.max_streak,
    COUNT(DISTINCT lp.lesson_id) as lessons_completed,
    COUNT(DISTINCT ua.achievement_id) as achievements_earned,
    COALESCE(SUM(ds.time_spent), 0) as total_time_spent,
    COALESCE(SUM(ds.commands_executed), 0) as total_commands,
    u.created_at,
    u.last_active
FROM users u
LEFT JOIN lesson_progress lp ON u.id = lp.user_id AND lp.status = 'completed'
LEFT JOIN user_achievements ua ON u.id = ua.user_id
LEFT JOIN daily_stats ds ON u.id = ds.user_id
GROUP BY u.id;

CREATE VIEW IF NOT EXISTS lesson_stats AS
SELECT 
    lesson_id,
    COUNT(*) as total_attempts,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completions,
    ROUND(AVG(CASE WHEN status = 'completed' THEN score END), 2) as avg_score,
    ROUND(AVG(CASE WHEN status = 'completed' THEN time_spent END), 2) as avg_time,
    ROUND(AVG(CASE WHEN status = 'completed' THEN efficiency_score END), 3) as avg_efficiency
FROM lesson_progress
WHERE status != 'not_started'
GROUP BY lesson_id;

-- Triggers for maintaining data consistency
CREATE TRIGGER IF NOT EXISTS update_user_total_points
AFTER INSERT ON lesson_progress
WHEN NEW.status = 'completed'
BEGIN
    UPDATE users 
    SET total_points = total_points + NEW.score
    WHERE id = NEW.user_id;
END;

CREATE TRIGGER IF NOT EXISTS update_daily_stats
AFTER UPDATE ON lesson_progress
WHEN NEW.status = 'completed' AND OLD.status != 'completed'
BEGIN
    INSERT OR REPLACE INTO daily_stats (user_id, date, lessons_completed, points_earned)
    VALUES (
        NEW.user_id,
        DATE('now'),
        COALESCE((SELECT lessons_completed FROM daily_stats WHERE user_id = NEW.user_id AND date = DATE('now')), 0) + 1,
        COALESCE((SELECT points_earned FROM daily_stats WHERE user_id = NEW.user_id AND date = DATE('now')), 0) + NEW.score
    );
END;

CREATE TRIGGER IF NOT EXISTS update_user_activity
AFTER INSERT ON command_history
BEGIN
    UPDATE users 
    SET last_active = DATE('now')
    WHERE id = NEW.user_id;
END;