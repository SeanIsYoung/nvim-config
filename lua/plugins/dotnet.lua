--[[
-- The dotnet extra provided by LazyVim uses omnisharp and csharpier.
--
-- First CSharpier. We don't want this because it is opionated. There is no
-- way to match it to the style of an existing project. So we disable it.
--
-- Second. Omnisharp. For whatever reason with my configuration, it refuses
-- to respect the .editorconfig file. So we have disabled that too and
-- replaced it with roslyn.nvim. Currently using Roslyn basically requires
-- that package. Hopefully someday we won't need it. But for now it works.
--]]

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cs = {}, -- disable formatting for C#
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = { enabled = false },
      },
    },
  },

  -- Registry that provides the `roslyn` package
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- When we provide additional registries we must also provide the default one.
      opts.registries = opts.registries or { "github:mason-org/mason-registry" }
      table.insert(opts.registries, "github:Crashdummyy/mason-registry")

      -- We don't want csharpier anymore. But it's included by the dotnet extra.
      opts.ensure_installed = vim.tbl_filter(function(pkg)
        return pkg ~= "csharpier"
      end, opts.ensure_installed or {})

      -- Instead of omnisharp we want roslyn.
      table.insert(opts.ensure_installed, "roslyn")
    end,
  },

  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {},
    init = function()
      vim.lsp.config("roslyn", {
        settings = {
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
        },
      })
    end,
  },
}
