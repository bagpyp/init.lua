# 🐛 Debugging Workflow with nvim-dap

**[← Previous: Testing Workflow](testing.md)** | **[Next: Refactoring Workflow →](refactoring.md)**

---

## Overview

The debugging setup provides a full-featured debugging experience similar to JetBrains IDEs, using the Debug Adapter Protocol (DAP). Press `Space+4` to toggle the debug UI.

## 🚀 Quick Start

### Essential Keybindings

| Action | Key | JetBrains Equivalent |
|--------|-----|---------------------|
| Toggle Debug UI | `Space+4` | Debug Tool Window |
| Continue/Start | `F5` | Resume Program |
| Step Over | `F10` | Step Over |
| Step Into | `F11` | Step Into |
| Step Out | `Shift+F11` | Step Out |
| Toggle Breakpoint | `<leader>db` | Toggle Breakpoint |
| Stop Debugging | `Shift+F5` | Stop |

## 🎯 Setting Breakpoints

### Basic Breakpoints
```vim
" Toggle breakpoint on current line
<leader>db

" Or click in the gutter (sign column)
```

### Conditional Breakpoints
```vim
" Set conditional breakpoint
<leader>dB
" Enter condition: i > 10

" Log point (doesn't stop execution)
<leader>dl
" Enter message: Value of i: {i}
```

### Breakpoint Management
```vim
" List all breakpoints
<leader>dlb

" Clear all breakpoints
<leader>dC

" Enable/disable breakpoint
<leader>de
```

## 🖥 Debug UI Layout

When you press `Space+4`, the debug UI opens with:

```
┌─────────────────────────────────────────────┐
│  Code Editor (with breakpoint indicators)   │
├─────────────┬───────────────────────────────┤
│ Variables   │  Breakpoints                  │
│ ├─ locals   │  • app.js:42                  │
│ │  └─ user  │  • utils.js:13 [i > 10]       │
│ └─ globals  │  • api.js:7 (disabled)        │
├─────────────┼───────────────────────────────┤
│ Call Stack  │  Watches                      │
│ > main()    │  user.name: "John"            │
│   api()     │  count: 42                    │
│   handle()  │  isValid: true                │
├─────────────┴───────────────────────────────┤
│ REPL / Debug Console                        │
│ > user.permissions                          │
│ ['read', 'write']                           │
└─────────────────────────────────────────────┘
```

## 🔧 Language-Specific Setup

### JavaScript/TypeScript

#### Node.js Debugging
```javascript
// launch.json equivalent in Lua
{
  type = "pwa-node",
  request = "launch",
  name = "Launch Program",
  program = "${file}",
  cwd = "${workspaceFolder}",
}
```

#### Browser Debugging
```javascript
{
  type = "pwa-chrome",
  request = "launch",
  name = "Launch Chrome",
  url = "http://localhost:3000",
  webRoot = "${workspaceFolder}",
}
```

#### Debug Current Test
```vim
" Debug test under cursor
<leader>td

" Debug all tests in file
<leader>tdf
```

### Python

#### Python Script
```python
{
  type = "python",
  request = "launch",
  name = "Launch Python",
  program = "${file}",
  console = "integratedTerminal",
}
```

#### Django Server
```python
{
  type = "python",
  request = "launch",
  name = "Django",
  program = "${workspaceFolder}/manage.py",
  args = ["runserver"],
  django = true,
}
```

### Go

```go
{
  type = "go",
  request = "launch",
  name = "Launch Go",
  program = "${file}",
}
```

## 📊 Debug Console & REPL

### Using the REPL
```vim
" Toggle REPL
<leader>dr

" In REPL, you can:
> print(variable_name)
> variable_name = new_value
> import module
> help(function)
```

### Evaluate Expression
```vim
" Hover evaluation
K  " While debugging, shows value

" Evaluate selection
<leader>de  " In visual mode

" Add to watch
<leader>dw
```

## 🔍 Variable Inspection

### Variables Panel
- **Locals**: Current scope variables
- **Globals**: Global variables
- **Upvalues**: Closure variables

