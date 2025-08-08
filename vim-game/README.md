# 🎮 VimGame - Interactive Neovim Learning Framework

## Overview

VimGame is a comprehensive interactive learning platform for mastering the JetBrains-style Neovim configuration. It features:

- 🎯 **Interactive Lessons** - Learn by doing with real vim commands
- 🏆 **Achievement System** - Unlock badges as you progress
- 📊 **Progress Tracking** - See your improvement over time
- 🎮 **Gamification** - Points, streaks, and leaderboards
- 🔄 **Real-time Feedback** - Instant validation of commands
- 📚 **Comprehensive Curriculum** - From basics to advanced JetBrains features

## Architecture

```
vim-game/
├── server/                 # Backend API & WebSocket server
│   ├── src/
│   │   ├── api/           # REST API endpoints
│   │   ├── game/          # Game logic & scoring
│   │   ├── lessons/       # Lesson content & validation
│   │   ├── database/      # User progress & achievements
│   │   └── websocket/     # Real-time vim command handling
│   └── tests/
├── client/                # Frontend React app
│   ├── src/
│   │   ├── components/    # UI components
│   │   ├── game/         # Game engine & vim simulator
│   │   ├── lessons/      # Lesson UI & progression
│   │   └── hooks/        # Custom React hooks
│   └── tests/
├── lessons/              # Lesson content in YAML/JSON
├── specs/               # Technical specifications
└── docs/                # Documentation

```

## Tech Stack

- **Backend**: Node.js + Express + Socket.io
- **Frontend**: React + TypeScript + Tailwind CSS
- **Database**: SQLite (simple, portable)
- **Testing**: Jest + React Testing Library
- **Build**: Vite for blazing fast development

## Getting Started

```bash
# Install dependencies
npm install

# Start development servers
npm run dev

# Run tests
npm test

# Build for production
npm run build
```

## For Future Claude Sessions

This framework is designed for long-term development. Key principles:

1. **Modular Architecture** - Each system is independent
2. **Extensible Lessons** - Easy to add new content
3. **Test Coverage** - Everything has tests
4. **Documentation First** - Specs before code
5. **Progressive Enhancement** - Start simple, add features

See `specs/ARCHITECTURE.md` for detailed technical documentation.