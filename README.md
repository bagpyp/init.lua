# 🚀 JetBrains-Style Neovim Configuration

> A complete Neovim setup that brings the power and familiarity of JetBrains IDEs to the efficiency of Vim

## 📚 Documentation Navigation

1. **[Overview](docs/overview.md)** - Purpose and architecture
2. **[Keymap Cheatsheet](docs/keymap-cheatsheet.md)** - Complete keybinding reference
3. **[Testing Workflow](docs/workflows/testing.md)** - Using Neotest effectively
4. **[Debugging Workflow](docs/workflows/debugging.md)** - DAP setup and usage
5. **[Refactoring Workflow](docs/workflows/refactoring.md)** - Code refactoring tools
6. **[Multi-cursor Workflow](docs/workflows/multicursor.md)** - Multiple cursor editing
7. **[Services & Docker](docs/workflows/services.md)** - Container management
8. **[Code Structure](docs/workflows/structure.md)** - Symbol navigation
9. **[Learning Vim](docs/learning-vim.md)** - Vim motions and tips

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
- Press `Cmd+1` to open the file explorer
- Press `Cmd+P` to find files
- Press `Shift+Cmd+F` to search in files
- Press `Cmd+8` to open terminal

## 🎨 Core Features

### IDE-Style Panels (Cmd+1-8)
- **`⌘1`** - File Explorer (Neo-tree)
- **`⌘2`** - Git Status Panel
- **`⌘3`** - Run Configurations
- **`⌘4`** - Debugger UI
- **`⌘5`** - Database Browser
- **`⌘6`** - Docker Services
- **`⌘7`** - Code Structure/Symbols
- **`⌘8`** - Terminal Drawer

### JetBrains-Style Keybindings
- **`⇧F6`** - Rename symbol
- **`F6`** - Move file
- **`⌘⌥N`** - Inline variable
- **`⌃G`** - Multi-cursor
- **`⌥↑/↓`** - Expand/shrink selection
- **`⇧⇥`** - Recent files

## 🛠 Installed Plugins

### Core
- **LazyVim** - Base configuration
- **Telescope** - Fuzzy finding
- **Neo-tree** - File explorer
- **Which-key** - Keybinding discovery

### Development
- **nvim-lspconfig** - Language server protocol
- **nvim-cmp** - Autocompletion
- **Treesitter** - Syntax highlighting
- **nvim-dap** - Debugging

### Testing & Debugging
- **Neotest** - Test runner
- **nvim-dap-ui** - Debug interface

### Git Integration
- **Gitsigns** - Git decorations
- **Fugitive** - Git commands
- **Diffview** - Diff viewer
- **LazyGit** - Git UI

### Editing
- **vim-visual-multi** - Multiple cursors
- **nvim-surround** - Surround text
- **Comment.nvim** - Commenting
- **nvim-autopairs** - Auto-close brackets

## 🔧 Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── config/
│   │   ├── lazy.lua           # Plugin manager setup
│   │   ├── options.lua        # Neovim options
│   │   ├── keymaps.lua        # Key mappings
│   │   ├── autocmds.lua       # Auto commands
│   │   ├── run.lua            # Run configurations
│   │   └── docker.lua         # Docker services
│   └── plugins/
│       ├── jetbrains.lua      # JetBrains-style features
│       ├── lsp.lua            # Language servers
│       ├── ui.lua             # UI enhancements
│       ├── telescope.lua      # Fuzzy finder
│       ├── treesitter.lua     # Syntax highlighting
│       ├── git.lua            # Git integration
│       └── which-key-enhanced.lua  # Keybinding hints
└── docs/                       # Documentation
    ├── overview.md
    ├── keymap-cheatsheet.md
    └── workflows/
        ├── testing.md
        ├── debugging.md
        ├── refactoring.md
        ├── multicursor.md
        ├── services.md
        └── structure.md
```

## 💡 Tips

1. **Discovery**: Press `Space` to explore available commands
2. **Help**: Press `Space f h` to search help documentation
3. **Commands**: Press `Cmd+Shift+P` for command palette
4. **Updates**: Run `:Lazy` to update plugins

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

### Modifying Options
Edit `lua/config/options.lua` to change Neovim settings.

## 🆘 Troubleshooting

- **Plugins not loading**: Run `:Lazy sync`
- **LSP not working**: Run `:Mason` and install servers
- **Keybindings not working**: Check `:checkhealth`
- **Performance issues**: Disable unused plugins in `lua/config/lazy.lua`

## 📝 License

This configuration is provided as-is for personal use.

---

**[Next: Overview →](docs/overview.md)**