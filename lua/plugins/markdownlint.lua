local markdownlint_config = "C:/Users/4342/AppData/Local/markdownlint/.markdownlint.yaml"

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", markdownlint_config, "--" },
        },
      },
    },
  },
}
