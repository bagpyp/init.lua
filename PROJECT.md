# Project Context

This file contains important context and documentation for this Neovim configuration.

## Project Overview

This is a JetBrains-style Neovim configuration that mimics WebStorm/PyCharm IDE features with:
- Space+1-8 panel system (files, git, run, debug, database, services, structure, terminal)
- Refactoring tools (Shift+F6 rename, F6 move, Space+ri inline, M extract method)
- Multi-cursor editing (Ctrl+G), smart selection (Ctrl+Up/Down), line movement
- Test runner with configurations
- Docker services integration
- ~45ms startup time

## 🎮 VimGame - Interactive Learning System

**IMPORTANT**: The VimGame system in `vim-game/` is designed to teach the **ACTUAL BINDINGS from THIS repository**. It's not a generic vim tutorial - it's specifically for learning the JetBrains-style keybindings configured in this Neovim setup.

### VimGame Purpose
- Teaches the **exact bindings** configured in `lua/config/keymaps.lua`
- Focuses on JetBrains-style shortcuts (Space+1-8 panels, F-key debugging, etc.)
- Interactive lessons for mastering **YOUR** configuration
- Progress tracking and achievements for **YOUR** workflow patterns

### Key VimGame Features
- **Panel System Lessons**: Master Space+1 (Neotree), Space+2 (Git), Space+3 (Run), etc.
- **Refactoring Challenges**: Learn Shift+F6 (LSP rename), F6 (move file), etc.
- **Debugging Workflow**: Practice F5 (continue), F10 (step over), F11 (step into)
- **Testing Integration**: Master `<leader>tt` (run test), `<leader>tf` (file tests)
- **Advanced Features**: Multi-cursor (Ctrl+G), line movement (Shift+Up/Down)

### Running VimGame
```bash
cd vim-game
npm install:all  # Install all dependencies
npm run dev      # Start both frontend and backend
# Open http://localhost:3000 to play
```

## Testing Instructions

### Neovim Configuration Tests

The main Neovim configuration has a unified test suite with 41 passing tests:

1. **Primary Test Suite** (All tests pass)
   ```bash
   # Run via Makefile (recommended)
   make test
   
   # Or run directly  
   nvim --headless -l test/all_passing_tests.lua
   ```
   This suite covers:
   - Environment validation
   - Configuration files  
   - Core functionality
   - Plugin system
   - Custom modules
   - Performance optimizations
   - Documentation
   - JetBrains features
   - Integration tests

2. **Test Categories**
   ```bash
   make test-unit         # Unit tests
   make test-integration  # Integration tests  
   make test-performance  # Performance tests
   make test-refactoring  # Refactoring tests
   ```

3. **Startup Time Test**
   ```bash
   make startup-time
   ```

### Documentation Site Tests

The documentation site (`docs-site/`) has its own test suite with 19 passing tests:

1. **Install test dependencies**
   ```bash
   cd docs-site
   npm install  # This installs both regular and dev dependencies
   ```

2. **Run all tests**
   ```bash
   npm test
   ```
   This runs Jest tests for:
   - Build process (markdown discovery, HTML generation)
   - Server functionality (static file serving, routing)
   - Integration tests (built output validation)

3. **Run tests in watch mode** (for development)
   ```bash
   npm run test:watch
   ```

4. **Generate test coverage report**
   ```bash
   npm run test:coverage
   ```

5. **Run the documentation site**
   ```bash
   npm start  # Builds and starts server at localhost:3000
   ```

### VimGame Tests

The VimGame framework has comprehensive tests focusing on YOUR bindings:

1. **Backend tests** (Game engine, database, API)
   ```bash
   cd vim-game/server
   npm test
   ```

2. **Frontend tests** (React components, vim simulator)
   ```bash
   cd vim-game/client
   npm test
   ```

3. **Integration tests** (Full lesson flow)
   ```bash
   cd vim-game
   npm test  # Runs both server and client tests
   ```

## Key Commands to Run

When making changes to the configuration, always run these commands to ensure quality:

### For Neovim Config
```bash
# Test the configuration (preferred method)
make test

# Or run tests directly
nvim --headless -l test/all_passing_tests.lua

# Check startup time
make startup-time
```

