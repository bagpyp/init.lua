# 🧪 Testing Guide for Neovim Configuration

## Overview

This configuration includes a comprehensive test suite to ensure reliability and performance. Tests are written using Plenary's testing framework and can be run locally or in CI/CD.

## Quick Start

### Running All Tests

```bash
# Using Make (recommended)
make test

# Using the test runner directly
./tests/run_tests.sh

# From within Neovim
:PlenaryBustedDirectory tests/
```

### Running Specific Test Categories

```bash
# Unit tests only
make test-unit

# Integration tests
make test-integration

# Performance benchmarks
make test-performance

# Refactoring tests
make test-refactoring
```

### Running Individual Test Files

```bash
# Run a specific test file
./tests/run_tests.sh tests/keymaps_spec.lua

# Or with Plenary in Neovim
:PlenaryBustedFile tests/keymaps_spec.lua
```

## Test Structure

```
tests/
├── init_spec.lua           # Basic configuration tests
├── keymaps_spec.lua        # Keymap verification
├── plugins_spec.lua        # Plugin loading tests
├── custom_modules_spec.lua # Custom module tests (run.lua, docker.lua)
├── integration_spec.lua    # Workflow integration tests
├── refactoring_spec.lua    # Refactoring feature tests
├── performance_spec.lua    # Performance benchmarks
├── helpers.lua             # Test utility functions
├── minimal_init.lua        # Minimal test environment
└── run_tests.sh           # Test runner script
```

## Available Make Commands

```bash
# Show all available commands
make help

# Core testing commands
make test                  # Run all tests
make test-unit            # Run unit tests only
make test-integration     # Run integration tests
make test-performance     # Run performance tests
make lint                 # Lint Lua files
make startup-time         # Measure startup time
make health              # Check configuration health
make clean               # Clean test artifacts

# Development commands
make watch               # Auto-run tests on file changes (requires entr)
make coverage           # Generate test coverage report (requires luacov)
```

## Performance Benchmarks

### Measure Startup Time

```bash
# Quick measurement
make startup-time

# Expected output:
# Startup times:
# 67.45ms
# 68.12ms
# 66.89ms
# Average: 67.49 ms
```

### Performance Thresholds

- **Startup time**: Must be < 200ms
- **Search operations**: < 10ms average
- **Substitutions**: < 50ms average
- **Memory leaks**: < 10% increase after operations

## Test Examples

### Writing New Tests

```lua
-- tests/my_feature_spec.lua
local helpers = require("tests.helpers")

describe("My Feature", function()
  it("should do something", function()
    -- Arrange
    local buffer = helpers.create_test_buffer("test content")
    
    -- Act
    vim.cmd("MyCommand")
    
    -- Assert
    local content = helpers.get_buffer_content(buffer)
    assert.are.equal("expected content", content[1])
  end)
end)
```

### Using Test Helpers

```lua
-- Check if plugin is loaded
assert.is_true(helpers.plugin_loaded("telescope"))

-- Check if keymap exists
assert.is_true(helpers.keymap_exists("n", "<leader>ff"))

-- Check if command exists
assert.is_true(helpers.command_exists("Telescope"))

-- Create test buffer with content
local buf = helpers.create_test_buffer({
  "line 1",
  "line 2",
  "line 3"
})

-- Mock a function
local mock = helpers.mock_function("return value")
some_function(mock)
assert.are.equal(1, mock.call_count())

-- Test with temporary file
helpers.with_temp_file("content", function(file)
  vim.cmd("edit " .. file)
  -- test with file
end)

-- Benchmark operations
local time = helpers.benchmark(function()
  vim.cmd("normal gg")
end, 100) -- Run 100 times
print(string.format("Average time: %.2fms", time))
```

## CI/CD Integration

### GitHub Actions

The configuration includes a GitHub Actions workflow that:

1. **Tests on multiple platforms**: Ubuntu and macOS
2. **Tests on multiple Neovim versions**: Stable and nightly
3. **Runs linting checks**: Using luacheck
4. **Measures performance**: Fails if startup > 200ms

### Running CI Locally

```bash
# Simulate CI environment
docker run -it -v $(pwd):/workspace ubuntu:latest
apt update && apt install -y neovim git make
cd /workspace
make test
```

## Debugging Failed Tests

### View Test Output

```bash
# Run with verbose output
nvim --headless +":PlenaryBustedFile tests/init_spec.lua" -c "q"

# Check Neovim logs
tail -f ~/.local/state/nvim/log
```

### Common Issues and Solutions

#### Tests Not Finding Modules

**Problem**: `module 'config.run' not found`

**Solution**: Ensure you're running tests from the config root:
```bash
cd ~/.config/nvim
make test
```

#### Plugin Not Loaded

**Problem**: Tests fail because plugins aren't loaded

**Solution**: Install plugins first:
```bash
nvim --headless -c "Lazy install" -c "q"
```

#### Permission Errors

**Problem**: Tests fail with permission errors

**Solution**: Some tests create temp files, ensure write permissions:
```bash
chmod +x tests/run_tests.sh
```

## Test Coverage

### Generate Coverage Report

```bash
# Install luacov
luarocks install luacov

# Run tests with coverage
make coverage

# View report
cat luacov.report.out
```

### Current Coverage Areas

- ✅ **Configuration**: Options, keymaps, autocmds
- ✅ **Plugins**: Loading, lazy loading, configuration
- ✅ **Custom Modules**: run.lua, docker.lua
- ✅ **Performance**: Startup time, memory usage
- ✅ **Integration**: Workflows, file operations
- ⚠️ **LSP**: Partial (requires language servers)
- ⚠️ **DAP**: Partial (requires debug adapters)

## Best Practices

### 1. Run Tests Before Commits

```bash
# Add to git pre-commit hook
echo "make test" >> .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### 2. Test After Major Changes

```bash
# After updating plugins
nvim -c "Lazy update" -c "q"
make test

# After changing configuration
make test-unit
```

### 3. Monitor Performance

```bash
# Regular performance checks
make startup-time
make test-performance
```

## Troubleshooting

### Test Runner Not Working

```bash
# Make executable
chmod +x tests/run_tests.sh

# Install Plenary
nvim --headless -c "Lazy install nvim-lua/plenary.nvim" -c "q"
```

### Tests Hanging

```bash
# Run with timeout
timeout 30 ./tests/run_tests.sh

# Or kill hanging Neovim processes
pkill -f nvim
```

### Inconsistent Results

```bash
# Clean test artifacts
make clean

# Reset Neovim state
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

## Adding New Tests

### 1. Create Test File

```bash
touch tests/new_feature_spec.lua
```

### 2. Write Tests

```lua
describe("New Feature", function()
  it("should work", function()
    -- Your test here
  end)
end)
```

### 3. Run Your Test

```bash
./tests/run_tests.sh tests/new_feature_spec.lua
```

### 4. Add to Makefile

```makefile
test-new-feature:
	@./tests/run_tests.sh tests/new_feature_spec.lua
```

## Continuous Improvement

The test suite is continuously improved. To contribute:

1. **Report issues**: Note any test failures
2. **Add tests**: Cover new features
3. **Improve performance**: Optimize slow tests
4. **Document**: Update this guide

---

Remember: **A tested configuration is a reliable configuration!** 🚀