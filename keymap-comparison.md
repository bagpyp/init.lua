# Keymap Comparison Analysis

## DISCREPANCIES FOUND

### 1. Keymaps in DOCS but NOT in CONFIG:

#### From keymap-cheatsheet.md:
- `Shift+Tab` - Recent Files (documented but commented out in keymaps.lua:51)
- `Space+gg` - LazyGit (not in keymaps.lua, but defined in git.lua:359)
- `Space+gf` - Git Files (not found in any config)
- `Shift+F5` - Stop Debugging (documented in debugging.md but not configured)

#### From refactoring.md:
- `<leader>rv` - Extract Variable (documented but not configured)
- `<leader>re` - Extract Function (documented but not configured)
- `<leader>rn` - Force rename (documented but uses different mapping)
- `<leader>rN` - Force rename without confirmation (not configured)
- `<leader>rf` - Extract function to new file (not configured)
- `<leader>rc` - Extract component to file (not configured)
- `<leader>rs` - Change signature (not configured)
- `<leader>rcf` - Convert function declaration (not configured)
- `<leader>rpu` - Pull member up to parent class (not configured)
- `<leader>rpd` - Push member down to subclasses (not configured)
- `<leader>ro` - Organize imports (not configured)
- `<leader>ra` - Add missing imports (not configured)
- `<leader>ru` - Remove unused imports (not configured)
- `<leader>rp` - Preview with Telescope (not configured)
- `<leader>rtl` - Convert to template literal (not configured)
- `<leader>roc` - Convert to optional chaining (not configured)
- `<leader>rdo` - Destructure object (not configured)
- `<leader>rem` - Extract to method (Python) (not configured)
- `<leader>rfs` - Convert to f-string (Python) (not configured)
- `<leader>rth` - Add type hints (Python) (not configured)
- `<leader>rxc` - Extract component (React/Vue) (not configured)
- `<leader>rxf` - Convert to functional component (not configured)
- `<leader>rxh` - Extract hook (not configured)
- `<leader>rU` - Undo entire refactoring session (not configured)

#### From debugging.md:
- `<leader>dB` - Set conditional breakpoint (not configured)
- `<leader>dl` - Log point (not configured)
- `<leader>dlb` - List all breakpoints (not configured)
- `<leader>dC` - Clear all breakpoints (not configured)
- `<leader>de` - Enable/disable breakpoint (not configured)
- `<leader>td` - Debug test under cursor (not configured)
- `<leader>tdf` - Debug all tests in file (not configured)
- `<leader>dw` - Add watch (not configured)
- `<leader>de` - Evaluate selection (not configured)
- `<leader>dt` - Switch thread (not configured)
- `<leader>dP` - Pause all threads (not configured)
- `<leader>dE` - Break on exceptions (not configured)
- `<leader>dc` - List and select debug configuration (not configured)
- `<leader>dl` - Run last configuration (conflicts with log point) (not configured)
- `<leader>dB` - Step backwards (conflicts with conditional breakpoint) (not configured)
- `<leader>dR` - Reverse continue (not configured)

#### From testing.md:
- `<leader>td` - Debug test (not configured)
- `<leader>ts` - Stop test (conflicts with Test Summary toggle)
- `<leader>ti` - Toggle test summary panel (not configured)
- `]f` - Jump to next failed test (not configured)
- `[f` - Jump to previous failed test (not configured)
- `gt` - Jump between test and implementation (not configured)

#### From multicursor.md:
- `Ctrl+Down` - Create cursor below (not configured)
- `Ctrl+Up` - Create cursor above (conflicts with Expand Selection)
- `Ctrl+K` - Skip occurrence (not configured)
- `Ctrl+X` - Remove current cursor (not configured)
- `Ctrl+Alt+G` - Select all occurrences (not configured)

### 2. Keymaps in CONFIG but NOT in DOCS:

#### From keymaps.lua:
- `<leader>tc` - Close Other Tabs (not documented)
- `<C-h/j/k/l>` - Window navigation (not in keymap-cheatsheet.md)

#### From keymaps-optimized.lua:
- `<S-D-Up>` - Move Line Up (Mac-specific, not documented)
- `<S-D-Down>` - Move Line Down (Mac-specific, not documented)
- `<S-D-]>` - Next Run Config (Mac-specific, not documented)
- `<S-D-[>` - Previous Run Config (Mac-specific, not documented)
- `<D-3>` - Run Configs (Mac-specific, not documented)
- `<D-6>` - Services Docker (Mac-specific, not documented)
- `<D-M-n>` - Inline Variable (Mac-specific, not documented)
- `<D-s>` - Save file (Mac-specific, not documented)
- `<leader>qq` - Quit all (not documented)
- `<esc>` - Clear search highlight (not documented)
- `<` and `>` - Better indenting in visual mode (not documented)
- `gcc` - Toggle comment (not documented)
- `gc` - Toggle comment in visual mode (not documented)

