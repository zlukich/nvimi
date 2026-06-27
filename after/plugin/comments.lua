-- NERDCommenter default mappings are disabled (see lua/zlukich/set.lua) so the
-- <leader>c prefix is free for Claude Code. These restore commenting on gc/gcc.
vim.keymap.set('n', 'gcc', '<Plug>NERDCommenterToggle', { desc = 'Toggle comment (line)' })
vim.keymap.set('x', 'gc', '<Plug>NERDCommenterToggle', { desc = 'Toggle comment (selection)' })
