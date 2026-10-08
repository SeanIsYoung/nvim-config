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

  -- Hav an annoyig error with jdtls where it keeps popping up annoying,
  -- building messages at the bottom right of the corner of the screen.
  -- This is supposed to stop that.
  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          filter = {
            event = "lsp",
            kind = "progress",
            find = "jdtls",
          }
        },
        opts = { skip = true },
      }
    }
  },
}
