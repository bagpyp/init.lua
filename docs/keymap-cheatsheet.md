# 🔑 Keymap Cheatsheet

**[← Previous: Overview](overview.md)** | **[Next: Testing Workflow →](workflows/testing.md)**

---

## 🎹 JetBrains IDE Panels (Cmd+Number)

| Key | Action | Description |
|-----|--------|-------------|
| `⌘1` | File Explorer | Toggle Neo-tree file browser |
| `⌘2` | Git Status | Show git changes panel |
| `⌘3` | Run Configs | Show/hide run configurations |
| `⌘4` | Debugger | Toggle debug UI |
| `⌘5` | Database | Open database browser |
| `⌘6` | Services | Docker containers panel |
| `⌘7` | Structure | Code outline/symbols |
| `⌘8` | Terminal | Toggle terminal drawer |

## 🔍 Search & Navigation

### Files & Projects
| Key | Action | JetBrains Equivalent |
|-----|--------|---------------------|
| `⌘P` | Find Files | Find File |
| `⇧⌘P` | Command Palette | Find Action |
| `⇧⌘F` | Search in Files | Find in Path |
| `⌘B` | Switch Buffer | Recent Files |
| `⇧⇥` | Recent Files | Recent Files |
| `⌘E` | Recent Files | Recent Files |

### Code Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `gd` | Go to Definition | Jump to definition |
| `gD` | Go to Declaration | Jump to declaration |
| `gr` | Find References | Show all references |
| `gi` | Go to Implementation | Jump to implementation |
| `gt` | Go to Type Definition | Jump to type def |
| `K` | Hover Documentation | Show hover info |
| `[d` | Previous Diagnostic | Previous error/warning |
| `]d` | Next Diagnostic | Next error/warning |

## ♻️ Refactoring

| Key | Action | JetBrains Equivalent |
|-----|--------|---------------------|
| `⇧F6` | Rename Symbol | Rename |
| `F6` | Move File | Move |
| `⌘⌥N` | Inline Variable | Inline |
| `M` (visual) | Extract Method | Extract Method |
| `<leader>re` | Extract Function | Extract Method |
| `<leader>rv` | Extract Variable | Extract Variable |
| `<leader>ri` | Inline Variable | Inline |

## 🐛 Debugging

| Key | Action | JetBrains Equivalent |
|-----|--------|---------------------|
| `F5` | Continue/Start | Resume Program |
| `F10` | Step Over | Step Over |
| `F11` | Step Into | Step Into |
| `⇧F11` | Step Out | Step Out |
| `⌘4` | Toggle Debug UI | Debug Tool Window |
| `<leader>db` | Toggle Breakpoint | Toggle Breakpoint |
| `<leader>dB` | Conditional Breakpoint | Conditional Breakpoint |

## 🧪 Testing

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>tt` | Run Nearest Test | Run test at cursor |
| `<leader>tf` | Run File Tests | Run all tests in file |
| `<leader>td` | Debug Test | Debug test at cursor |
| `<leader>to` | Test Output | Show test output |
| `<leader>ts` | Test Summary | Toggle test summary |

## ✏️ Editing

### Multi-Cursor
| Key | Action | JetBrains Equivalent |
|-----|--------|---------------------|
| `⌃G` | Add Cursor | Add Selection for Next |
| `⌃↓` | Add Cursor Below | Clone Caret Below |
| `⌃↑` | Add Cursor Above | Clone Caret Above |
| `⌥↑` | Expand Selection | Extend Selection |
| `⌥↓` | Shrink Selection | Shrink Selection |

### Text Manipulation
| Key | Action | Description |
|-----|--------|-------------|
| `⇧⌘↑` | Move Line Up | Move line/selection up |
| `⇧⌘↓` | Move Line Down | Move line/selection down |
| `gcc` | Toggle Comment | Comment line |
| `gc` (visual) | Toggle Comment | Comment selection |
| `ys` | Add Surround | Surround with... |
| `cs` | Change Surround | Change surrounding |
| `ds` | Delete Surround | Delete surrounding |

## 📝 Leader Key Mappings

> Leader key is `Space`. Press `Space` to see all available commands.

### Files (`<leader>f`)
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |

### Git (`<leader>g`)
| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |
| `<leader>gs` | Git status |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gb` | Git branches |

### LSP (`<leader>l`)
| Key | Action |
|-----|--------|
| `<leader>la` | Code action |
| `<leader>lr` | Rename |
| `<leader>lf` | Format |
| `<leader>ld` | Definition |
| `<leader>lR` | References |

### Windows (`<leader>w`)
| Key | Action |
|-----|--------|
| `<leader>w-` | Split below |
| `<leader>w\|` | Split right |
| `<leader>wd` | Close window |
| `<leader>w=` | Equal size |

## 🎮 Vim Motions Quick Reference

### Movement
| Key | Action |
|-----|--------|
| `h/j/k/l` | Left/Down/Up/Right |
| `w/b` | Next/Previous word |
| `0/$` | Start/End of line |
| `gg/G` | Start/End of file |
| `{/}` | Previous/Next paragraph |
| `%` | Matching bracket |

### Operators
| Key | Action | Example |
|-----|--------|---------|
| `d` | Delete | `dw` = delete word |
| `c` | Change | `ciw` = change in word |
| `y` | Yank (copy) | `yy` = yank line |
| `v` | Visual select | `viw` = select in word |
| `>/<` | Indent | `>G` = indent to end |

### Text Objects
| Object | Meaning | Example |
|--------|---------|---------|
| `iw/aw` | In/Around word | `diw` = delete in word |
| `is/as` | In/Around sentence | `cas` = change around sentence |
| `ip/ap` | In/Around paragraph | `vip` = select in paragraph |
| `i"/a"` | In/Around quotes | `ci"` = change in quotes |
| `i(/a(` | In/Around parens | `da(` = delete around parens |
| `it/at` | In/Around tags | `cit` = change in HTML tag |

## 🚀 Quick Actions

| Action | Keys |
|--------|------|
| Save | `:w` or `⌘S` |
| Save All | `:wa` |
| Quit | `:q` |
| Force Quit | `:q!` |
| Save & Quit | `:wq` or `ZZ` |
| Undo | `u` |
| Redo | `⌃r` |
| Search | `/pattern` |
| Replace | `:%s/old/new/g` |

## 💡 Pro Tips

1. **Discovery**: Press `Space` and wait to see available commands
2. **Which-key**: Press `g` or `[` or `]` and wait for hints
3. **Command Palette**: Use `⌘⇧P` to search for any command
4. **Help**: `:help <topic>` or `<leader>fh` to search help
5. **Repeat**: `.` repeats the last change
6. **Macros**: `q<letter>` to record, `@<letter>` to play

---

**[← Previous: Overview](overview.md)** | **[Next: Testing Workflow →](workflows/testing.md)**