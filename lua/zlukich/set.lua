-- Dedicated venv for nvim's Python host (pynvim, jupyter_client for molten).
-- Created with: python3 -m venv ~/.venvs/neovim && pip install pynvim jupyter
-- jupyter_client jupytext ipykernel
vim.g.python3_host_prog = os.getenv("HOME") .. "/.venvs/neovim/bin/python3"

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"

-- Free up the <leader>c prefix for Claude Code by disabling NERDCommenter's
-- default mappings. Replacement comment maps live in after/plugin/comments.lua.
vim.g.NERDCreateDefaultMappings = 0

