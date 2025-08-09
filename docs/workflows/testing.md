# 🧪 Testing Workflow with Neotest

**[← Previous: Keymap Cheatsheet](../keymap-cheatsheet.md)** | **[Next: Debugging Workflow →](debugging.md)**

---

## Overview

Neotest provides a unified interface for running tests across multiple languages, similar to JetBrains' test runner. It automatically detects test frameworks and provides visual feedback.

## 🚀 Quick Start

### Running Tests

| Action | Keybinding | Description |
|--------|------------|-------------|
| Run nearest test | `<leader>tt` | Runs the test under cursor |
| Run file | `<leader>tf` | Runs all tests in current file |
| Show output | `<leader>to` | Display test output |
| Toggle summary | `<leader>ts` | Show/hide test summary panel |

### Test Navigation

*Note: Test navigation keybindings are currently not configured. You can navigate tests using the test summary panel.*

## 📊 Test Summary Panel

The test summary panel shows all tests in your project:

```
Tests Summary
├── src/
│   ├── utils.test.js
│   │   ├── ✓ should format date
│   │   ├── ✗ should handle null
│   │   └── ⊙ should validate input
│   └── api.test.js
│       ├── ✓ GET /users
│       └── ✓ POST /users
```

### Summary Panel Controls
- `Enter` - Jump to test
- `r` - Run test
- `d` - Debug test
- `o` - Show output
- `m` - Mark test
- `R` - Run marked tests
- `e` - Expand all
- `E` - Collapse all

## 🔧 Supported Test Frameworks

### JavaScript/TypeScript
- **Jest** - Automatically detected via `package.json`
- **Mocha** - Requires mocha in dependencies
- **Vitest** - Modern test runner support

### Python
- **Pytest** - Default Python test runner
- **Unittest** - Standard library testing

### Other Languages
- **Go** - go test
- **Rust** - cargo test
- **Ruby** - RSpec

## 📝 Test Configuration

### Project-Level Configuration

Create `.neotest.json` in your project root:

```json
{
  "adapters": {
    "jest": {
      "jestCommand": "npm test --",
      "jestConfigFile": "jest.config.js",
      "env": {
        "CI": true
      }
    },
    "pytest": {
      "runner": "pytest",
      "args": ["-vv", "--tb=short"]
    }
  }
}
```

### Running Specific Test Suites

```vim
" Run tests matching pattern
:Neotest run file pattern="user"

" Run tests with specific tag
:Neotest run tag="integration"

" Run only marked tests
:Neotest run marked
```

## 🎯 Test-Driven Development (TDD) Workflow

### 1. Watch Mode
Enable automatic test running on file save:

```vim
:Neotest watch
```

Or for current file only:
```vim
<leader>tw  " Toggle watch mode
```

### 2. TDD Cycle
1. Write failing test (`<leader>tt`)
2. See red indicator in gutter
3. Implement feature
4. Run test again (`<leader>tt`)
5. See green indicator
6. Refactor with confidence

### 3. Visual Indicators

| Symbol | Meaning |
|--------|---------|
| `✓` | Test passed |
| `✗` | Test failed |
| `⊙` | Test running |
| `○` | Test skipped |
| `⚠` | Test error |

## 🔍 Test Output and Diagnostics

### Viewing Test Output

```vim
" Full output for nearest test
<leader>to

" Output with panel enter
<leader>tO

" Floating window output
<leader>tF
```

### Output Panel Features
- Syntax highlighting
- Error locations are clickable
- Stack traces are foldable
- Search within output (`/`)

## 🏃 Run Configurations

### Custom Test Commands

Add to your `lua/config/run.lua`:

```lua
M.configs = {
  {
    name = "Test: Unit",
    cmd = "npm run test:unit",
    type = "terminal",
  },
  {
    name = "Test: Integration",
    cmd = "npm run test:integration",
    type = "terminal",
  },
  {
    name = "Test: E2E",
    cmd = "npm run test:e2e",
    type = "terminal",
  },
  {
    name = "Test: Coverage",
    cmd = "npm run test:coverage",
    type = "terminal",
  },
}
```

Access with `<leader>3` to switch between test configurations.

## 🐛 Debugging Tests

### Debug Single Test
1. Place cursor on test
2. Press `<leader>td` or use `F9` to set breakpoint
3. Test runs in debug mode
4. Debug UI opens automatically (`<leader>4`)

### Debug Configuration

```lua
-- In your test file
-- @debug
test("should handle edge case", () => {
  // This test will always run in debug mode
})
```

## 📈 Coverage Integration

### View Coverage
```vim
" Show coverage report
:Coverage

" Toggle coverage signs
:CoverageToggle

" Load coverage file
:CoverageLoad coverage/lcov.info
```

### Coverage Indicators
- Green lines: Covered
- Red lines: Not covered
- Yellow lines: Partially covered

## 💡 Tips and Tricks

### 1. Test Organization
```
project/
├── src/
│   ├── components/
│   │   ├── Button.jsx
│   │   └── Button.test.jsx    # Colocated tests
│   └── utils/
│       ├── format.js
│       └── __tests__/          # Test folder
│           └── format.test.js
```

### 2. Quick Test Creation
```vim
" Create test file for current file
:TestCreate

" Generate test scaffold
:TestGenerate
```

### 3. Test Snippets
Type these in insert mode:
- `test` → Test block
- `desc` → Describe block
- `it` → It block
- `exp` → Expect assertion

### 4. Running Tests from Terminal
```bash
# Run all tests
nvim +":Neotest run"

# Run specific file
nvim +"Neotest run file src/utils.test.js"
```

## 🔌 Integration with CI/CD

### GitHub Actions Example
```yaml
- name: Run Tests in Neovim
  run: |
    nvim --headless +":Neotest run" +":q"
```

### Pre-commit Hook
```bash
#!/bin/sh
nvim --headless +":Neotest run" +":qa!" || exit 1
```

## 🚨 Troubleshooting

### Tests Not Detected
1. Check adapter is installed: `:Neotest info`
2. Verify test pattern matches
3. Ensure test framework is in dependencies

### Slow Test Discovery
1. Limit test directories in config
2. Use `.gitignore` patterns
3. Disable watch mode for large projects

### Output Not Showing
1. Check output panel: `<leader>to`
2. Verify terminal settings
3. Try different output strategy

---

**[← Previous: Keymap Cheatsheet](../keymap-cheatsheet.md)** | **[Next: Debugging Workflow →](debugging.md)**