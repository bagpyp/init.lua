-- Minimal init for testing
-- This loads only what's necessary for tests to run

-- Set up paths
local root = vim.fn.fnamemodify("./.tests", ":p")
for _, name in ipairs({ "config", "data", "state", "cache" }) do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

-- Bootstrap lazy.nvim
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load performance settings first
require("config.performance")

-- Load minimal config
require("config.options")
require("config.keymaps")

-- Install plenary for testing
require("lazy").setup({
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
  },
}, {
  root = root .. "/plugins",
  defaults = {
    lazy = false,
  },
  install = {
    missing = true,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})