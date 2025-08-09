# 🎓 Learning Vim: From JetBrains to Neovim

**[← Previous: Code Structure](workflows/structure.md)** | **[Home →](../README.md)**

---

## Overview

This guide helps JetBrains users transition to Vim's modal editing paradigm while maintaining familiar IDE features. You already know the JetBrains shortcuts - now let's add Vim superpowers.

## 🎯 The Vim Philosophy

### Modal Editing

Unlike JetBrains IDEs where you're always in "insert mode", Vim has distinct modes:

| Mode | Purpose | Enter with | Exit with |
|------|---------|------------|-----------|
| **Normal** | Navigate & commands | `Esc` | Various |
| **Insert** | Type text | `i`, `a`, `o` | `Esc` |
| **Visual** | Select text | `v`, `V`, `⌃V` | `Esc` |
| **Command** | Run commands | `:` | `Esc` or `Enter` |

Think of it like this:
- **Normal mode** = JetBrains with no text selected
- **Insert mode** = JetBrains when typing
- **Visual mode** = JetBrains with text selected
- **Command mode** = JetBrains command palette

## 🚀 Essential Movements

### Basic Navigation

| Vim | JetBrains | Description |
|-----|-----------|-------------|
| `h/j/k/l` | Arrow keys | Left/Down/Up/Right |
| `w` | `⌃→` | Next word |
| `b` | `⌃←` | Previous word |
| `0` | `Home` | Start of line |
| `$` | `End` | End of line |
| `gg` | `⌃Home` | Start of file |
| `G` | `⌃End` | End of file |
| `{/}` | `⌃↑/↓` | Previous/next paragraph |
| `%` | `⌃⇧M` | Matching bracket |

### Advanced Navigation

```vim
10j     " Move down 10 lines (like clicking line 10)
5w      " Move forward 5 words
f;      " Jump to next semicolon in line
t)      " Jump to just before next )
/search " Search forward (like ⌃F)
?search " Search backward
*       " Search word under cursor (like ⌃⇧F7)
```

## ✏️ The Vim Language

Vim commands follow a grammar: `[count][operator][motion/text-object]`

### Operators (Verbs)

| Operator | Meaning | Example |
|----------|---------|---------|
| `d` | Delete | `dw` = delete word |
| `c` | Change | `cw` = change word |
| `y` | Yank (copy) | `yw` = copy word |
| `v` | Visual select | `vw` = select word |
| `>` | Indent | `>}` = indent paragraph |
| `<` | Outdent | `<}` = outdent paragraph |
| `=` | Format | `=}` = format paragraph |

### Motions (Where)

| Motion | Meaning | Example with `d` |
|--------|---------|------------------|
| `w` | Word | `dw` = delete word |
| `$` | End of line | `d$` = delete to end |
| `}` | Paragraph | `d}` = delete paragraph |
| `G` | End of file | `dG` = delete to end of file |
| `t,` | Till comma | `dt,` = delete till comma |
| `f)` | Find paren | `df)` = delete to ) inclusive |

### Text Objects (What)

| Object | Meaning | Example |
|--------|---------|---------|
| `iw` | Inner word | `diw` = delete word |
| `aw` | A word (with space) | `daw` = delete word + space |
| `i"` | Inner quotes | `ci"` = change in quotes |
| `a"` | Around quotes | `da"` = delete with quotes |
| `ip` | Inner paragraph | `vip` = select paragraph |
| `it` | Inner tag | `cit` = change in HTML tag |

## 🎮 Practical Examples

### Common JetBrains → Vim Translations

| Task | JetBrains | Vim | 
|------|-----------|-----|
| Select word | Double-click | `viw` |
| Select line | Triple-click | `V` |
| Delete line | `⌘X` | `dd` |
| Duplicate line | `⌘D` | `yyp` |
| Comment line | `⌘/` | `gcc` |
| Select all | `⌘A` | `ggVG` |
| Find & replace | `⌘R` | `:%s/old/new/g` |
| Go to line | `⌘L` | `:42` or `42G` |

### Real-World Scenarios

#### 1. Change Function Parameter
```javascript
// Change 'oldParam' to 'newParam'
function doSomething(oldParam, other) {
```
- JetBrains: Double-click `oldParam`, type `newParam`
- Vim: Cursor on `oldParam`, `ciw` (change inner word), type `newParam`

#### 2. Delete Everything in Parentheses
```javascript
console.log("delete this text");
```
- JetBrains: Click after `(`, Shift+click before `)`, Delete
- Vim: Cursor anywhere in parens, `di(` (delete in parentheses)

#### 3. Change HTML Attribute
```html
<div class="old-class" id="test">
```
- JetBrains: Double-click value, type new
- Vim: Cursor in quotes, `ci"` (change in quotes), type new

## 🔥 Power User Tips

### Combining with JetBrains Features

Your JetBrains muscle memory still works:
- `Space+ff` - Find files (JetBrains-style!)
- `Shift+F6` - Rename (enhanced with Vim selection)
- `Space+1-8` - Panels (JetBrains-style)
- `F5-F11` - Debugging (unchanged)

