-- Honestly I don't know.
--
-- We enable the spring-boot.nvim plugin here. But I don't really know if it's doing anything useful or not.
-- It doesn't do what I was hoping it would in the first place. But it took me that long to get set up
-- in the first place that I'm just going to leave it here for now.

return {
  -- Ensure Mason downloads the Spring Boot LS (spring-boot.nvim finds it automatically)
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "vscode-spring-boot-tools" },
    },
  },

  -- Spring Boot LS + jdtls bundle integration
  {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    dependencies = { "mfussenegger/nvim-jdtls" },
    ---@type bootls.Config
    opts = {
      ls_path = vim.fn.glob(
        vim.fn.stdpath("data") .. "/mason/packages/vscode-spring-boot-tools/extension/language-server/spring-boot-language-server-*-exec.jar"
      )
    },
  },

  -- Inject spring-boot's jdtls extension JARs into the existing jdtls setup
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.jdtls = function(config)
        local ok, spring_boot = pcall(require, "spring_boot")
        if ok then
          config.init_options = config.init_options or {}
          config.init_options.bundles =
            config.init_options.bundles or {}

          vim.list_extend(
            config.init_options.bundles,
              spring_boot.java_extensions() or {}
          )
        end
        return config
      end
      return opts
    end,
  },
}


-- return {
-- -- https://github.com/qw457812/dotfiles/blob/d1d149f4be3fe8eeb7b57888e25e6f73861c2ad2/dot_config/nvim/lua/plugins/lang/java.lua#L52
--  {
--     "mfussenegger/nvim-jdtls",
--     optional = true,
--     opts = function(_, opts)
--       local root_markers = vim.list_extend({ { ".nvim.lua", ".lazy.lua" } }, vim.lsp.config.jdtls.root_markers)
-- 
--         opts.jdtls = function(config)
-- 
--           if LazyVim.has("spring-boot.nvim") then
--             config.init_options = config.init_options or {}
--             config.init_options.bundles =
--               vim.list_extend(vim.deepcopy(config.init_options.bundles or {}), require("spring_boot").java_extensions())
--           end
--         end
--     end,
--   },
-- 
--   -- https://github.com/AstroNvim/astrocommunity/blob/5f74d5fb8d8dc9b8e2904846809121068d7afaca/lua/astrocommunity/pack/spring-boot/init.lua
--   -- https://github.com/qw457812/dotfiles/blob/d1d149f4be3fe8eeb7b57888e25e6f73861c2ad2/dot_config/nvim/lua/plugins/lang/java.lua#L201-L223
--   {
--     "JavaHello/spring-boot.nvim",
--     ft = {
--       "java",
--       -- "yaml",
--       "jproperties",
--     },
--     ---@type bootls.Config|{}
--     opts = {
--       -- Android's seccomp kills the JVM with SIGSYS when the server uses its default ZGC.
--       -- https://github.com/JavaHello/spring-boot.nvim/blob/9880be48170a21d97444b1eba75853fd3bad33c3/lua/spring_boot/launch.lua#L49
--       jvm_args = vim.g.user_is_termux and { "-XX:-UseZGC", "-XX:+UseG1GC" } or nil,
--       log_file = function()
--         return vim.fs.joinpath(vim.fn.stdpath("log"), "spring-boot-ls.log")
--       end,
--     },
--     specs = {
--       {
--         "mason-org/mason.nvim",
--         opts = { ensure_installed = { "vscode-spring-boot-tools" } },
--       },
--     },
--   },
-- }
