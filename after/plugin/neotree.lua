local ok, _ = pcall(require, 'neo-tree')
if not ok then
  return
end

require('neo-tree').setup({
  close_if_last_window = true,
  filesystem = {
    follow_current_file = { enabled = true },
    hijack_netrw_behavior = 'open_default',
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  window = {
    position = 'left',
    width = 32,
    mappings = {
      -- open the node under the cursor with the system viewer (e.g. plot PNGs)
      ['X'] = function(state)
        vim.ui.open(state.tree:get_node().path)
      end,
    },
  },
})

-- Open the path under the cursor (e.g. "plot_gd.png" in a script) with the system viewer
vim.keymap.set('n', '<leader>o', function()
  local path = vim.fn.expand('<cfile>')
  if not vim.uv.fs_stat(path) then
    path = vim.fn.expand('%:p:h') .. '/' .. path
  end
  vim.ui.open(path)
end, { desc = 'Open file under cursor externally' })

vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Toggle file tree' })

-- Open the tree by default on startup (only when opening a dir or no file args)
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    require('neo-tree.command').execute({ action = 'show', position = 'left' })
  end,
})
