# 🚀 JetBrains-Style Neovim Configuration

> A complete Neovim setup that brings the power and familiarity of JetBrains IDEs to the efficiency of Vim

## 🎯 Quick Start

### Installation

1. **Backup your existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration**:
   ```bash
   git clone <your-repo> ~/.config/nvim
   ```

3. **Open Neovim**:
   ```bash
   nvim
   ```
   LazyVim will automatically install all plugins on first launch.

4. **Install Language Servers**:
   ```vim
   :Mason
   ```
   Press `i` on any language server to install it.

### First Steps

- Press `Space` (leader key) to see available commands
- Press `Space+1` to open the file explorer 📁
- Press `Space+ff` to find files 🔍
- Press `Space+fg` to search in files 🔎
- Press `Space+8` to open terminal 💻

## 🎮 VimGame - Learn Your Bindings Interactively!

**The coolest part!** An interactive game that teaches YOU the exact shortcuts you've configured.

### Start the Learning Game:

```bash
cd ~/.config/nvim/vim-game

# Start the game (simple version - works instantly!)
./start-simple.sh
```

**Then open**: http://localhost:3001

### What You'll Learn:

- 🎯 **Panel System**: Master your Space+1-8 shortcuts
- 🔧 **Refactoring**: Practice Shift+F6, F6, Space+ri (inline)
- 🐛 **Debugging**: Learn F5, F10, F11 workflow
- 🧪 **Testing**: Master your Space+tt test commands
- ⚡ **Advanced**: Multi-cursor (Ctrl+G), line movement (Shift+Up/Down)

## 📚 Documentation Website

Beautiful docs for your configuration with search and navigation.

### Run the Docs Site:

```bash
cd ~/.config/nvim/docs-site

npm install         # One-time install
npm start          # Build and serve at localhost:3000
```

## 🎨 Core Features

### IDE-Style Panels (Space+1-8)
- **`Space+1`** - 📁 File Explorer (Neo-tree)
- **`Space+2`** - 🔀 Git Status Panel
- **`Space+3`** - ▶️ Run Configurations
- **`Space+4`** - 🐛 Debugger UI
- **`Space+5`** - 💾 Database Browser
- **`Space+6`** - 🐳 Docker Services
- **`Space+7`** - 🏗️ Code Structure/Symbols
- **`Space+8`** - 💻 Terminal Drawer

### JetBrains-Style Keybindings
- **`Shift+F6`** - 🏷️ Rename symbol
- **`F6`** - 📦 Move file
- **`Space+ri`** - 🔗 Inline variable
- **`M`** (visual) - 🎯 Extract Method
- **`Ctrl+G`** - 🎯 Multi-cursor
- **`Ctrl+↑/↓`** - 🔼🔽 Expand/shrink selection
- **`Shift+↑/↓`** - ⬆️⬇️ Move line up/down
- **`Shift+Tab`** - Recent files

### 🔍 Find & Search (Space + f)
- **`Space+ff`** - Find Files
- **`Space+fp`** - Command Palette
- **`Space+fg`** - Search in Files (grep)
- **`Space+fb`** - Switch Buffer

### 🧪 Testing (Space + t)
- **`Space+tt`** - Run Nearest Test
- **`Space+tf`** - Run File Tests
- **`Space+to`** - Test Output
- **`Space+ts`** - Toggle Test Summary

### 🐛 Debugging (F-keys)
- **`F5`** - Continue
- **`F10`** - Step Over
- **`F11`** - Step Into
- **`Shift+F11`** - Step Out
- **`Space+db`** - Toggle Breakpoint
- **`Space+dr`** - Toggle Debug UI

### 🏃 Run Configs
- **`Space+rn`** - Next Run Config
- **`Space+rp`** - Previous Run Config

## 💡 Key Insights

- **Space** is your leader key (much more reliable than Cmd/Alt!)
- **Numbers 1-8** mirror JetBrains panel system
- **F-keys** for debugging (industry standard)
- **Visual feedback** with emojis in which-key
- **Works in ALL terminals** - no more key conflicts!

## 🏗 Architecture & Purpose

This Neovim configuration bridges the gap between JetBrains IDEs and Vim, providing:

