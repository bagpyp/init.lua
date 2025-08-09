# 🏗 Code Structure & Symbol Navigation

**[← Previous: Services & Docker](services.md)** | **[Next: Learning Vim →](../learning-vim.md)**

---

## Overview

The Structure panel (`Space+7`) provides a bird's-eye view of your code, similar to JetBrains' Structure tool window. Navigate symbols, methods, and classes with ease.

## 🚀 Quick Start

### Open Structure Panel
Press `Space+7` to toggle the symbols outline.

### Panel Layout
```
╭─ Symbols Outline ──────────────────────╮
│ 📁 UserController.js                   │
│ ├─ 📦 imports                          │
│ │  ├─ express                          │
│ │  ├─ userService                      │
│ │  └─ validation                       │
│ ├─ 🎯 class UserController             │
│ │  ├─ 🔧 constructor()                 │
│ │  ├─ 📝 getUsers()                    │
│ │  ├─ 📝 getUserById()                 │
│ │  ├─ 📝 createUser()                  │
│ │  ├─ 📝 updateUser()                  │
│ │  ├─ 📝 deleteUser()                  │
│ │  └─ 🔒 validateInput()              │
│ └─ 📤 exports                          │
╰────────────────────────────────────────╯
```

## 🎯 Navigation

### Symbol Types

| Icon | Type | Description |
|------|------|-------------|
| 📦 | Module | Imports/exports |
| 🎯 | Class | Class definition |
| 🔧 | Constructor | Constructor method |
| 📝 | Method | Public method |
| 🔒 | Private | Private method |
| 📊 | Property | Class property |
| 🔤 | Variable | Variables |
| 🎨 | Interface | Interface/type |
| 📐 | Function | Functions |
| 🏷️ | Constant | Constants |
| 🔄 | Enum | Enumerations |

### Navigation Commands

| Key | Action | Description |
|-----|--------|-------------|
| `Enter` | Jump to symbol | Go to definition |
| `o` | Jump & close | Go and close panel |
| `p` | Preview | Preview in split |
| `/` | Search | Filter symbols |
| `Tab` | Expand/collapse | Toggle node |
| `r` | Rename | Rename symbol |
| `q` | Close | Close panel |

## 🔍 Symbol Search

### Quick Symbol Search

```vim
" Search symbols in current file
<leader>ss

" Search symbols in workspace
<leader>sS

" Fuzzy search with Telescope
<leader>fs
```

### Search Examples
```
/get     " Find all getters
/^test   " Find symbols starting with 'test'
/@       " Find decorators
/async   " Find async methods
```

## 📊 Code Analysis

### Symbol Overview

The structure panel shows:
- Class hierarchy
- Method signatures
- Property types
- Import/export structure
- TODO/FIXME markers

### Type Information

```typescript
interface User {
  id: number;        // number
  name: string;      // string
  email?: string;    // string | undefined
  roles: Role[];     // Role[]
}
```

Shows in structure as:
```
🎨 User
  ├─ id: number
  ├─ name: string
  ├─ email?: string
  └─ roles: Role[]
```

## 🏃 Quick Actions

### From Structure Panel

| Action | Key | Description |
|--------|-----|-------------|
| Rename | `r` | Rename symbol |
| Delete | `d` | Delete symbol |
| Copy | `y` | Copy symbol name |
| Move | `m` | Move to file |
| Generate | `g` | Generate code |

### Code Generation

Press `g` on a class to generate:
- Getters/setters
- Constructor
- toString method
- equals/hashCode
- Builder pattern

## 🔄 Live Updates

The structure panel updates automatically as you type:

1. Add new method → Appears in structure
2. Rename symbol → Updates everywhere
3. Delete code → Removes from structure
4. Change visibility → Updates icon

## 📁 File Structure Navigation

### Breadcrumbs

Shows current location in code:
```
UserController > methods > getUserById > try block
```

Navigate breadcrumbs:
- `[b` - Previous breadcrumb
- `]b` - Next breadcrumb
- `<leader>b` - Breadcrumb picker

### Outline Levels

Control detail level:

| Level | Shows |
|-------|-------|
| 1 | Classes only |
| 2 | + Methods |
| 3 | + Properties |
| 4 | + Variables |
| 5 | Everything |

```vim
" Set outline level
:SymbolsOutlineLevel 3
```

## 🎨 Language-Specific Features

### JavaScript/TypeScript

