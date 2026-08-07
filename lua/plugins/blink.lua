-- Blink controls auto select. The default behaviour is to select the first entry automatically, then enter confirms the selection. This typically means that when pressing enter for a new line you will end up accepting whatever snippet was suggested.
-- This fixes that by disabling the preselect.
-- The documentation on this is here: https://cmp.saghen.dev/configuration/keymap#enter
-- And here: https://cmp.saghen.dev/configuration/completion#list

return {
  {
    "saghen/blink.cmp",
    optional = true,
    opts = { completion = { list = { selection = { preselect = false } } } },
  },
}