#### From lsp.lua:
- `<leader>ca` - Code Action (documented as Quick Fixes)
- `gd` - Go to Definition (documented)
- `gr` - Go to References (documented)
- `gI` - Go to Implementation (documented as gi)
- `<leader>D` - Type Definition (not documented)
- `<leader>ds` - Document Symbols (not documented)
- `<leader>ws` - Workspace Symbols (not documented)
- `K` - Hover Documentation (documented)
- `<C-k>` - Signature Documentation (not documented)
- `gD` - Go to Declaration (not documented)
- `<leader>wa` - Workspace Add Folder (not documented)
- `<leader>wr` - Workspace Remove Folder (not documented)
- `<leader>wl` - Workspace List Folders (not documented)
- `<leader>rn` - Rename (documented as <leader>rn but actual is vim.lsp.buf.rename)

#### From telescope.lua:
- `<leader>fh` - Help Tags (not documented)
- `<leader>fc` - Commands (not documented)
- `<leader>fm` - Marks (not documented)
- `<leader>fk` - Keymaps (not documented)
- `<leader>ft` - Colorschemes (not documented)
- `<leader>fd` - Diagnostics (not documented)
- `<leader>fs` - Git Status (not documented)
- `<leader>gc` - Git Commits (documented)
- `<leader>gb` - Git Branches (documented)
- `<leader>fe` - File Browser (not documented)
- `<leader>fw` - Grep Word Under Cursor (not documented)
- `<leader>fw` - Grep Selection in visual mode (not documented)

#### From git.lua (gitsigns):
- `]c` - Next Hunk (not documented)
- `[c` - Previous Hunk (not documented)
- `<leader>hs` - Stage Hunk (not documented)
- `<leader>hr` - Reset Hunk (not documented)
- `<leader>hS` - Stage Buffer (not documented)
- `<leader>hu` - Undo Stage Hunk (not documented)
- `<leader>hR` - Reset Buffer (not documented)
- `<leader>hp` - Preview Hunk (not documented)
- `<leader>hb` - Blame Line (not documented)
- `<leader>tb` - Toggle Blame (not documented)
- `<leader>hd` - Diff This (not documented)
- `<leader>hD` - Diff This ~ (not documented)
- `<leader>td` - Toggle Deleted (not documented)
- `ih` - Select Hunk text object (not documented)

#### From git.lua (fugitive):
- `<leader>gs` - Git Status (not documented)
- `<leader>gd` - Git Diff (not documented)
- `<leader>gc` - Git Commit (conflicts with telescope git commits)
- `<leader>gb` - Git Blame (conflicts with telescope git branches)
- `<leader>gl` - Git Log (not documented)
- `<leader>gp` - Git Push (not documented)
- `<leader>gP` - Git Pull (not documented)
- `<leader>gf` - Git Fetch (not documented)

#### From git.lua (git-worktree):
- `<leader>gw` - Git Worktrees (not documented)
- `<leader>gW` - Create Git Worktree (not documented)

#### From git.lua (lazygit):
- `<leader>gg` - LazyGit (documented in keymap-cheatsheet.md)
- `<leader>gG` - LazyGit Current File (not documented)

#### From extras.lua:
- `<F6>` - Move/Rename File via Oil.nvim (documented differently)
- `gs` - Switch (toggle values) (not documented)

### 3. Conflicting Keymaps:
- `<leader>gc` - Git Commits (telescope) vs Git Commit (fugitive)
- `<leader>gb` - Git Branches (telescope) vs Git Blame (fugitive)
- `<leader>ts` - Toggle Test Summary (keymaps.lua) vs Stop test (testing.md docs)
- `<leader>dl` - Log point vs Run last configuration (debugging.md)
- `<leader>dB` - Conditional breakpoint vs Step backwards (debugging.md)
- `<leader>td` - Toggle Deleted (git.lua) vs Debug test (testing.md)
- `<leader>de` - Enable/disable breakpoint vs Evaluate selection (debugging.md)
- `Ctrl+Up` - Expand Selection vs Create cursor above
- `<leader>fw` - Used for both normal and visual mode grep

### 4. Missing Features Documented but Not Implemented:
- Many refactoring features from refactoring.md
- Advanced debugging features from debugging.md
- Test debugging integration
- Multi-cursor advanced features
- Language-specific refactorings

## RECOMMENDATIONS:
1. Remove non-existent keymaps from documentation
2. Add missing documented keymaps to config
3. Document all Mac-specific keymaps separately
4. Resolve conflicts between plugins
5. Add missing git keymaps to documentation
6. Create consistent naming for similar operations