#!/bin/bash
# Run the working test suite

echo "🚀 Running Your Neovim Configuration Tests"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Starting test suite...${NC}"
echo ""

# Run the main passing test suite
if nvim --headless -l test/all_passing_tests.lua; then
    echo ""
    echo -e "${GREEN}✅ ALL TESTS COMPLETED SUCCESSFULLY!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Next Steps:${NC}"
    echo "1. Test your shortcuts manually: nvim"
    echo "2. Try Space+1, Space+8, Space+ff"
    echo "3. Play the VimGame: cd vim-game && ./start-simple.sh"
    echo ""
    echo -e "${GREEN}🎉 Your JetBrains-style Neovim config is working perfectly!${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}❌ Some tests failed${NC}"
    echo ""
    echo -e "${YELLOW}🔧 Troubleshooting:${NC}"
    echo "1. Check if ~/.config/nvim exists"
    echo "2. Verify init.lua is present"
    echo "3. Run: nvim --version"
    echo ""
    exit 1
fi