# 🔑 Keymap Cheatsheet

**[← Previous: Overview](overview.md)** | **[Next: Testing Workflow →](workflows/testing.md)**

---

## 🎹 JetBrains IDE Panels (Space+Number)

| Key | Action | Description | Icon |
|-----|--------|-------------|------|
| `Space+1` | File Explorer | Toggle Neo-tree file browser | 📁 |
| `Space+2` | Git Status | Show git changes panel | 🔀 |
| `Space+3` | Run Configs | Show/hide run configurations | ▶️ |
| `Space+4` | Debugger | Toggle debug UI | 🐛 |
| `Space+5` | Database | Open database browser | 💾 |
| `Space+6` | Services | Docker containers panel | 🐳 |
| `Space+7` | Structure | Code outline/symbols | 🏗️ |
| `Space+8` | Terminal | Toggle terminal drawer | 💻 |

## 🔍 Search & Navigation

### Files & Projects
| Key | Action | JetBrains Equivalent | Icon |
|-----|--------|---------------------|------|
| `Space+ff` | Find Files | Find File | 🔍 |
| `Space+fp` | Command Palette | Find Action | 🎛️ |
| `Space+fg` | Search in Files | Find in Path | 🔎 |
| `Space+fb` | Switch Buffer | Recent Files | 📋 |
| `<leader>fr` | Recent Files | Recent Files | 🕐 |

### Symbol Navigation
| Key | Action | JetBrains Equivalent |
|-----|--------|---------------------|
| `gd` | Go to Definition | Ctrl+B |
| `gr` | Go to References | Ctrl+Shift+F7 |
| `gI` | Go to Implementation | Ctrl+Alt+B |
| `K` | Hover Documentation | Ctrl+J |

## 🔧 Refactoring

| Key | Action | JetBrains Equivalent | Icon |
|-----|--------|---------------------|------|
| `Shift+F6` | Rename Symbol | Rename | 🏷️ |
| `F6` | Move File | Move | 📦 |
| `Space+ri` | Inline Variable | Inline | 🔗 |
| `M` (visual) | Extract Method | Extract Method | 🎯 |

## 🐛 Debugging

### Debug Controls
| Key | Action | JetBrains Equivalent |
|-----|--------|---------------------|
| `F5` | Continue | Continue |
| `F10` | Step Over | Step Over |
| `F11` | Step Into | Step Into |
| `Shift+F11` | Step Out | Step Out |
| `<leader>db` | Toggle Breakpoint | Toggle Breakpoint |
| `<leader>dr` | Toggle Debug UI | Debug Tool Window |

## 🧪 Testing

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>tt` | Run Nearest Test | Run test at cursor |
| `<leader>tf` | Run File Tests | Run all tests in file |
| `<leader>to` | Test Output | Show test output |
| `<leader>ts` | Test Summary | Toggle test summary |

## 🎯 Multi-cursor & Selection

| Key | Action | JetBrains Equivalent | Icon |
|-----|--------|---------------------|------|
| `Ctrl+G` | Add Cursor | Alt+J | 🎯 |
| `Ctrl+Up` | Expand Selection | Ctrl+W | 🔼 |
| `Ctrl+Down` | Shrink Selection | Ctrl+Shift+W | 🔽 |
| `Shift+Up` | Move Line Up | Shift+Alt+Up | ⬆️ |
| `Shift+Down` | Move Line Down | Shift+Alt+Down | ⬇️ |

## 📊 Run Configurations

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>rn` | Next Run Config | Cycle to next config |
| `<leader>rp` | Previous Run Config | Cycle to previous config |

## 🔄 Git Integration

### Git Commands
| Key | Action | Description |
|-----|--------|-----------|

### Git Hunks (Gitsigns)
| Key | Action | Description |
|-----|--------|-------------|  
| `]c` | Next Hunk | Jump to next change |
| `[c` | Previous Hunk | Jump to previous change |
| `<leader>hs` | Stage Hunk | Stage current hunk |
| `<leader>hr` | Reset Hunk | Reset current hunk |
| `<leader>hS` | Stage Buffer | Stage entire buffer |
| `<leader>hu` | Undo Stage Hunk | Undo hunk staging |
| `<leader>hR` | Reset Buffer | Reset entire buffer |
| `<leader>hp` | Preview Hunk | Preview hunk changes |
| `<leader>hb` | Blame Line | Show blame for line |
| `<leader>tb` | Toggle Blame | Toggle blame display |
| `<leader>hd` | Diff This | Diff against index |
| `<leader>hD` | Diff This ~ | Diff against parent |
| `<leader>td` | Toggle Deleted | Show deleted lines |
| `ih` | Select Hunk | Text object for hunk |

### Git Operations
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gg` | LazyGit | Full git interface |
| `<leader>gG` | LazyGit Current File | LazyGit for current file |
| `<leader>gc` | Git Commits (Telescope) | Show commit history |
| `<leader>gb` | Git Branches (Telescope) | Switch branches |
| `<leader>gs` | Git Status | Show git status |
| `<leader>gd` | Git Diff | Show git diff |
| `<leader>gp` | Git Push | Push to remote |
| `<leader>gP` | Git Pull | Pull from remote |
| `<leader>gl` | Git Log | Show git log |
| `<leader>gf` | Git Fetch | Fetch from remote |
| `<leader>gw` | Git Worktrees | Manage worktrees |
| `<leader>gW` | Create Git Worktree | Create new worktree |

## 🖼️ Window Management

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+H` | Left Window | Focus left split |
| `Ctrl+J` | Down Window | Focus down split |
| `Ctrl+K` | Up Window | Focus up split |
| `Ctrl+L` | Right Window | Focus right split |

## ⚙️ Additional Utilities

### Text Editing
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>qq` | Quit All | Exit Neovim completely |
| `<esc>` | Clear Search | Clear search highlights |
| `<` | Dedent | Dedent in visual mode |
| `>` | Indent | Indent in visual mode |
| `gcc` | Toggle Comment | Comment/uncomment line |
| `gc` | Toggle Comment | Comment/uncomment selection |
| `gs` | Switch Values | Toggle true/false, on/off, etc. |

### macOS-Specific Keymaps
*Note: These keymaps only work on macOS with proper terminal configuration*

| Key | Action | Description |
|-----|--------|-------------|
| `<D-s>` | Save | Save current file |
| `<S-D-Up>` | Move Line Up | Move line up (Mac) |
| `<S-D-Down>` | Move Line Down | Move line down (Mac) |
| `<S-D-]>` | Next Run Config | Next run configuration (Mac) |
| `<S-D-[>` | Previous Run Config | Previous run configuration (Mac) |
| `<D-3>` | Run Configs | Open run configurations (Mac) |
| `<D-6>` | Docker Services | Open Docker panel (Mac) |
| `<D-M-n>` | Inline Variable | Inline variable refactoring (Mac) |

## 💡 Tips

1. **Discovery**: Press `Space` to see all available commands with which-key
2. **Context**: Many commands are context-aware (work differently in different file types)
3. **Visual**: Most commands work in visual mode too
4. **F-keys**: Debugging F-keys (F5, F10, F11) work just like JetBrains
5. **Consistency**: Space+number system mirrors JetBrains panel shortcuts

---

**[← Previous: Overview](overview.md)** | **[Next: Testing Workflow →](workflows/testing.md)**