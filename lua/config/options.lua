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