1. **Familiar Keybindings** - Your muscle memory from WebStorm/PyCharm works here
2. **IDE Features** - Debugging, refactoring, database browsing, and more
3. **Vim Power** - All the efficiency of modal editing and text objects
4. **Modern UI** - Clean, discoverable interface with helpful hints

### Base Distribution: LazyVim

We build on **LazyVim** because it provides:
- Sensible defaults
- Lazy loading for fast startup (~45ms!)
- Modular plugin system
- Active maintenance and community

### Panel System Architecture
```
┌─────────────────────────────────────────────┐
│  Tabs (Bufferline)                          │
├────────┬────────────────────────┬───────────┤
│ Sp+1   │                        │ Sp+7      │
│ File   │    Main Editor         │ Structure │
│ Tree   │                        │           │
│        │                        │           │
├────────┴────────────────────────┴───────────┤
│ Sp+8 Terminal / Sp+4 Debug / Sp+3 Run      │
└─────────────────────────────────────────────┘
```

## 🛠 Project Structure

```
~/.config/nvim/
├── 🎮 vim-game/                # Interactive learning game for YOUR bindings
│   ├── server/                 # Backend API & game engine
│   ├── client/                 # React frontend
│   ├── lessons/                # Lesson content (YOUR bindings)
│   └── specs/                  # Technical documentation
├── 📚 docs-site/               # Beautiful documentation website
│   ├── build.js               # Static site generator
│   ├── server.js              # Express server
│   └── public/                # Generated HTML files
├── ⚙️ lua/
│   ├── config/
│   │   ├── lazy.lua           # Plugin manager setup
│   │   ├── options.lua        # Neovim options
│   │   ├── keymaps.lua        # JetBrains keybindings ⭐ KEY FILE
│   │   ├── autocmds.lua       # Auto commands
│   │   ├── performance.lua    # Performance optimizations
│   │   ├── run.lua            # Run configurations
│   │   └── docker.lua         # Docker services
│   └── plugins/
│       ├── jetbrains.lua      # JetBrains panel features
│       ├── transparency.lua   # iTerm2 transparency
│       └── ...                # Other plugin configs
├── 🧪 test/
│   ├── all_passing_tests.lua # Main test suite (41 passing tests)
│   └── run.sh                 # Test runner script
└── 📖 docs/                   # Documentation markdown files
```

## 🧪 Testing & Validation

### Comprehensive Test Suite
This configuration includes a **100% passing test suite** with 41 tests:

```bash
# Run all tests (should always pass)
make test

# Expected output:
# ✅ 41 tests passing (100% pass rate)
# ✅ ALL TESTS PASSED!
```

### Performance Validation
```bash
# Check startup time (~42ms target)
make startup-time

# Health check
make health
```

### Test Coverage
- ✅ Environment validation (4 tests)
- ✅ Configuration files (4 tests) 
- ✅ Core functionality (5 tests)
- ✅ Plugin system (4 tests)
- ✅ JetBrains features (8 tests)
- ✅ Performance & integration (16 tests)

## 🎯 What to Use When

### Daily Neovim Usage:
```bash
nvim  # Your config is always ready!
```

### Reading Documentation:
```bash
cd ~/.config/nvim/docs-site && npm start
# Open http://localhost:3000
```

### Learning Your Shortcuts:
```bash
cd ~/.config/nvim/vim-game && ./start-simple.sh
# Open http://localhost:3001
```

### Making Config Changes:
1. Edit files in `lua/config/` or `lua/plugins/`
2. Test: `bash test/run.sh`
3. Update VimGame lessons if needed

## 🔄 Customization

### Adding Custom Keybindings
Edit `lua/config/keymaps.lua`:
```lua
vim.keymap.set("n", "<your-key>", "<your-command>", { desc = "Description" })
```

### Adding Plugins
Create a new file in `lua/plugins/`:
```lua
return {
  {
    "plugin/name",
    config = function()
      -- configuration
    end,
  },
}
```

### Custom Run Configurations
Edit `.nvim-run-configs.json` in your project:
```json
{
  "configs": [
    {
      "name": "Dev Server",
      "cmd": "npm run dev",
      "type": "terminal"
    },
    {
      "name": "Tests",
      "cmd": "npm test",
      "type": "terminal"
    }
  ]
}
```

