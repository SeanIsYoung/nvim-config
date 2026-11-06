# 💤 LazyVim

My [LazyVim](https://github.com/LazyVim/LazyVim) configuration.
The LazyVim [documentation](https://lazyvim.github.io/installation).

## Profiles

So work is annoying, and they don't use any linters on their code. By default LazyVim has `autoformat=true`, this means that whenever I write a file it formats it according to the linter, and completely changes the file. I don't want to be arguing with their existing files, so it's just easier to disable autoformat all together. So far this is being done by checking for the environment variable `NVIM_PROFILE` in `lua\config\options.lua`. But this is only one setting. If things start to get more complicated we can start using NVIM_APPNAME to have a separate config for work and home that is still derived from a common shared config.

NVIM_APPNAME changes the root Neovim configuration directory. So setting `NVIM_APPNAME=nvim-work` would use `~/.config/nvim-work` instead of `~/.config/nvim`. We can add the shared config by adding it to the runtime path *(rtp)*. The runtime path is the list of directories that Neovim searches for Lua modules, plugins colourschemes, and other resources.

Directory layout:

```txt
~/.config/
├── nvim-shared/
│   └── lua/
│       ├── config/
│       └── plugins/
└── nvim-work/
    ├── init.lua
    └── lua/
        └── work/
          ├── config/
          └── plugins/
```

nvim-work/init.lua:

```lua
vim.opt.rtp:prepend(vim.fn.expand("~/.config/nvim-shared"))
```

After this, Neovim can see modules from both directories.


### Plugin Files

# Plugin Files

The runtime path only makes the shared files visible. LazyVim still needs imports for both plugin namespaces.

Example:

```lua
spec = {
  { import = "plugins" },
  { import = "work.plugins" },
}
```

This normally goes in the file that calls:

```lua
require("lazy").setup(...)
```

For a standard LazyVim install, that is usually: `lua/config/lazy.lua` Add the imports once. After that, new plugin files are discovered automatically.

Example:

```
~/.config/nvim-shared/lua/plugins/git.lua
~/.config/nvim-work/lua/work/plugins/work.lua
```

Both files load automatically.

### Config Files

Config files do not auto-load. A file only runs when something explicitly calls `require("config.options")`. Lua searches for the first matching module and loads that one. If both locations contain `config/options.lua` then only one file loads. So we need to make sure the names are unique. 

The shared config should own the standard LazyVim modules:

- `config.options`
- `config.autocmds`
- `config.keymaps`

These are already loaded by the normal LazyVim startup process and so no extra require statements are needed. For profile specific configuration, create new modules under the profile namespace: `~/.config/nvim-work/lua/work/config/options.lua` and explicitly load the module using `require("work.config.options")`. This avoids conflicts with the shared configuration.
