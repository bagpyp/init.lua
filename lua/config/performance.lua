-- Performance optimizations for Neovim

-- Disable some built-in plugins for faster startup
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
  "matchparen",
  "tohtml",
  "tutor",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Performance settings
vim.opt.updatetime = 200 -- Faster completion
vim.opt.timeoutlen = 300 -- Faster which-key
vim.opt.redrawtime = 1500 -- Time in milliseconds for redrawing
vim.opt.ttimeoutlen = 10 -- Time in milliseconds to wait for a key code sequence
vim.opt.ttyfast = true -- Faster terminal connection

-- Disable some providers for faster startup
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Large file optimizations
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > 1024 * 1024 then -- 1MB
      vim.b.large_file = true
      vim.cmd("syntax off")
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.undolevels = -1
      vim.opt_local.undoreload = 0
      vim.opt_local.list = false
    end
  end,
})

-- Faster startup by deferring clipboard
vim.opt.clipboard = ""
vim.defer_fn(function()
  vim.opt.clipboard = "unnamedplus"
end, 100)

-- Optimize fold settings
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldenable = false

-- Cache settings
vim.opt.shada = "!,'300,<50,s10,h"

-- Reduce startup time by lazy loading filetype
vim.g.did_load_filetypes = 0
vim.g.do_filetype_lua = 1