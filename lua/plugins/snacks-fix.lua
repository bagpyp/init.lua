-- Fix LazyVim snacks integration
return {
  -- Completely disable alpha-nvim to avoid conflicts
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  
  -- Enable snacks dashboard instead
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      dashboard = { enabled = true },
      picker = { enabled = false },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      
      -- Override any snacks picker keymaps with telescope
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
    end,
  },
}