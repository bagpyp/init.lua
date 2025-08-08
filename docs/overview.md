# 📘 Overview: JetBrains Parity in Neovim

**[← Home](../README.md)** | **[Next: Keymap Cheatsheet →](keymap-cheatsheet.md)**

---

## 🎯 Purpose

This Neovim configuration bridges the gap between JetBrains IDEs and Vim, providing:

1. **Familiar Keybindings** - Your muscle memory from WebStorm/PyCharm works here
2. **IDE Features** - Debugging, refactoring, database browsing, and more
3. **Vim Power** - All the efficiency of modal editing and text objects
4. **Modern UI** - Clean, discoverable interface with helpful hints

## 🏗 Architecture

### Base Distribution: LazyVim

We build on **LazyVim** because it provides:
- Sensible defaults
- Lazy loading for fast startup
- Modular plugin system
- Active maintenance and community

### Plugin Philosophy

Each plugin is chosen for a specific JetBrains feature:

| JetBrains Feature | Neovim Solution | Why This Choice |
|------------------|-----------------|-----------------|
| Project View | Neo-tree | Most IDE-like file explorer |
| Find in Files | Telescope | Powerful fuzzy finding |
| Debugger | nvim-dap | Full DAP protocol support |
| Git Integration | Gitsigns + Fugitive | Complete git workflow |
| Database Tools | vim-dadbod-ui | SQL execution and browsing |
| Run Configs | Custom module | Matches JetBrains workflow |
| Refactoring | refactoring.nvim | Extract/inline operations |
| Multiple Cursors | vim-visual-multi | True multi-cursor editing |

## 🎮 Panel System (Space+1-8)

The configuration implements JetBrains' panel system:

### Panel Architecture
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

### Panel Keybindings  
- **Toggle Behavior**: Each Space+Number toggles its panel
- **Focus Behavior**: If open, focuses the panel
- **Persistent State**: Panels remember their state

## 🔄 Workflow Integration

### Development Cycle
1. **Navigate** (`Space+1`) - Browse project structure
2. **Search** (`Space+ff`, `Space+fg`) - Find files and text
3. **Edit** (Vim motions + multi-cursor)
4. **Refactor** (`⇧F6`, extract/inline)
5. **Test** (`<leader>tt`) - Run tests
6. **Debug** (`Space+4`, `F5-F11`) - Step through code
7. **Commit** (`Space+2`, `<leader>gg`) - Version control

### Language Server Protocol (LSP)

Full IDE intelligence through LSP:
- **Auto-completion** - Context-aware suggestions
- **Diagnostics** - Real-time error checking
- **Go to Definition** - Jump to declarations
- **Find References** - See all usages
- **Rename Symbol** - Project-wide refactoring
- **Code Actions** - Quick fixes and improvements

### Testing Framework

Neotest provides:
- Test discovery
- Run configurations
- Debug integration
- Output viewing
- Summary panel

## 🎨 UI/UX Design Principles

### Discoverability
- **Which-key** shows available commands
- **Telescope** provides fuzzy search for everything
- **Command palette** (`⌘⇧P`) for all commands

### Visual Feedback
- **Git signs** in gutter
- **Diagnostic hints** inline
- **Status line** with context
- **Notifications** for actions

### Consistency
- JetBrains keybindings where possible
- Vim conventions for text editing
- Standard LSP bindings for code navigation

## ⚡ Performance Optimizations

### Lazy Loading
- Plugins load on-demand
- Language servers start when needed
- Heavy features activate on first use

### Startup Time
- Target: < 100ms
- Achieved through:
  - Lazy.nvim plugin manager
  - Deferred loading
  - Compiled Lua modules

### File Size Limits
- Treesitter disabled for files > 100KB
- Large file mode for better performance
- Streaming for log files

## 🔧 Extensibility

### Adding Features
1. Create plugin file in `lua/plugins/`
2. Define keybindings in `lua/config/keymaps.lua`
3. Update Which-key in `lua/plugins/which-key-enhanced.lua`
4. Document in `docs/`

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

## 🚀 Advanced Features

### Multi-Root Workspaces
- Open multiple projects
- Switch with Telescope projects
- Separate LSP instances per root

### Remote Development
- Use with SSH
- Container development via Docker
- Codespaces compatible

### AI Integration
- Copilot support included
- Easy to add other AI assistants
- Context-aware suggestions

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

---

**[← Home](../README.md)** | **[Next: Keymap Cheatsheet →](keymap-cheatsheet.md)**