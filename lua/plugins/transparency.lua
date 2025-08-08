-- Transparency configuration for iTerm2 background
return {
  -- Update tokyonight theme for transparency
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true, -- Enable transparency
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "transparent", -- Make sidebars transparent
          floats = "transparent", -- Make floating windows transparent
        },
        sidebars = { "qf", "help", "neo-tree", "terminal", "packer", "OverseerList", "Trouble" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        
        on_highlights = function(hl, c)
          -- Make various UI elements transparent
          hl.Normal = { bg = "NONE", ctermbg = "NONE" }
          hl.NormalNC = { bg = "NONE", ctermbg = "NONE" }
          hl.NormalFloat = { bg = "NONE", ctermbg = "NONE" }
          hl.FloatBorder = { bg = "NONE", ctermbg = "NONE" }
          hl.TelescopeNormal = { bg = "NONE", ctermbg = "NONE" }
          hl.TelescopeBorder = { bg = "NONE", ctermbg = "NONE" }
          hl.NeoTreeNormal = { bg = "NONE", ctermbg = "NONE" }
          hl.NeoTreeNormalNC = { bg = "NONE", ctermbg = "NONE" }
          hl.EndOfBuffer = { bg = "NONE", ctermbg = "NONE" }
          hl.SignColumn = { bg = "NONE", ctermbg = "NONE" }
          hl.StatusLine = { bg = "NONE", ctermbg = "NONE" }
          hl.StatusLineNC = { bg = "NONE", ctermbg = "NONE" }
          hl.VertSplit = { bg = "NONE", ctermbg = "NONE" }
          hl.WinSeparator = { bg = "NONE", ctermbg = "NONE" }
        end,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Update lualine for transparency
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Custom transparent theme for lualine
      local transparent_theme = require("lualine.themes.tokyonight")
      transparent_theme.normal.c.bg = "NONE"
      transparent_theme.insert.c.bg = "NONE"
      transparent_theme.visual.c.bg = "NONE"
      transparent_theme.replace.c.bg = "NONE"
      transparent_theme.command.c.bg = "NONE"
      transparent_theme.inactive.c.bg = "NONE"
      
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = transparent_theme,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "neo-tree", "toggleterm", "quickfix" }
      })
    end,
  },

  -- Additional transparency settings
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({
        groups = { -- table: default groups
          "Normal", "NormalNC", "Comment", "Constant", "Special", "Identifier",
          "Statement", "PreProc", "Type", "Underlined", "Todo", "String", "Function",
          "Conditional", "Repeat", "Operator", "Structure", "LineNr", "NonText",
          "SignColumn", "CursorLineNr", "EndOfBuffer",
        },
        extra_groups = { -- table: additional groups that should be cleared
          "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
          "NvimTreeNormal", -- NvimTree
          "NeoTreeNormal", -- NeoTree
          "NeoTreeNormalNC",
          "TelescopeNormal",
          "TelescopeBorder",
          "WhichKeyFloat",
          "FloatBorder",
          "Pmenu",
          "Float",
        },
        exclude_groups = {}, -- table: groups you don't want to clear
      })
      
      -- Commands to toggle transparency
      vim.keymap.set("n", "<leader>ut", "<cmd>TransparentToggle<cr>", { desc = "Toggle Transparency" })
    end,
  },
}