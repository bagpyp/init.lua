# ♻️ Refactoring Workflow

**[← Previous: Debugging Workflow](debugging.md)** | **[Next: Multi-cursor Workflow →](multicursor.md)**

---

## Overview

This configuration provides JetBrains-style refactoring capabilities through LSP and dedicated refactoring plugins. All refactorings are project-wide and maintain code correctness.

## 🚀 Essential Refactorings

| Action | Key | JetBrains Equivalent |
|--------|-----|---------------------|
| Rename Symbol | `Shift+F6` | Shift+F6 (Rename) |
| Move File | `F6` | F6 (Move) |
| Extract Method | `M` (visual) | Ctrl+Alt+M |
| Inline Variable | `<leader>ri` | Ctrl+Alt+N |

## 📝 Rename Refactoring

### Rename Symbol (Shift+F6)

The most common refactoring - works across entire project:

```javascript
// Before: Place cursor on 'oldName'
const oldName = "value";
console.log(oldName);
export { oldName };

// Press Shift+F6, type 'newName'
// After:
const newName = "value";
console.log(newName);
export { newName };
```

### Rename Features
- **Project-wide**: Updates all references
- **Preview**: See changes before applying
- **Undo-friendly**: Single undo reverts all
- **Smart**: Handles imports/exports

### Advanced Rename
```vim
" Rename with LSP
<leader>rn

" Rename file (using Oil.nvim)
F6
```

## 🔄 Extract Refactorings

### Extract Method/Function

Select code and press `M` (visual mode) or `<leader>re`:

```javascript
// Before: Select lines 2-4
function processUser(user) {
  const name = user.firstName + ' ' + user.lastName;
  const email = name.toLowerCase().replace(' ', '.') + '@example.com';
  user.email = email;
  return user;
}

// After: Extract Method
function processUser(user) {
  user.email = generateEmail(user);
  return user;
}

function generateEmail(user) {
  const name = user.firstName + ' ' + user.lastName;
  const email = name.toLowerCase().replace(' ', '.') + '@example.com';
  return email;
}
```

### Extract Variable

*Note: Extract variable keymap is not configured. Use refactoring plugin commands directly.*

```javascript
// Before: Select the expression
if (user.age > 18 && user.country === 'US') {
  // ...
}

// After: Extract Variable
const isEligible = user.age > 18 && user.country === 'US';
if (isEligible) {
  // ...
}
```

### Extract to File

*Note: Extract to file keymaps are not configured. Use refactoring plugin commands directly.*

## 📥 Inline Refactorings

### Inline Variable (<leader>ri)

Remove unnecessary variables:

```javascript
// Before: Cursor on 'temp'
const temp = calculateValue();
return temp;

// Press <leader>ri
// After:
return calculateValue();
```

### Inline Function

```javascript
// Before: Cursor on function name
function getValue() {
  return 42;
}
const result = getValue();

// Press <leader>ri
// After:
const result = 42;
```

## 🚀 Advanced Refactorings

### Change Function Signature

*Note: Change signature keymaps are not configured. This feature requires manual refactoring.*

Example:
```javascript
// Before
function greet(name) {
  return `Hello ${name}`;
}

// Change Signature: Add 'greeting' parameter
// After
function greet(greeting, name) {
  return `${greeting} ${name}`;
}
// All call sites updated automatically
```

### Convert Refactorings

*Note: Convert refactoring keymaps are not configured.*

Examples:
```javascript
// Arrow to function declaration
const fn = () => { }  →  function fn() { }

// Function to arrow
function fn() { }  →  const fn = () => { }

// Async/await to promises
async function load() {  →  function load() {
  await fetch()              return fetch().then()
}                         }
```

### Pull Up / Push Down

*Note: Pull up/push down keymaps are not configured. These require manual refactoring.*

## 🎯 Code Actions

### Quick Fixes (<leader>ca)

Context-aware refactorings:

```javascript
// Cursor on undefined variable
undefinedVar  // Press <leader>ca
// Options:
// 1. Create variable 'undefinedVar'
// 2. Import 'undefinedVar'
// 3. Change to similar name

// Cursor on unused variable
const unused = 5;  // Press <leader>ca
// Options:
// 1. Remove unused variable
// 2. Prefix with underscore
```

### Import Management

*Note: Import management keymaps are not configured. Use LSP code actions (`<leader>ca`) for import management.*

## 🔍 Safe Refactoring

### Preview Changes

Before applying refactoring:

```vim
" LSP rename includes preview by default
<leader>rn
```

Preview window shows:
```
Changes to be applied:
─────────────────────
src/index.js
  - const oldName = 
  + const newName =

src/utils.js  
  - import { oldName }
  + import { newName }
  
Apply changes? [Y/n]
```

### Refactoring with Tests

Best practice workflow:
1. Run tests: `<leader>tt`
2. Apply refactoring
3. Run tests again
4. Commit if green

## 💡 Language-Specific

### JavaScript/TypeScript

*Note: JavaScript/TypeScript specific refactoring keymaps are not configured. Use LSP code actions (`<leader>ca`) for these transformations.*

### Python

*Note: Python specific refactoring keymaps are not configured. Use LSP code actions (`<leader>ca`) for Python refactorings.*

### React/Vue Components

*Note: React/Vue specific refactoring keymaps are not configured. Use LSP code actions or manual refactoring.*

## 🛡 Undo/Redo Refactoring

### Undo Last Refactoring
```vim
" Standard undo
u

" Note: Session-based undo is not configured.
```

### Refactoring History
```vim
" View refactoring history
:RefactorHistory

" Replay refactoring
:RefactorReplay
```

## ⚙️ Configuration

### Custom Refactorings

Add to `lua/config/refactoring.lua`:

```lua
local refactoring = require("refactoring")

refactoring.setup({
  -- Custom extract configurations
  extract = {
    -- Extract to const instead of let
    prefer_const = true,
    -- Always use arrow functions
    arrow_functions = true,
  },
  
  -- Prompt for names
  prompt_func_return_type = {
    javascript = true,
    typescript = true,
  },
})
```

### Keybinding Customization

```lua
-- Add more refactoring shortcuts
vim.keymap.set("v", "<leader>rec", function()
  require("refactoring").extract_component()
end, { desc = "Extract Component" })
```

## 📚 Refactoring Patterns

### 1. Extract-Method Pattern
```
Select code → M → Name method → Enter
```

### 2. Rename-Move Pattern
```
Shift+F6 (rename) → F6 (move file) → Update imports
```

### 3. Inline-Extract Pattern
```
Inline complex (<leader>ri) → Extract simple (<leader>rv)
```

## 🚨 Troubleshooting

### Refactoring Not Available
1. Ensure LSP is running: `:LspInfo`
2. Check file is saved
3. Verify no syntax errors

### Incomplete Refactoring
1. Check all files are saved
2. Ensure project root is correct
3. Try `:LspRestart`

### Performance Issues
1. Limit search scope
2. Close unnecessary files
3. Use preview first

---

**[← Previous: Debugging Workflow](debugging.md)** | **[Next: Multi-cursor Workflow →](multicursor.md)**