### For Documentation Site
```bash
cd docs-site
npm test           # Run tests
npm run build      # Build documentation
npm start          # Start documentation server
```

### For VimGame
```bash
cd vim-game
npm install:all    # Install all dependencies
npm test           # Run all tests
npm run dev        # Start development servers
```

## File Structure

```
.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── lazy.lua        # Plugin manager setup
│   │   ├── options.lua     # Neovim options
│   │   ├── keymaps.lua     # JetBrains keybindings ⭐ KEY FILE
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── performance.lua # Performance optimizations
│   │   ├── run.lua         # Run configurations
│   │   └── docker.lua      # Docker services
│   └── plugins/
│       ├── jetbrains.lua   # JetBrains panel features
│       ├── transparency.lua # iTerm2 transparency
│       └── ...             # Other plugin configs
├── test/
│   ├── all_passing_tests.lua # Main test suite
│   ├── run.sh              # Test runner script
│   └── ...                 # Other test files
├── docs/                   # Documentation markdown files
├── docs-site/              # Documentation website
│   ├── package.json        # Node dependencies
│   ├── build.js           # Static site generator
│   ├── server.js          # Express server
│   └── public/            # Generated HTML files
├── vim-game/               # Interactive learning system ⭐ NEW
│   ├── server/            # Backend API & game engine
│   ├── client/            # React frontend
│   ├── lessons/           # Lesson content (YOUR bindings)
│   ├── specs/             # Technical documentation
│   └── TODO.md            # Current development tasks
└── .nvmrc                 # Node version for asdf
```

## Performance Targets

- Startup time: < 50ms
- Test suite: 100% pass rate
- Documentation site: < 1s page load
- VimGame: < 50ms command response time

## Important Notes

1. Always verify tests pass before committing changes
2. The configuration is optimized for macOS with iTerm2
3. Uses LazyVim as the base distribution
4. Node 20.11.0 is required for web components (via .nvmrc)
5. All JetBrains keybindings use leader key (Space) for panel navigation
6. **VimGame teaches YOUR bindings, not generic vim**

## VimGame Development

### Key Development Information:

1. **Read `vim-game/TODO.md`** for current development priorities
2. **Check `vim-game/specs/ARCHITECTURE.md`** for technical specifications
3. **The curriculum in `vim-game/lessons/curriculum.yaml`** teaches the ACTUAL bindings from `lua/config/keymaps.lua`
4. **Tests focus on YOUR bindings** - see `vim-game/server/src/game/VimGameEngine.test.ts`

### Key VimGame Principles:
- Lessons teach the **exact shortcuts** configured in this repository
- Scoring prioritizes **JetBrains-style efficiency** (Space+1-8, F-keys, etc.)
- Achievements based on **YOUR workflow patterns**
- Feedback references **actual keymapping commands** from the config

### VimGame Architecture:
- **Backend**: TypeScript + Express + Socket.io + SQLite
- **Frontend**: React + TypeScript + Tailwind
- **Game Engine**: Simulates vim with YOUR keybindings
- **Database**: Tracks progress on YOUR specific bindings
- **Lessons**: YAML files with challenges for YOUR shortcuts

## Common Issues and Solutions

- **Tests failing in minimal environment**: Use `test/all_passing_tests.lua` instead of Makefile tests
- **Startup time slow**: Check if all performance optimizations in `lua/config/performance.lua` are active
- **Documentation site not building**: Ensure Node 20.11.0 is active (`asdf install nodejs 20.11.0`)
- **Keybindings not working**: Verify terminal supports Cmd key passthrough
- **VimGame not recognizing bindings**: Check that commands match format in `lua/config/keymaps.lua`

## For Long-term Development

This repository will grow significantly. Key files for understanding the system:

1. **`lua/config/keymaps.lua`** - The source of truth for all keybindings
2. **`vim-game/lessons/curriculum.yaml`** - Lessons that teach those keybindings  
3. **`vim-game/TODO.md`** - Current development priorities
4. **`test/all_passing_tests.lua`** - Comprehensive test validation
5. **This file** - Project context and documentation

The VimGame system ensures that as keybindings evolve, the learning system stays in sync.