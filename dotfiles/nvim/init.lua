-- Main config file

-- load lua/my_packer.lua
-- This plugin will load other plugins
require("my_packer")
require("my_rust")

vim.g.mapleader = " "
-- number of visual spaces per tab
vim.o.tabstop = 4
-- number of indent using >> and <<
vim.o.shiftwidth = 4
-- number of spaces in a tab when editing
vim.o.softtabstop = 4
-- tabs are spaces
vim.o.expandtab = true
-- auto indent when editing
vim.o.autoindent = true
-- don't wrap
vim.o.wrap = false
-- <tab>/<BS> indent/dedent in leading whitespace
vim.o.smarttab = true
vim.o.smartindent = true
-- ignore case when searching
vim.o.ignorecase = true
-- case insensitive, except when using uppercase chars
vim.o.smartcase = true
vim.o.number = true
vim.o.relativenumber = true
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
-- Automatically insert \n when blank is inserted
-- vim.opt.textwidth = 80
vim.o.wrap = true
-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.wo.signcolumn = "yes"
-- TODO:
-- undofile
--


-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require("cmp")
cmp.setup({
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },

  -- Installed sources
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "path" },
    { name = "buffer" },
  },
})

-- Set true colors
vim.o.termguicolors = true
-- color scheme
vim.cmd("colorscheme nord")


-- Telescope hot keys
local builtin = require('telescope.builtin')
vim.keymap.set('n', ',ff', builtin.find_files, {})
vim.keymap.set('n', ',fg', builtin.live_grep, {})
vim.keymap.set('n', ',fb', builtin.buffers, {})
vim.keymap.set('n', ',fh', builtin.help_tags, {})
