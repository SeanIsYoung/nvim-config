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
--
-- TODO: Update to easydotnet.
-- What we have works. But easydotnet seems to add more features and integrations.
-- Plus hopefully at some point roslyn.nvim will be replaced with nvim-lspconfig.
-- Try switching to easydotnet.
--
-- https://github.com/GustavEikaas/easy-dotnet.nvim
-- https://github.com/LazyVim/LazyVim/pull/6730 - pull request adding it as an extra to lazyvim.
-- https://github.com/mogggen/LazyVim/pull/1/changes - someone else's custom implementation.
--]]

-- lua/plugins/resharper-format.lua
local sdk_cache = {}

local function dotnet_sdk(dir)
  if sdk_cache[dir] == nil then
    -- Run in the solution dir so global.json is respected
    local res = vim.system({ "dotnet", "--version" }, { cwd = dir, text = true }):wait()
    sdk_cache[dir] = res.code == 0 and vim.trim(res.stdout) or false
  end
  return sdk_cache[dir]
end

return {
  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = { timeout_ms = 120000 },
      formatters_by_ft = { cs = { "resharper" } },
      formatters = {
        resharper = {
          command = "jb",
          stdin = false,
          tmpfile_format = false,
          args = function(self, ctx)
            local sln = vim.fs.find(function(n)
              return n:match("%.slnx?$")
            end, { path = ctx.dirname, upward = true })[1]
            local root = vim.fs.dirname(sln)
            local file = vim.fs.normalize(ctx.filename)
            local rel = file:sub(#vim.fs.normalize(root) + 2)

            local args = { "cleanupcode" }
            local sdk = dotnet_sdk(root)
            if sdk then
              table.insert(args, "--dotnetcoresdk=" .. sdk)
            end
            vim.list_extend(args, {
              "--include=" .. rel,
              "--profile=Built-in: Reformat Code",
              "--no-build",
              sln,
            })
            return args
          end,
        },
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
