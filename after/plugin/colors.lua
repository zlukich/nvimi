require('kanagawa').setup({
  theme = 'lotus',
  background = {
    light = 'lotus',
    dark = 'wave',
  },
})

vim.o.background = 'light'
vim.cmd.colorscheme('kanagawa')

-- Toggle between light (lotus) and dark (wave) on the fly.
vim.keymap.set('n', '<leader>tt', function()
  vim.o.background = (vim.o.background == 'dark') and 'light' or 'dark'
  vim.cmd.colorscheme('kanagawa')
end, { desc = 'Toggle light/dark theme' })
