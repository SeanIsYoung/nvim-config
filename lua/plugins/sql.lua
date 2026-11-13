return {
  "stevearc/conform.nvim",
  optional = true,
  opts = function(_, opts)
    opts.formatters = opts.formatters or {}
    opts.formatters.sqlfluff = opts.formatters.sqlfluff or {}

    -- By default lazyvim set's the args to: `{ "format", "--dialect=ansi", "-" }`
    -- This overrides any dialect that has been set within a config file.
    -- We remove the dialect parameter such that we can instead rely upon the config.

    -- NOTE: because we applied this setting, it requires a dialect is **EXPLICITLY SET**
    -- in a config file. Which means a config file must be provided.
    -- Also, it seems to only work when you are running neovim from the same directory
    -- as the configuration file.
    opts.formatters.sqlfluff.args = { "format", "-" }

    -- https://docs.sqlfluff.com/en/stable/usage/cli.html#exit-codes
    -- SqlFluff returns 1 when the operation succeeds, but there were issues it was unable to fix.
    -- In this case it will still have applied partial fixes that we want. But because exit code 1
    -- is traditionally considered an error, conform / neovim rejects it.
    -- So we need to explicitly allow it.
    -- Exit Code 2 is a real failure.
    opts.formatters.sqlfluff.exit_codes = {0, 1}
  end,
}
