-- Enables inline images in markdown documents.

return {
  "folke/snacks.nvim",
  opts = { image = { enabled = true } },
  init = function()
    -- Rio supports the kitty protocol + unicode placeholders, but snacks doesn't know it.
    -- Remove once snacks recognises Rio.
    if vim.env.TERM_PROGRAM == "rio" then
      vim.env.SNACKS_GHOSTTY = "true"
    end

    -- TODO: Remove once merged.
    -- Workaround for Windows langs() bug (folke/snacks.nvim#2920).
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(ev)
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ev.buf) then
            Snacks.image.doc.attach(ev.buf)
          end
        end)
      end,
    })
  end,
}
