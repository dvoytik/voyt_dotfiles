return { -- this table overrides highlights in all themes
  -- set the transparency for all of these highlight groups
  Normal = { bg = "NONE", ctermbg = "NONE" }, -- NONE means transparent
  NormalNC = { bg = "NONE", ctermbg = "NONE" },
  CursorColumn = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
  CursorLine = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
  CursorLineNr = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
  LineNr = {},
  SignColumn = {},
  StatusLine = {},
  NeoTreeNormal = { bg = "NONE", ctermbg = "NONE" },
  NeoTreeNormalNC = { bg = "NONE", ctermbg = "NONE" },
  -- line right below the tabline
  WinBar = { bg = "NONE", ctermbg = "NONE" },
}
