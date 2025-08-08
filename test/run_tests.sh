#!/bin/bash

# Script to run Neovim configuration tests

set -e

echo "🧪 Running Neovim Configuration Tests"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if nvim is installed
if ! command -v nvim &> /dev/null; then
    echo -e "${RED}Error: Neovim is not installed${NC}"
    exit 1
fi

# Check if plenary is available
if ! nvim --headless -c "lua require('plenary')" -c "q" 2>/dev/null; then
    echo -e "${YELLOW}Installing plenary.nvim for testing...${NC}"
    nvim --headless -c "lua require('lazy').install({ wait = true })" -c "q"
fi

# Function to run a test file
run_test() {
    local test_file=$1
    local test_name=$(basename "$test_file" _spec.lua)
    
    echo -e "\n${YELLOW}Running: ${test_name}${NC}"
    echo "----------------------------------------"
    
    if nvim --headless -c "PlenaryBustedFile $test_file" -c "q" 2>&1; then
        echo -e "${GREEN}✓ ${test_name} passed${NC}"
        return 0
    else
        echo -e "${RED}✗ ${test_name} failed${NC}"
        return 1
    fi
}

# Run all tests or specific test
if [ $# -eq 0 ]; then
    # Run all tests
    TESTS_DIR="$(dirname "$0")"
    FAILED=0
    PASSED=0
    
    for test_file in "$TESTS_DIR"/*_spec.lua; do
        if run_test "$test_file"; then
            ((PASSED++))
        else
            ((FAILED++))
        fi
    done
    
    echo -e "\n======================================"
    echo -e "Results: ${GREEN}${PASSED} passed${NC}, ${RED}${FAILED} failed${NC}"
    
    if [ $FAILED -gt 0 ]; then
        exit 1
    fi
else
    # Run specific test
    run_test "$1"
fi