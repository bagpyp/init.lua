-- Fix syntax highlighting by properly configuring colorscheme
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Ensure syntax is enabled
      vim.cmd("syntax enable")
      
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "transparent",
          floats = "transparent",
        },
        sidebars = { "qf", "help", "neo-tree", "terminal", "packer", "Trouble" },
        on_highlights = function(hl, c)
          local transparent_groups = {
            "Normal", "NormalNC", "NormalFloat", "FloatBorder",
            "TelescopeNormal", "TelescopeBorder", "NeoTreeNormal",
            "NeoTreeNormalNC", "EndOfBuffer", "SignColumn",
            "StatusLine", "StatusLineNC", "VertSplit", "WinSeparator"
          }
          for _, group in ipairs(transparent_groups) do
            hl[group] = { bg = "NONE", ctermbg = "NONE" }
          end
        end,
      })
      
      vim.cmd("colorscheme tokyonight")
      
      -- Ensure treesitter highlighting after startup
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          vim.cmd("syntax enable")
          local ok, configs = pcall(require, "nvim-treesitter.configs")
          if ok then
            -- Force treesitter to reinitialize highlighting
            vim.cmd("doautocmd FileType")
          end
        end,
      })
    end,
  },
  
  -- Override treesitter to ensure highlighting is enabled
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = false
      return opts
    end,
  },
}