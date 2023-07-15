return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    branch = "v2",
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
  },
  {
    "dvoytik/hi-my-words.nvim",
    event = "BufRead",
    config = function()
      require("hi-my-words")
    end,
  },
  -- I want that the window split is closed after I close the buffer:
  { "echasnovski/mini.bufremove", enabled = false },
}
