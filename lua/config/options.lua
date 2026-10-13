-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Configure LSP server for rust.
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

vim.cmd("set title")

vim.opt.clipboard = ""

-- LazyVim's default is to set this to unnamed. Which I'm not entirely sure I understand.
-- But it appears to sync the system and internal registers.
-- This means that any copies we make inside nvim with plain old `y` are now copied to
-- the system clipboard and so on.
--
-- But it get's annoying. So we've put it back to how it's supposed to be.
vim.opt.clipboard = ""

-- Work don't use any linters, and having the enabled by default just causes problems.
vim.g.autoformat = vim.env.NVIM_PROFILE ~= "work"


-- LazyVim sets the defaults to 2. I personally prefer 2, but work and most everyone else seems to use 4.
--
-- The problem is that work and most everyone else don't provide configurations to enforce this.
-- So... If you want to use 2. The better solution is to instead add a `.editorconfig` to all
-- of your personal projects. As well as a configuration for the respective language. And possibly
-- have a repo with templates to pull from if you find yourself often reusing the same config over
-- and over.
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