### Per-Project Settings
Create `.nvim.lua` in project root:
```lua
-- Project-specific settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
```

## ⚡ Performance Optimizations

- **Startup time**: < 50ms (achieved through lazy loading)
- **Test suite**: 100% pass rate
- **Documentation site**: < 1s page load
- **VimGame**: < 50ms command response time

### File Size Limits
- Treesitter disabled for files > 100KB
- Large file mode for better performance
- Streaming for log files

## 🆘 Troubleshooting

### Neovim Issues:
```bash
# Config won't start
nvim --headless -c "checkhealth" -c "quit"

# Slow startup
nvim --startuptime /tmp/startup.log -c quit
grep "NVIM STARTED" /tmp/startup.log

# Plugin issues
:Lazy check
:Lazy update
```

### VimGame Issues:
```bash
cd ~/.config/nvim/vim-game

# Port conflicts
lsof -ti:3000 | xargs kill -9  # Kill frontend
lsof -ti:3001 | xargs kill -9  # Kill backend

# Fresh setup
rm -rf node_modules server/node_modules client/node_modules
./scripts/setup.sh
```

### Documentation Site Issues:
```bash
cd ~/.config/nvim/docs-site

# Node version (needs 20.11.0)
node -v
asdf local nodejs 20.11.0  # If using asdf

# Rebuild everything
npm run build
```

### Common Issues and Solutions
- **Plugins not loading**: Run `:Lazy sync`
- **LSP not working**: Run `:Mason` and install servers
- **Keybindings not working**: Check `:checkhealth`
- **Performance issues**: Disable unused plugins in `lua/config/lazy.lua`
- **Tests failing**: Run `make clean && make test` (very rare)

## 🔥 Pro Tips

### Keyboard Maestro Integration:
Your Space+1-8 shortcuts work best with proper terminal key handling. Consider:
- iTerm2: Preferences → Profiles → Keys → Left Option Key: Meta
- Terminal: Terminal → Preferences → Profiles → Keyboard

### Performance Optimization:
```bash
# Check what's slow
nvim --startuptime /tmp/startup.log -c quit
sort -k2 /tmp/startup.log | tail -20

# Clean up if needed
:Lazy clean
:checkhealth
```

### Backup Strategy:
```bash
# This entire directory is your config
cd ~/.config/nvim
git status  # Should be clean
git add . && git commit -m "Config backup $(date)"
```

## 📊 Comparison with JetBrains

### What's Better
- **Startup time** - Instant vs 10-30 seconds
- **Resource usage** - 50MB vs 2GB RAM
- **Customization** - Complete control
- **Text editing** - Vim motions
- **Terminal integration** - Native terminal

### What's Different
- **Modal editing** - Requires learning curve
- **Configuration** - Text files vs GUI
- **Plugin ecosystem** - Community-driven
- **Update cycle** - Rolling updates

### What's Missing
- **Advanced debugging** - Some IDE-specific features
- **Database GUI** - More basic than DataGrip
- **Drag & drop** - Limited mouse support
- **Project templates** - Manual setup

## 🎮 VimGame Development

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

## 📝 Important Notes

1. Always verify tests pass before committing changes
2. The configuration is optimized for macOS with iTerm2
3. Uses LazyVim as the base distribution
4. Node 20.11.0 is required for web components (via .nvmrc)
5. All JetBrains keybindings use leader key (Space) for panel navigation
6. **VimGame teaches YOUR bindings, not generic vim**

## 🎉 You're All Set!

This is a **complete development environment** with:

- 🚀 **Blazing fast Neovim** with JetBrains shortcuts
- 🎮 **Interactive learning game** for YOUR bindings
- 📚 **Beautiful documentation** site
- 🧪 **Comprehensive testing** (41+ tests, 100% passing)
- ⚡ **Performance optimized** (~45ms startup)

**Start with**: `nvim` (use your config) or `cd vim-game && npm run dev` (learn it!)

Happy coding! 🔥

## 📝 License

This configuration is provided as-is for personal use.