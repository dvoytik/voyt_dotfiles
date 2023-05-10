return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call

    config.defaults.layout_strategy = "vertical"
    config.defaults.layout_config.vertical.width = 0.99
    config.defaults.layout_config.vertical.height = 0.99
    --config.defaults.layout_config.horizontal.width = 0.99;
    --config.defaults.layout_config.horizontal.height = 0.99;
    config.defaults.layout_config.preview_cutoff = 30
    --config.defaults.layout_config.preview_height = 0.4;
    return config -- return final config table
  end,
}
