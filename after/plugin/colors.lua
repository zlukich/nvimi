require('kanagawa').setup({
  theme = 'wave',
  background = {
    dark = 'wave',
  },
})

-- Apply the right colorscheme for the current background:
--   light -> iceberg (its light variant)
--   dark  -> kanagawa wave
local function apply_theme()
  if vim.o.background == 'light' then
    vim.cmd.colorscheme('iceberg')
  else
    vim.cmd.colorscheme('kanagawa')
  end
end

vim.o.background = 'light'
apply_theme()

-- Toggle between light (iceberg) and dark (kanagawa wave) on the fly.
vim.keymap.set('n', '<leader>tt', function()
  vim.o.background = (vim.o.background == 'dark') and 'light' or 'dark'
  apply_theme()
end, { desc = 'Toggle light/dark theme' })
