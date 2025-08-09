# VimGame Architecture Specification

## System Overview

VimGame is a full-stack web application that teaches Neovim keybindings through interactive lessons and gamification. This document serves as the source of truth for all architectural decisions.

## Core Components

### 1. Game Engine

The game engine is the heart of VimGame, responsible for:

- **Command Processing**: Parsing and validating vim commands
- **State Management**: Tracking buffer state, cursor position, mode
- **Score Calculation**: Points based on efficiency and accuracy
- **Achievement Triggers**: Detecting when badges are earned

```javascript
class VimGameEngine {
  constructor() {
    this.state = {
      mode: 'normal',
      buffer: [],
      cursor: { line: 0, col: 0 },
      registers: {},
      marks: {}
    };
    this.score = 0;
    this.commandHistory = [];
  }

  executeCommand(command) {
    // Validate and execute vim command
    // Update state
    // Calculate score
    // Check achievements
  }
}
```

### 2. Lesson System

Lessons are structured learning paths with:

- **Categories**: Basics, Movement, Editing, JetBrains Features
- **Difficulty Levels**: Beginner, Intermediate, Advanced, Expert
- **Validation Rules**: Expected outcomes for each challenge
- **Hints System**: Progressive hints to help stuck users

Lesson Format (YAML):
```yaml
id: lesson-movement-basics
title: "Basic Movement"
category: movement
difficulty: beginner
points: 100
challenges:
  - id: move-word-forward
    description: "Move to the next word"
    initial_state:
      buffer: ["The quick brown fox"]
      cursor: { line: 0, col: 0 }
    expected_commands: ["w"]
    expected_state:
      cursor: { line: 0, col: 4 }
    hints:
      - delay: 5000
        text: "Use 'w' to move forward by word"
```

### 3. Progress Tracking

User progress is tracked comprehensively:

```sql
-- Database Schema
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username TEXT UNIQUE,
  email TEXT UNIQUE,
  created_at TIMESTAMP
);

CREATE TABLE progress (
  user_id INTEGER,
  lesson_id TEXT,
  completed BOOLEAN,
  score INTEGER,
  time_spent INTEGER,
  attempts INTEGER,
  completed_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE achievements (
  user_id INTEGER,
  badge_id TEXT,
  earned_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE daily_streaks (
  user_id INTEGER,
  date DATE,
  lessons_completed INTEGER,
  points_earned INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### 4. Real-time Communication

WebSocket protocol for instant feedback:

```javascript
// Client -> Server
{
  type: 'EXECUTE_COMMAND',
  payload: {
    command: 'dd',
    lessonId: 'lesson-editing-basics',
    challengeId: 'delete-line'
  }
}

// Server -> Client
{
  type: 'COMMAND_RESULT',
  payload: {
    success: true,
    newState: { /* updated vim state */ },
    score: 10,
    feedback: 'Perfect! Line deleted.',
    achievement: {
      id: 'first-delete',
      title: 'Destroyer',
      description: 'Delete your first line'
    }
  }
}
```

### 5. Achievement System

Badges and achievements to motivate learning:

```javascript
const achievements = {
  // Progression badges
  'first-lesson': {
    title: 'First Steps',
    description: 'Complete your first lesson',
    icon: '🎯',
    points: 10
  },
  
  // Skill badges
  'movement-master': {
    title: 'Movement Master',
    description: 'Complete all movement lessons',
    icon: '🏃',
    points: 100
  },
  
  // Streak badges
  'week-warrior': {
    title: 'Week Warrior',
    description: '7 day learning streak',
    icon: '🔥',
    points: 50
  },
  
  // JetBrains specific
  'jetbrains-ninja': {
    title: 'JetBrains Ninja',
    description: 'Master all JetBrains keybindings',
    icon: '🥷',
    points: 500
  }
};
```

## API Specification

### REST Endpoints

```
GET  /api/lessons                 # List all lessons
GET  /api/lessons/:id             # Get specific lesson
POST /api/lessons/:id/start       # Start a lesson
POST /api/lessons/:id/complete    # Submit lesson completion

