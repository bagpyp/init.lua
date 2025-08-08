# ♻️ Refactoring Workflow

**[← Previous: Debugging Workflow](debugging.md)** | **[Next: Multi-cursor Workflow →](multicursor.md)**

---

## Overview

This configuration provides JetBrains-style refactoring capabilities through LSP and dedicated refactoring plugins. All refactorings are project-wide and maintain code correctness.

## 🚀 Essential Refactorings

| Action | Key | JetBrains Equivalent |
|--------|-----|---------------------|
| Rename Symbol | `⇧F6` | Shift+F6 (Rename) |
| Move File | `F6` | F6 (Move) |
| Extract Method | `M` (visual) | Ctrl+Alt+M |
| Extract Variable | `<leader>rv` | Ctrl+Alt+V |
| Inline Variable | `⌘⌥N` | Ctrl+Alt+N |
| Extract Function | `<leader>re` | Extract Method |

## 📝 Rename Refactoring

### Rename Symbol (⇧F6)

The most common refactoring - works across entire project:

```javascript
// Before: Place cursor on 'oldName'
const oldName = "value";
console.log(oldName);
export { oldName };

// Press ⇧F6, type 'newName'
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
" Rename with preview
<leader>rn

" Force rename (skip confirmation)
<leader>rN

" Rename file and update imports
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

Select expression and press `<leader>rv`:

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

For larger extractions:

```vim
" Extract function to new file
<leader>rf

" Extract component to file (React/Vue)
<leader>rc
```

## 📥 Inline Refactorings

### Inline Variable (⌘⌥N)

Remove unnecessary variables:

```javascript
// Before: Cursor on 'temp'
const temp = calculateValue();
return temp;

// Press ⌘⌥N
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

```vim
" Change signature
<leader>rs

" Interactive mode:
" 1. Add parameter
" 2. Remove parameter
" 3. Reorder parameters
" 4. Change parameter names
```

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

```vim
" Convert function declaration
<leader>rcf
```

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

For class hierarchies:

```vim
" Pull member up to parent class
<leader>rpu

" Push member down to subclasses  
<leader>rpd
```

## 🎯 Code Actions

### Quick Fixes (⌘.)

Context-aware refactorings:

```javascript
// Cursor on undefined variable
undefinedVar  // Press ⌘.
// Options:
// 1. Create variable 'undefinedVar'
// 2. Import 'undefinedVar'
// 3. Change to similar name

// Cursor on unused variable
const unused = 5;  // Press ⌘.
// Options:
// 1. Remove unused variable
// 2. Prefix with underscore
```

### Import Management

```vim
" Organize imports
<leader>ro

" Add missing imports
<leader>ra

" Remove unused imports
<leader>ru
```

## 🔍 Safe Refactoring

### Preview Changes

Before applying refactoring:

```vim
" Preview rename
:RenamePreview

" Preview with Telescope
<leader>rp
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

```vim
" Convert to template literal
<leader>rtl

" Convert to optional chaining
<leader>roc

" Destructure object
<leader>rdo
```

### Python

```vim
" Extract to method
<leader>rem

" Convert to f-string
<leader>rfs

" Add type hints
<leader>rth
```

### React/Vue Components

```vim
" Extract component
<leader>rxc

" Convert to functional component
<leader>rxf

" Extract hook
<leader>rxh
```

## 🛡 Undo/Redo Refactoring

### Undo Last Refactoring
```vim
" Standard undo
u

" Undo entire refactoring session
<leader>rU
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
⇧F6 (rename) → F6 (move file) → Update imports
```

### 3. Inline-Extract Pattern
```
Inline complex (⌘⌥N) → Extract simple (<leader>rv)
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