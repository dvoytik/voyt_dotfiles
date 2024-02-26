-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(function(bufnr)
          require("astronvim.utils.buffer").close(bufnr)
        end)
      end,
      desc = "Pick to close",
    },
    ["<leader>j"] = { "<cmd>HopChar1<cr>", desc = "Move cursor to char" },
    ["<leader>x"] = { "<cmd>w | split | terminal ./test.sh<cr>", desc = "Run ./test.sh" },
    ["<leader>m"] = { "<cmd>HiMyWordsToggle<cr>", desc = "Highlight word" },
    -- Rust specific mappings:
    ["<leader>rt"] = { "<cmd>w | split | terminal cargo test --workspace<cr>", desc = "cargo test" },
    ["<leader>rr"] = { "<cmd>w | split | terminal cargo run<cr>", desc = "cargo run" },
    ["<leader>rn"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      desc = "next diagnostic",
    },
    -- Hover (i.e., show) symbol (variable) information from LSP
    ["<leader>rh"] = {
      function()
        vim.lsp.buf.hover()
      end,
      desc = "Hover symbol",
    },
    ["<leader>rs"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      desc = "Signature help",
    },
    ["<leader>rd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      desc = "Show definition",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
