vim.keymap.set("n","<leader>gs", vim.cmd.Git);
vim.keymap.set('n', '<leader>gi', '<cmd>Gdiffsplit<cr>', {
  desc = 'Git diff current file',
})
vim.opt.splitright = false
vim.opt.diffopt:append('vertical')
