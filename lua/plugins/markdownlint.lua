-- markdownlint-cli2 via nvim-lint: why this exists
--
-- markdownlint-cli2 only honours config files in the directory it is run from
-- or below it. Neovim runs it from its own cwd and pipes the buffer over
-- stdin, so the CLI never sees the file's path and can't do its normal
-- per-file config lookup. Result: configs in subdirectories (e.g. proj/sub/)
-- are ignored when Neovim is started from proj/, unlike the CLI run by hand.
--
-- Workaround: walk from the file's directory up to nvim's cwd (never above it),
-- take the nearest config, and pass it explicitly with --config. If no config
-- is found, skip the linter entirely (so repos without one are left alone).
--
-- No global/personal config fallback on purpose. Dropped to keep this simple.
--
-- Depends on (verify if this breaks after a LazyVim/nvim-lint update):
--   - LazyVim's per-linter `condition` function
--   - nvim-lint evaluating functions inside `prepend_args`
--   - `ctx.filename` being available in `condition`
-- Also: on Windows, a drive-letter case mismatch between cwd and the buffer
-- path (c:/ vs C:/) can make the cwd prefix check fail silently.

local config_names = {
  ".markdownlint-cli2.jsonc", ".markdownlint-cli2.yaml",
  ".markdownlint-cli2.cjs", ".markdownlint-cli2.mjs",
  ".markdownlint.jsonc", ".markdownlint.json",
  ".markdownlint.yaml", ".markdownlint.yml",
  ".markdownlint.cjs", ".markdownlint.mjs",
}

-- Nearest config between the file's directory and nvim's cwd (inclusive).
local function find_config(file)
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  local dir = vim.fs.normalize(vim.fs.dirname(file))
  if not vim.startswith(dir, cwd) then
    return nil -- file is outside the cwd tree
  end
  while true do
    for _, name in ipairs(config_names) do
      local path = vim.fs.joinpath(dir, name)
      if vim.uv.fs_stat(path) then
        return path
      end
    end
    local parent = vim.fs.dirname(dir)
    if dir == cwd or parent == dir then
      return nil
    end
    dir = parent
  end
end

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          condition = function(ctx)
            return find_config(ctx.filename) ~= nil
          end,
          prepend_args = {
            "--config",
            function()
              return find_config(vim.api.nvim_buf_get_name(0))
            end,
          },
        },
      },
    },
  },
}
