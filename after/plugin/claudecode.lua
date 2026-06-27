local ok, claudecode = pcall(require, 'claudecode')
if not ok then
  return
end

claudecode.setup({
  terminal = {
    split_side = 'right',
    split_width_percentage = 0.30,
    provider = 'snacks',
  },
})

local map = vim.keymap.set
map('n', '<leader>cc', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
map('n', '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude' })
map('n', '<leader>cm', '<cmd>ClaudeCodeSelectModel<cr>', { desc = 'Select Claude model' })
map('v', '<leader>cs', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send selection to Claude' })
map('n', '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add current buffer to Claude' })

-- Diff handling
map('n', '<leader>cy', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept Claude diff (yes)' })
map('n', '<leader>cn', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny Claude diff (no)' })