### Watch Expressions
```vim
" Add watch
<leader>dw
Enter: user.profile.settings

" Remove watch
" Navigate to watch panel and press 'd'
```

### Hover Information
While debugging, hover over any variable to see its value:
- Press `K` over variable
- Value appears in floating window
- Complex objects are expandable

## 🎮 Advanced Debugging

### Remote Debugging

#### Attach to Process
```lua
{
  type = "pwa-node",
  request = "attach",
  name = "Attach to Process",
  processId = require("dap.utils").pick_process,
  cwd = "${workspaceFolder}",
}
```

#### Remote Node.js
```lua
{
  type = "pwa-node",
  request = "attach",
  name = "Attach to Remote",
  address = "localhost",
  port = 9229,
}
```

### Multi-threaded Debugging

```vim
" Switch thread
<leader>dt

" View all threads
:DapThreads

" Pause all threads
<leader>dP
```

### Exception Handling

```vim
" Break on exceptions
<leader>dE

" Configure exception breakpoints
:DapExceptions
" - Caught exceptions
" - Uncaught exceptions
" - User unhandled exceptions
```

## 📝 Debug Configurations

### Project Configuration

Create `.vscode/launch.json` (compatible with VSCode):
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "pwa-node",
      "request": "launch",
      "name": "Debug Server",
      "program": "${workspaceFolder}/server.js",
      "env": {
        "NODE_ENV": "development",
        "DEBUG": "app:*"
      }
    },
    {
      "type": "pwa-node",
      "request": "launch",
      "name": "Debug Tests",
      "program": "${workspaceFolder}/node_modules/.bin/jest",
      "args": ["--runInBand"],
      "console": "integratedTerminal"
    }
  ]
}
```

### Select Configuration
```vim
" List and select debug configuration
<leader>dc

" Run last configuration
<leader>dl

" Edit configurations
<leader>dE
```

## 🎯 Debugging Strategies

### 1. Print Debugging Alternative
Instead of `console.log`:
```vim
" Set logpoint
<leader>dl
Message: "Value at line {line}: {variable}"
```

### 2. Conditional Debugging
```javascript
// Only break in specific conditions
if (user.role === 'admin') {
  debugger; // Will be caught by DAP
}
```

### 3. Time Travel Debugging
```vim
" Step backwards (if supported)
<leader>dB

" Reverse continue
<leader>dR
```

## 💡 Tips and Tricks

### Quick Debug Session
```vim
" Debug current file instantly
:DapRun

" Debug with arguments
:DapRun arg1 arg2
```

### Debug Keybinding Customization
```lua
-- In your keymaps.lua
vim.keymap.set("n", "<F9>", require("dap").toggle_breakpoint)
vim.keymap.set("n", "<F5>", require("dap").continue)
vim.keymap.set("n", "<F10>", require("dap").step_over)
```

### Performance Profiling
```vim
" Start profiling
:DapProfile start

" Stop and view results
:DapProfile stop
:DapProfile view
```

## 🔌 Integration

### With Test Runner
```vim
" Debug test under cursor
<leader>td

" Debug failed tests
<leader>tdf
```

### With Git
```vim
" Debug from specific commit
:DapGit <commit-hash>
```

### With Terminal
```vim
" Debug terminal command
:DapTerm npm start
```

## 🚨 Troubleshooting

### Debugger Not Starting
1. Check adapter is installed: `:DapInfo`
2. Verify debug adapter path
3. Check language server is running

### Breakpoints Not Hit
1. Ensure source maps are enabled
2. Check file paths match
3. Verify debug configuration

### Slow Debugging
1. Disable unnecessary watches
2. Limit variable expansion depth
3. Use conditional breakpoints

### Debug Adapter Installation

```vim
" Install missing adapters
:DapInstall <adapter-name>

" Update adapters
:DapUpdate

" List available adapters
:DapList
```

---

**[← Previous: Testing Workflow](testing.md)** | **[Next: Refactoring Workflow →](refactoring.md)**