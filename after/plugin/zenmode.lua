local ok, zen = pcall(require, "zen-mode")
if not ok then return end

zen.setup({})

vim.keymap.set("n", "<leader>zz", zen.toggle, { desc = "Toggle Zen mode" })
