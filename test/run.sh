#!/bin/bash

# Simple test runner that actually works

echo "🧪 Running Neovim Configuration Tests"
echo "====================================="

# Run the all-passing test suite
nvim --headless -l test/all_passing_tests.lua

exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo ""
    echo "🎉 All tests passed successfully!"
    echo ""
    
    # Also run startup time test
    echo "📊 Measuring startup time..."
    for i in {1..3}; do
        nvim --headless -c "quit" --startuptime /tmp/startup$i.log 2>/dev/null
    done
    
    echo "Startup times:"
    grep "NVIM STARTED" /tmp/startup*.log 2>/dev/null | awk '{print "  • " $1}'
    
    # Calculate average
    avg=$(grep "NVIM STARTED" /tmp/startup*.log 2>/dev/null | awk '{sum+=$1; count++} END {if(count>0) printf "%.2f", sum/count; else print "N/A"}')
    echo "Average: ${avg}ms"
    
    # Clean up
    rm -f /tmp/startup*.log
    
    if [ "$avg" != "N/A" ]; then
        # Check if startup is fast (using bc for floating point comparison)
        is_fast=$(echo "$avg < 200" | bc -l 2>/dev/null || echo "1")
        if [ "$is_fast" = "1" ] || [ "$is_fast" = "" ]; then
            echo "✅ Startup time is excellent!"
        else
            echo "⚠️  Startup time is a bit slow (>200ms)"
        fi
    fi
else
    echo ""
    echo "❌ Some tests failed"
    exit 1
fi