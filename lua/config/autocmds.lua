-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- For some reason sqlfluff can't parse files with a UTF8 BOM element.
-- But neovim won't stop writing it. So we're setting an autocmd command
-- to disable the feature for us.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = ".sqlfluff",
  callback = function() vim.bo.bomb = false end,
})