```javascript
// Shows in structure:
class UserService {
  // 🔒 Private fields
  #database;
  
  // 📊 Properties
  static instances = 0;
  
  // 🔧 Constructor
  constructor(db) {
    this.#database = db;
  }
  
  // 📝 Methods
  async getUser(id) { }
  
  // 🔒 Private methods
  #validateUser(user) { }
  
  // 📊 Getters/Setters
  get userCount() { }
  set maxUsers(val) { }
}
```

### Python

```python
# Shows in structure:
class UserService:
    # 🔧 __init__
    def __init__(self, db):
        self._db = db
    
    # 📝 Public methods
    def get_user(self, id):
        pass
    
    # 🔒 Private methods
    def _validate(self, user):
        pass
    
    # 📊 Properties
    @property
    def user_count(self):
        pass
    
    # 🎯 Class methods
    @classmethod
    def from_config(cls, config):
        pass
    
    # 📐 Static methods
    @staticmethod
    def hash_password(password):
        pass
```

### React Components

```jsx
// Shows component structure:
function UserProfile({ user }) {
  // 🔄 Hooks
  const [isEditing, setIsEditing] = useState(false);
  const profile = useProfile(user.id);
  
  // 📐 Handlers
  const handleEdit = () => { };
  const handleSave = () => { };
  
  // 🎯 Render
  return ( ... );
}

// Props shown as:
📊 Props
  ├─ user: User
  ├─ onSave?: Function
  └─ className?: string
```

## 🔗 Integration Features

### With LSP

- Go to definition: `gd`
- Find references: `gr`
- Hover info: `K`
- Rename: `<leader>rn`

### With Telescope

```vim
" Document symbols
<leader>ds

" Workspace symbols
<leader>ws

" Dynamic symbols
<leader>dws
```

### With Treesitter

Enhanced parsing for:
- Accurate symbol detection
- Syntax-aware folding
- Better navigation

## 📋 Symbol Categories

### Filtering Symbols

```vim
" Show only methods
:SymbolsOutlineFilter method

" Show only public
:SymbolsOutlineFilter public

" Show specific kinds
:SymbolsOutlineFilter class,method,property
```

### Custom Categories

Add custom symbol categories:
```lua
require("symbols-outline").setup({
  symbols = {
    File = { icon = "📄", hl = "@text.uri" },
    Module = { icon = "📦", hl = "@namespace" },
    Class = { icon = "🎯", hl = "@type" },
    Method = { icon = "📝", hl = "@method" },
    Property = { icon = "📊", hl = "@property" },
    Constructor = { icon = "🔧", hl = "@constructor" },
    Variable = { icon = "🔤", hl = "@variable" },
    Constant = { icon = "🏷️", hl = "@constant" },
  },
})
```

## 💡 Productivity Tips

### 1. Quick Jump Pattern
```
Space+7 → / → search → Enter
```

### 2. Split View
```
Space+7 → navigate → p (preview)
```

### 3. Refactor Flow
```
Space+7 → find symbol → r (rename) → Shift+F6
```

### 4. Code Review
```
Space+7 for overview → Check structure → Navigate issues
```

## ⚙️ Configuration

### Customize Appearance

```lua
require("symbols-outline").setup({
  -- Position and size
  position = 'right',
  width = 30,
  
  -- Auto-actions
  auto_preview = false,
  auto_close = true,
  auto_unfold_hover = true,
  
  -- Folding
  fold_markers = { '', '' },
  
  -- Icons
  show_guides = true,
  show_symbol_details = true,
})
```

### Keybinding Customization

```lua
-- Additional structure keybindings
vim.keymap.set("n", "<leader>ss", "<cmd>SymbolsOutline<cr>")
vim.keymap.set("n", "<leader>sf", "<cmd>SymbolsOutlineFilter<cr>")
vim.keymap.set("n", "<leader>sc", "<cmd>SymbolsOutlineClose<cr>")
```

## 🚨 Troubleshooting

### Symbols Not Showing
1. Ensure LSP is running: `:LspInfo`
2. Check file type is supported
3. Try `:SymbolsOutlineRefresh`

### Incorrect Symbols
1. Update language server
2. Check Treesitter parser
3. Verify file syntax

### Performance Issues
1. Limit symbol depth
2. Disable auto-preview
3. Reduce update frequency

---

**[← Previous: Services & Docker](services.md)** | **[Next: Learning Vim →](../learning-vim.md)**