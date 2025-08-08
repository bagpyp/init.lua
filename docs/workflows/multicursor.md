# 🎯 Multi-cursor Workflow

**[← Previous: Refactoring Workflow](refactoring.md)** | **[Next: Services & Docker →](services.md)**

---

## Overview

Multi-cursor editing allows you to edit multiple locations simultaneously, just like in JetBrains IDEs. This is powered by `vim-visual-multi`, providing true multiple cursor support.

## 🚀 Quick Start

### Basic Multi-cursor

| Action | Key | Description |
|--------|-----|-------------|
| Add cursor at word | `⌃G` | Add cursor at next occurrence |
| Add cursor below | `⌃↓` | Create cursor below |
| Add cursor above | `⌃↑` | Create cursor above |
| Skip occurrence | `⌃K` | Skip and find next |
| Remove cursor | `⌃X` | Remove current cursor |
| Select all occurrences | `⌃⌥G` | Create cursors at all matches |

## 🎮 Creating Multiple Cursors

### Method 1: Word-Based Selection (⌃G)

Most common - select all instances of a word:

```javascript
// Place cursor on 'user' and press ⌃G repeatedly
const user = getUser();    // ← cursor 1
if (user.isActive) {       // ← cursor 2
  updateUser(user);        // ← cursor 3
}
```

### Method 2: Column Selection

```javascript
// Visual block mode: ⌃V, then move down
const a = 1;  // ← cursor 1
const b = 2;  // ← cursor 2
const c = 3;  // ← cursor 3
```

### Method 3: Pattern Matching

```vim
" Create cursors at pattern
:VMSearch <pattern>

" Example: Add cursor at every function
:VMSearch function

" Add cursors at line starts
:VMSearch ^
```

### Method 4: Mouse Selection
```
1. Hold ⌥ (Alt)
2. Click multiple positions
3. Each click adds a cursor
```

## 📝 Editing with Multiple Cursors

### Insert Mode Operations

```javascript
// Before: Cursors at each 'const'
const| a = 1;
const| b = 2;
const| c = 3;

// Type 'let' (replaces at all cursors)
let a = 1;
let b = 2;
let c = 3;
```

### Different Text Per Cursor

```javascript
// Before: Cursors at each number
const a = |1;
const b = |2;
const c = |3;

// Press ⌃N to enter cursor mode
// Type different values:
const a = 10;
const b = 20;
const c = 30;
```

## 🔄 Selection Expansion

### Expand Selection (⌥↑)

Progressive expansion:
```javascript
// Cursor on 'name'
user.name
     ↓ (⌥↑)
user.name       // Select word
     ↓ (⌥↑)
user.name       // Select with dot
     ↓ (⌥↑)
(user.name)     // Select with parens
     ↓ (⌥↑)
if (user.name)  // Select statement
```

### Shrink Selection (⌥↓)

Reverse of expansion - progressively shrink selection.

## 🎯 Advanced Multi-cursor

### Cursor Navigation

While in multi-cursor mode:

| Key | Action |
|-----|--------|
| `Tab` | Switch between cursors |
| `⇧Tab` | Switch backwards |
| `n/N` | Next/previous in extend mode |
| `q` | Remove current cursor |
| `Q` | Remove all cursors |

### Cursor Alignment

```vim
" Align cursors
:VMAlign

" Example: Before
const a = 1;
const longName = 2;
const b = 3;

" After :VMAlign
const a        = 1;
const longName = 2;
const b        = 3;
```

### Cursor Numbering

```vim
" Insert incrementing numbers
:VMNumbers

" Before: Cursors at each line
item_|
item_|
item_|

" After :VMNumbers
item_1
item_2
item_3
```

## 💡 Practical Examples

### 1. Rename Variables
```javascript
// Select 'oldVar' with ⌃G repeatedly
let oldVar = 1;        // cursor
function use(oldVar) { // cursor
  return oldVar * 2;   // cursor
}

// Type 'newVar' - changes all
```

### 2. Add Prefixes/Suffixes
```css
/* Select all 'width' with ⌃⌥G */
width: 100px;    /* cursor */
width: 200px;    /* cursor */
width: 300px;    /* cursor */

/* Press Home, type 'max-' */
max-width: 100px;
max-width: 200px;
max-width: 300px;
```

### 3. Convert List Format
```javascript
// Visual select all lines, ⌃V
apple
banana
cherry

// I" (insert at start), End', (end + comma)
"apple",
"banana",
"cherry",
```

### 4. Extract to Array
```javascript
// Cursors at each string
console.log("error 1");
console.log("error 2");
console.log("error 3");

// Select strings, cut, create array
const messages = [
  "error 1",
  "error 2",
  "error 3"
];
```

## 🔧 Multi-cursor Modes

### 1. Cursor Mode
- Normal multi-cursor editing
- Each cursor acts independently

### 2. Visual Mode
- Select text at each cursor
- `v` for character-wise
- `V` for line-wise

### 3. Extend Mode
- Keep finding matches
- `n` for next match
- `N` for previous match

## ⚙️ Configuration

### Custom Mappings

Add to your config:
```lua
vim.g.VM_maps = {
  ["Find Under"] = "<C-g>",
  ["Find Subword Under"] = "<C-g>",
  ["Select All"] = "<C-a>",
  ["Add Cursor Down"] = "<C-j>",
  ["Add Cursor Up"] = "<C-k>",
  ["Mouse Cursor"] = "<C-LeftMouse>",
  ["Mouse Column"] = "<C-RightMouse>",
}
```

### Visual Feedback

```lua
vim.g.VM_theme = 'iceblue'
vim.g.VM_highlight_matches = 'underline'
vim.g.VM_show_warnings = 1
```

## 🎨 Visual Multi-cursor

### Box/Column Selection

```
Name    Age    City
John    25     NYC     ← Start ⌃V here
Jane    30     LA      ← Drag down
Bob     35     CHI     ← To here

// Now edit all at once
```

### Line-wise Operations

```vim
" Select multiple lines with V
" Press ⌃N to create cursor at each line
" Edit all lines simultaneously
```

## 🚀 Productivity Tips

### 1. Quick Rename
```
Word → ⌃G (repeat) → c → type new name
```

### 2. Quick Surround
```
Select → ⌃G → S" → Surrounded with quotes
```

### 3. Quick Delete
```
Pattern → ⌃G → d → All deleted
```

### 4. Quick Comment
```
Lines → ⌃V → gc → All commented
```

## 🔄 Integration with Other Features

### With Refactoring
1. Use multi-cursor to select
2. Apply refactoring to all

### With Snippets
1. Create multiple cursors
2. Trigger snippet at each

### With LSP
1. Multi-cursor for quick fixes
2. Apply code action to all

## ⚠️ Limitations

### When to Use Single Cursor
- Complex refactoring (use ⇧F6)
- Different changes per location
- When LSP rename is better

### Performance
- Large files: Limit cursor count
- Complex operations: Use macros instead
- Many cursors: Can slow down

## 🚨 Troubleshooting

### Cursors Not Creating
1. Check if in correct mode
2. Verify keybinding conflicts
3. Try `:VMClear` to reset

### Unexpected Behavior
1. Exit with `Esc` twice
2. Clear with `:VMClear`
3. Check `:VMDebug`

### Conflicts
1. Disable conflicting plugins
2. Check `:map <C-g>`
3. Adjust VM_maps configuration

---

**[← Previous: Refactoring Workflow](refactoring.md)** | **[Next: Services & Docker →](services.md)**