GET  /api/user/progress           # Get user progress
GET  /api/user/achievements       # Get user achievements
GET  /api/user/stats              # Get user statistics

GET  /api/leaderboard             # Global leaderboard
GET  /api/leaderboard/weekly      # Weekly leaderboard
```

### WebSocket Events

```
Client Events:
- connect                         # Initial connection
- execute_command                 # Execute vim command
- request_hint                    # Request hint for current challenge
- reset_challenge                 # Reset current challenge

Server Events:
- command_result                  # Result of command execution
- achievement_earned              # New achievement unlocked
- hint_provided                   # Hint for current challenge
- leaderboard_update             # Real-time leaderboard updates
```

## Frontend Architecture

### Component Hierarchy

```
App
├── Layout
│   ├── Header (stats, streak, points)
│   ├── Sidebar (lesson navigation)
│   └── Footer
├── Routes
│   ├── Dashboard
│   │   ├── ProgressChart
│   │   ├── RecentAchievements
│   │   └── NextLesson
│   ├── LessonView
│   │   ├── LessonInfo
│   │   ├── VimSimulator
│   │   ├── CommandInput
│   │   └── Feedback
│   ├── Achievements
│   │   └── BadgeGrid
│   └── Leaderboard
│       └── LeaderboardTable
└── Providers
    ├── AuthProvider
    ├── GameProvider
    └── WebSocketProvider
```

### State Management

Using React Context + useReducer for game state:

```typescript
interface GameState {
  currentLesson: Lesson | null;
  currentChallenge: Challenge | null;
  vimState: VimState;
  score: number;
  streak: number;
  achievements: Achievement[];
}

type GameAction = 
  | { type: 'START_LESSON'; payload: Lesson }
  | { type: 'EXECUTE_COMMAND'; payload: string }
  | { type: 'COMPLETE_CHALLENGE'; payload: ChallengeResult }
  | { type: 'EARN_ACHIEVEMENT'; payload: Achievement };
```

## Testing Strategy

### Unit Tests
- Game engine command processing
- Lesson validation logic
- Score calculation
- Achievement triggers

### Integration Tests
- API endpoints
- WebSocket communication
- Database operations

### E2E Tests
- Complete lesson flow
- Achievement earning
- Progress tracking

## Performance Considerations

1. **Lesson Caching**: Cache lesson content in browser
2. **Lazy Loading**: Load lessons on demand
3. **WebSocket Pooling**: Reuse connections
4. **Database Indexing**: Index on user_id, lesson_id
5. **CDN for Assets**: Serve static files from CDN

## Security

1. **Authentication**: JWT tokens for API access
2. **Input Validation**: Sanitize all vim commands
3. **Rate Limiting**: Prevent command spam
4. **SQL Injection**: Use parameterized queries
5. **XSS Prevention**: Sanitize user-generated content

## Deployment

```yaml
# docker-compose.yml
version: '3.8'
services:
  frontend:
    build: ./client
    ports:
      - "3000:3000"
  
  backend:
    build: ./server
    ports:
      - "3001:3001"
    volumes:
      - ./database:/app/database
  
  nginx:
    image: nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
```

## Future Enhancements

1. **Multiplayer Races**: Compete in real-time
2. **Custom Lessons**: User-created content
3. **Video Tutorials**: Embedded video guides
4. **Mobile App**: React Native version
5. **AI Tutor**: GPT-powered hints and explanations
6. **Macro Recording**: Record and replay complex sequences
7. **Theme Customization**: Different visual themes
8. **Social Features**: Friends, teams, challenges

## Development Workflow

When continuing work on this project:

1. Check `vim-game/TODO.md` for current tasks
2. Run tests to ensure nothing is broken
3. Read recent commits for context
4. Check `CHANGELOG.md` for recent changes
5. Review open issues in `ISSUES.md`

Key files to understand:
- `server/src/game/VimGameEngine.js` - Core game logic
- `client/src/game/VimSimulator.tsx` - Frontend vim simulator
- `lessons/curriculum.yaml` - Lesson structure
- `database/schema.sql` - Database structure