### Vim Superpowers

#### 1. Dot Command (Repeat)
```javascript
// Task: Add 'async' to multiple functions
function one() { }    // Type: I async <Esc>
function two() { }    // Type: j.
function three() { }  // Type: j.
```

#### 2. Macros (Record & Replay)
```javascript
// Task: Convert all vars to const
var a = 1;  // qa (start recording)
var b = 2;  // ciw const <Esc> j (change var to const, move down)
var c = 3;  // q (stop recording)
            // @a (replay on next line)
            // 5@a (replay 5 times)
```

#### 3. Visual Block Mode
```javascript
// Add 'export' to multiple lines
⌃V (visual block) → select lines → I → type 'export ' → Esc

const a = 1;     →  export const a = 1;
const b = 2;     →  export const b = 2;
const c = 3;     →  export const c = 3;
```

## 📈 Learning Path

### Week 1: Basics
- [ ] Use `hjkl` for navigation (disable arrows temporarily)
- [ ] Learn `i`, `a`, `o` for insert mode
- [ ] Master `w`, `b`, `0`, `$` movements
- [ ] Practice `dd`, `yy`, `p` (delete/copy/paste line)

### Week 2: Text Objects
- [ ] Learn `iw/aw` (word objects)
- [ ] Practice `i"/a"` (quote objects)
- [ ] Master `i(/a(` (parentheses objects)
- [ ] Use `ci`, `di`, `yi` with objects

### Week 3: Efficiency
- [ ] Use counts: `5j`, `3dw`, `2yy`
- [ ] Learn `f/F/t/T` for line jumps
- [ ] Master `.` (repeat command)
- [ ] Start recording simple macros

### Week 4: Advanced
- [ ] Visual block mode (`⌃V`)
- [ ] Search and replace patterns
- [ ] Marks and jumps
- [ ] Custom mappings

## 🎯 Practice Exercises

### Exercise 1: Navigation
```javascript
// Navigate without arrow keys or mouse
const user = {
  name: "John",      // Go to "John": f"
  age: 30,          // Go to 30: f3
  email: "j@ex.com" // Go to email: /email
};
```

### Exercise 2: Editing
```javascript
// Change all 'let' to 'const'
let a = 1;  // ciw const
let b = 2;  // j.
let c = 3;  // j.
```

### Exercise 3: Text Objects
```html
<!-- Practice changing/deleting inside tags/attributes -->
<div class="container" id="main">
  <p>Change this text</p>  <!-- cit -->
  <span class="old">Text</span>  <!-- ci" on class value -->
</div>
```

## 💡 Mental Models

### Think in Objects
- Don't think: "Delete 5 characters"
- Think: "Delete word" (`dw`)

### Think in Motions
- Don't think: "Move cursor 10 times"
- Think: "Go to next function" (`]m`)

### Think in Combinations
- Task: "Change everything until semicolon"
- Solution: `ct;` (change till semicolon)

## 🚀 Productivity Boosters

### Custom Mappings
Add these to your config for JetBrains-like behavior:
```lua
-- Select all
vim.keymap.set("n", "<C-a>", "ggVG")

-- Save with Ctrl+S
vim.keymap.set("n", "<C-s>", ":w<CR>")

-- Duplicate line
vim.keymap.set("n", "<C-d>", "yyp")
```

### Useful Plugins for Beginners
- **vim-hardtime**: Breaks bad habits
- **vim-be-good**: Practice games
- **vim-tutor**: Interactive tutorial

## 🎮 Interactive Learning

### Built-in Tutorial
```vim
:Tutor
```

### Practice in Browser
- [Vim Adventures](https://vim-adventures.com) - Game-based learning
- [VimGolf](https://vimgolf.com) - Challenges
- [OpenVim](https://openvim.com) - Interactive tutorial

## 🏆 Mastery Checklist

### Beginner
- [ ] Navigate without arrow keys
- [ ] Use basic operators (d, c, y)
- [ ] Understand modes
- [ ] Use simple text objects

### Intermediate  
- [ ] Use counts efficiently
- [ ] Master text objects
- [ ] Record and use macros
- [ ] Use marks for navigation

### Advanced
- [ ] Create custom mappings
- [ ] Use registers effectively
- [ ] Master visual block mode
- [ ] Integrate Vim with workflow

## 🔑 Remember

1. **Normal mode is home** - Stay in normal mode by default
2. **Think in text objects** - Words, sentences, paragraphs
3. **Compose commands** - Operator + Motion = Action
4. **Don't memorize, practice** - Muscle memory > memorization
5. **Keep JetBrains features** - They still work!

## 🆘 When Stuck

- Press `Esc` to return to normal mode
- Press `u` to undo
- Press `:q!` to quit without saving
- Use mouse/arrows while learning (it's okay!)
- Your JetBrains shortcuts still work

---

**[← Previous: Code Structure](workflows/structure.md)** | **[Home →](../README.md)**

*Happy Vimming! Remember: The goal isn't to abandon JetBrains patterns, but to enhance them with Vim's power.* 🚀