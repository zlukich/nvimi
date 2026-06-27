require('kanagawa').setup({
  theme = 'wave',
  background = {
    dark = 'wave',
  },
})

vim.o.background = 'dark'
vim.cmd.colorscheme('kanagawa')
