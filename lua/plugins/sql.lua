return {
  "stevearc/conform.nvim",
  optional = true,
  opts = function(_, opts)
    opts.formatters = opts.formatters or {}
    opts.formatters.sqlfluff = opts.formatters.sqlfluff or {}

    -- By default lazyvim set's the args to: `{ "format", "--dialect=ansi", "-" }`
    -- This overrides any dialect that has been set within a config file.
    -- We remove the dialect parameter such that we can instead rely upon the config.
    opts.formatters.sqlfluff.args = { "format", "-" }
  end,
}
