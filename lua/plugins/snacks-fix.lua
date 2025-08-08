-- Fix snacks.nvim directory picker issue
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        enabled = false, -- Disable the problematic file picker
      },
      explorer = {
        enabled = false, -- Disable the problematic directory explorer
      },
    },
  },
}