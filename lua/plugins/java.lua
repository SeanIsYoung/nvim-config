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

      -- We disable autobuild. jdtls doesn't seem to play nice with our projects.
      -- https://medium.com/@laxsuryavanshi.dev/the-mystery-of-the-disappearing-compilation-when-vs-codes-java-extension-sabotages-your-maven-be82755d8dc6
      -- Basically jdtls uses the eclipse compiler, which doesn't seem to play nice with spring boot and it's annotations.
      -- Which is fine, sort of, because eclipse is made not to throw errors when it builds. So we wouldn't get any of the
      -- spring generated implementations. But we would get everything else.
      -- Unfortunately jdtls, or the editor, I'm not sure which, also watches the target directory, and so when we actually intend to build
      -- the project and do it using maven and javac, jdtls sees the project as having changed. And so attempts to rebuild the project itself.
      -- And depending on which finishes first and last decides whether or not the project actually runs.
      -- In the medium article the suggested fix is to stop vs code from watching the target / build directory.
      --
      -- `settings.json`
      -- ```json
      -- { "files.watcherExclude": { "**/target/**": true} }
      -- ```
      --
      -- Unfortunately I don't know how to get it to do that.
      --
      -- We could also have jdtls build to a directory other than target so the two don't conflict. Which would be all round preferable.
      -- But I'm not sure how to do that in the first place. And I suspect it might have to do with changing the project POM which is a no go.
      opts.settings = opts.settings or {}
      opts.settings.java = opts.settings.java or {}
      opts.settings.java.autobuild = opts.settings.java.autobuild or {}
      opts.settings.java.autobuild.enabled = false

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
