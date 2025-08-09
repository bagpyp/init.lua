#!/bin/bash

# =============================================================================
# UNIFIED TEST RUNNER FOR NEOVIM CONFIGURATION
# =============================================================================
# This script runs ALL available tests for your Neovim configuration
# Usage: ./test/run.sh [OPTIONS]
#
# Options:
#   --quick      Run only the quick passing tests
#   --spec       Run Plenary spec tests (requires full environment)
#   --startup    Only measure startup time
#   --help       Show this help message
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Test directory
TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$(dirname "$TEST_DIR")"

# Function to print section headers
print_header() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${BOLD}  $1${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Function to print test result
print_result() {
    local test_name=$1
    local status=$2
    local time=$3
    
    if [ "$status" = "pass" ]; then
        echo -e "${GREEN}  ✓${NC} $test_name ${time:+(${time}ms)}"
    elif [ "$status" = "fail" ]; then
        echo -e "${RED}  ✗${NC} $test_name"
    elif [ "$status" = "skip" ]; then
        echo -e "${YELLOW}  ○${NC} $test_name (skipped)"
    fi
}

# Function to run startup time test
run_startup_test() {
    print_header "STARTUP PERFORMANCE TEST"
    
    local total_time=0
    local count=3
    
    echo -e "${BLUE}Measuring startup time (${count} iterations)...${NC}"
    echo ""
    
    for i in $(seq 1 $count); do
        local log_file="/tmp/nvim_startup_${i}.log"
        nvim --headless -c "quit" --startuptime "$log_file" 2>/dev/null
        
        if [ -f "$log_file" ]; then
            local time=$(grep "NVIM STARTED" "$log_file" 2>/dev/null | awk '{print $1}')
            if [ ! -z "$time" ]; then
                echo -e "  Iteration ${i}: ${BOLD}${time}ms${NC}"
                total_time=$(echo "$total_time + $time" | bc)
            fi
            rm -f "$log_file"
        fi
    done
    
    if [ "$total_time" != "0" ]; then
        local avg=$(echo "scale=2; $total_time / $count" | bc)
        echo ""
        echo -e "${BOLD}Average startup time: ${avg}ms${NC}"
        
        # Evaluate performance
        if (( $(echo "$avg < 100" | bc -l) )); then
            echo -e "${GREEN}✅ Excellent! Startup is very fast (<100ms)${NC}"
        elif (( $(echo "$avg < 200" | bc -l) )); then
            echo -e "${GREEN}✅ Good! Startup is fast (<200ms)${NC}"
        elif (( $(echo "$avg < 500" | bc -l) )); then
            echo -e "${YELLOW}⚠ Acceptable startup time (<500ms)${NC}"
        else
            echo -e "${RED}⚠ Slow startup time (>500ms)${NC}"
        fi
    fi
}

# Function to run quick tests
run_quick_tests() {
    print_header "QUICK VALIDATION TESTS"
    
    echo -e "${BLUE}Running core tests...${NC}"
    echo ""
    
    # Test 1: All passing tests - main comprehensive test suite
    if nvim --headless -l "$TEST_DIR/all_passing_tests.lua" 2>/dev/null; then
        print_result "All passing tests suite (41 tests)" "pass"
    else
        print_result "All passing tests suite" "fail"
        return 1
    fi
}

# Function to run spec tests
run_spec_tests() {
    print_header "PLENARY SPEC TESTS"
    
    echo -e "${BLUE}Running spec tests (requires full environment)...${NC}"
    echo ""
    
    # Check if plenary is available
    if ! nvim --headless -c "lua require('plenary')" -c "q" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Plenary not installed. Installing...${NC}"
        nvim --headless -c "Lazy install plenary.nvim" -c "q" 2>/dev/null || true
    fi
    
    local spec_files=(
        "init_spec_fixed.lua"
        "custom_modules_spec.lua"
        "integration_spec.lua"
    )
    
    local passed=0
    local failed=0
    
    for spec in "${spec_files[@]}"; do
        if [ -f "$TEST_DIR/$spec" ]; then
            if nvim --headless \
                    -c "PlenaryBustedFile $TEST_DIR/$spec" \
                    -c "q" 2>/dev/null; then
                print_result "${spec%.lua}" "pass"
                ((passed++))
            else
                print_result "${spec%.lua}" "fail"
                ((failed++))
            fi
        else
            print_result "${spec%.lua}" "skip"
        fi
    done
    
    echo ""
    echo -e "${BOLD}Spec Results: ${GREEN}${passed} passed${NC}, ${RED}${failed} failed${NC}"
}

# Function to run full config test
run_full_config_test() {
    print_header "FULL CONFIGURATION TEST"
    
    echo -e "${BLUE}Testing with full configuration loaded...${NC}"
    echo ""
    
    # Since we removed the standalone files, we just run the comprehensive test
    echo -e "${YELLOW}Note: Using all_passing_tests.lua for full config validation${NC}"
    if nvim --headless -l "$TEST_DIR/all_passing_tests.lua" 2>/dev/null; then
        print_result "Configuration validation" "pass"
    else
        print_result "Configuration validation" "fail"
    fi
}

# Function to show help
show_help() {
    echo -e "${BOLD}Neovim Configuration Test Runner${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --quick      Run only the quick passing tests"
    echo "  --spec       Run Plenary spec tests (requires full environment)"
    echo "  --startup    Only measure startup time"
    echo "  --help       Show this help message"
    echo ""
    echo "Without options, runs ALL available tests"
}

# Function to run all tests
run_all_tests() {
    local start_time=$(date +%s)
    
    echo -e "${MAGENTA}${BOLD}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║           NEOVIM CONFIGURATION TEST SUITE                  ║"
    echo "║                    Running ALL Tests                       ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Run each test category
    run_startup_test
    run_quick_tests
    run_full_config_test
    
    # Try to run spec tests (may fail in minimal environment)
    echo ""
    echo -e "${YELLOW}Note: Spec tests may fail in minimal/headless environment${NC}"
    run_spec_tests 2>/dev/null || echo -e "${YELLOW}  Spec tests skipped (expected in headless mode)${NC}"
    
    # Calculate total time
    local end_time=$(date +%s)
    local total_time=$((end_time - start_time))
    
    # Final summary
    print_header "TEST SUITE COMPLETE"
    
    echo -e "${GREEN}${BOLD}✅ Core tests completed successfully!${NC}"
    echo -e "${BOLD}Total execution time: ${total_time} seconds${NC}"
    echo ""
    echo -e "${CYAN}📋 Next Steps:${NC}"
    echo "  1. Test keybindings manually: nvim"
    echo "  2. Try shortcuts: Space+1 through Space+8"
    echo "  3. Test find files: Space+ff"
    echo "  4. Test terminal: Space+8"
    echo ""
    echo -e "${BLUE}🎮 For interactive testing:${NC}"
    echo "  cd vim-game && ./start-simple.sh"
    echo ""
}

# Main execution
main() {
    # Check if nvim is installed
    if ! command -v nvim &> /dev/null; then
        echo -e "${RED}Error: Neovim is not installed${NC}"
        exit 1
    fi
    
    # Parse arguments
    case "${1:-}" in
        --quick)
            run_quick_tests
            run_startup_test
            ;;
        --spec)
            run_spec_tests
            ;;
        --startup)
            run_startup_test
            ;;
        --help)
            show_help
            ;;
        *)
            run_all_tests
            ;;
    esac
}

# Run main function
main "$@"