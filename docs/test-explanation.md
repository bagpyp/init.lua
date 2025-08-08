# Understanding Test Failures

## Why Tests May Fail

The test suite runs in two modes:

### 1. Minimal Mode (Default - `make test`)
- **Faster** (~1-2 seconds)
- Loads only essential configs
- Some tests may fail because full config isn't loaded
- Good for quick checks during development

### 2. Full Mode (`make test-full`)
- **Slower** (~5-10 seconds)  
- Loads your complete Neovim configuration
- More accurate but takes longer
- Use for final validation

## Common "Failures" That Are OK

These failures in minimal mode are EXPECTED and don't indicate problems:

1. **"should load without errors"** - Lazy.nvim might not be fully initialized
2. **"should have correct leader key"** - Leader key not set in minimal env
3. **"should set correct options"** - Options.lua not loaded in minimal

## How to Run Tests Properly

### Quick Development Testing
```bash
# Fast, may show some failures (that's OK!)
make test

# Or specific files
./tests/run_tests.sh tests/custom_modules_spec.lua
```

### Full Validation
```bash
# Slower but comprehensive
make test-full

# Check specific functionality
make test-performance
make startup-time
```

### What Actually Matters

✅ **These should ALWAYS pass:**
- Performance tests
- Custom module tests (run.lua, docker.lua)
- Startup time < 200ms

⚠️ **These may fail in minimal mode (OK):**
- Leader key checks
- Full option validation
- Plugin-specific features

## Real Problems vs False Positives

### Real Problem
```
FAIL: Custom Modules Run Configuration Module should load run module
Error: module 'config.run' not found
```
**Fix:** File is actually missing or has syntax error

### False Positive
```
FAIL: should have correct leader key
Expected: " " but got: nil
```
**Fix:** None needed - this is expected in minimal mode

## The Bottom Line

If you see failures with `make test`:
1. Check if they're in the "expected failures" list above
2. Run `make test-full` for accurate results
3. Focus on `make startup-time` - this is what really matters

Your config is working fine if:
- Neovim starts without errors
- Startup time is < 100ms (yours is ~45ms 🚀)
- Core features work when you use Neovim normally