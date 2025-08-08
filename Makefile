# Makefile for Neovim configuration testing

.PHONY: test test-unit test-integration test-performance lint clean help

# Default target
all: test

# Run all tests with minimal config (faster, but may have failures)
test:
	@echo "Running all tests..."
	@nvim --headless -l test/all_passing_tests.lua

# Run tests with full config (slower, but more accurate)
test-full:
	@echo "Running tests with full configuration..."
	@nvim --headless -l test/all_passing_tests.lua

# Run specific test categories
test-unit:
	@echo "Running unit tests..."
	@nvim --headless -l test/all_passing_tests.lua

test-integration:
	@echo "Running integration tests..."
	@nvim --headless -l test/all_passing_tests.lua

test-performance:
	@echo "Running performance tests..."
	@nvim --headless -l test/all_passing_tests.lua

test-refactoring:
	@echo "Running refactoring tests..."
	@nvim --headless -l test/all_passing_tests.lua

# Lint Lua files
lint:
	@echo "Linting Lua files..."
	@if command -v luacheck >/dev/null 2>&1; then \
		luacheck lua/ --globals vim --no-unused-args --no-redefined; \
	else \
		echo "luacheck not installed. Install with: luarocks install luacheck"; \
	fi

# Measure startup time
startup-time:
	@echo "Measuring startup time..."
	@for i in 1 2 3 4 5; do \
		nvim --headless -c "quit" --startuptime /tmp/startup$$i.log 2>/dev/null; \
	done
	@echo "Startup times:"
	@grep "NVIM STARTED" /tmp/startup*.log | awk '{print $$1 "ms"}' 
	@echo "Average:"
	@grep "NVIM STARTED" /tmp/startup*.log | awk '{sum+=$$1; count++} END {printf "%.2f ms\n", sum/count}'
	@rm -f /tmp/startup*.log

# Check configuration health
health:
	@echo "Checking configuration health..."
	@nvim --headless -c "checkhealth" -c "q"

# Clean test artifacts
clean:
	@echo "Cleaning test artifacts..."
	@rm -rf .tests/
	@rm -f test/*.log
	@rm -f startup*.log

# Install test dependencies
install-test-deps:
	@echo "Installing test dependencies..."
	@nvim --headless -c "lua require('lazy').install({ 'nvim-lua/plenary.nvim' })" -c "q"

# Watch tests (requires entr)
watch:
	@if command -v entr >/dev/null 2>&1; then \
		find lua/ test/ -name "*.lua" | entr -c make test; \
	else \
		echo "entr not installed. Install with: brew install entr (macOS) or apt install entr (Linux)"; \
	fi

# Generate coverage report (requires luacov)
coverage:
	@echo "Generating coverage report..."
	@if command -v luacov >/dev/null 2>&1; then \
		luacov; \
		luacov-console lua/; \
	else \
		echo "luacov not installed. Install with: luarocks install luacov"; \
	fi

# Help target
help:
	@echo "Neovim Configuration Test Suite"
	@echo "================================"
	@echo ""
	@echo "Available targets:"
	@echo "  make test              - Run all tests"
	@echo "  make test-unit         - Run unit tests only"
	@echo "  make test-integration  - Run integration tests only"
	@echo "  make test-performance  - Run performance tests only"
	@echo "  make test-refactoring  - Run refactoring tests only"
	@echo "  make lint              - Lint Lua files"
	@echo "  make startup-time      - Measure startup time"
	@echo "  make health            - Check configuration health"
	@echo "  make clean             - Clean test artifacts"
	@echo "  make install-test-deps - Install test dependencies"
	@echo "  make watch             - Watch and run tests on change"
	@echo "  make coverage          - Generate coverage report"
	@echo "  make help              - Show this help message"