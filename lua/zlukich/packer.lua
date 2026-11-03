
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
      -- master (not the 0.1.8 tag): drops nvim-treesitter's removed ft_to_lang
      -- and uses Neovim's native vim.treesitter API, required for nvim 0.12+.
      'nvim-telescope/telescope.nvim', branch = 'master',
      requires = { {'nvim-lua/plenary.nvim'} }
  }
  use({ 'rebelot/kanagawa.nvim' })
  use({ 'cocopon/iceberg.vim' })
  use({ 'maxmx03/solarized.nvim' })
  use({ 'folke/tokyonight.nvim' })
  -- main branch is required for Neovim 0.12+ (master is EOL on new nvim).
  use('nvim-treesitter/nvim-treesitter', {branch = 'main', run = ':TSUpdate'})
  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use("hrsh7th/cmp-path")
  use("saadparwaiz1/cmp_luasnip")
  use("L3MON4D3/LuaSnip")  -- snippet engine
  use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
  }
--use {
    --"zbirenbaum/copilot.lua",
    --cmd = "Copilot",
    --event = "InsertEnter",
    --config = function()
      --require("copilot").setup({
        --suggestion = {
          --enabled = true,
          --auto_trigger = true,
          --debounce = 75,
          --keymap = {
            --accept = "<Tab>",
            --accept_word = false,
            --accept_line = false,
            --next = "<M-]>",
            --prev = "<M-[>",
            --dismiss = "<C-]>",
          --},
        --},
        --filetypes = {
          --yaml = false,
          --markdown = false,
          --help = false,
          --gitcommit = false,
          --gitrebase = false,
          --hgcommit = false,
          --svn = false,
          --cvs = false,
          --["."] = false,
        --},
      --})
    --end,
  --}
  --

  use({
  'MeanderingProgrammer/render-markdown.nvim',
  requires = {
    { 'nvim-treesitter/nvim-treesitter', branch = 'main' },
    'nvim-tree/nvim-web-devicons', -- you likely already have this from your setup
  },
  -- Setup lives in after/plugin/render-markdown.lua (so config changes don't
  -- require :PackerCompile to take effect).
})
  use({'prabirshrestha/asyncomplete.vim'})
  use({'preservim/nerdcommenter'})
  use({ 'catppuccin/nvim'})

  use({'rishi-opensource/vim-claude-code'})

  -- Claude Code integration
  use({
    'coder/claudecode.nvim',
    requires = { 'folke/snacks.nvim' },
    config = function()
      require('claudecode').setup()
    end,
  })

  -- Statusline
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
  })

  -- File tree on the left
  use({
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
  })

  -- Zen mode: centered code, no distractions. Setup lives in after/plugin/zenmode.lua
  use({ 'folke/zen-mode.nvim' })

  -- Jupyter notebooks. Setup + keymaps live in after/plugin/molten.lua
  -- Inline images (matplotlib plots). Ghostty speaks the kitty graphics
  -- protocol, so the 'kitty' backend is the right one.
  use({ '3rd/image.nvim' })

  -- The kernel: runs cells against a live Jupyter kernel and shows output.
  -- Run :UpdateRemotePlugins after installing/updating this.
  use({
    'benlubas/molten-nvim',
    run = ':UpdateRemotePlugins',
    requires = { '3rd/image.nvim' },
  })

  -- Opens .ipynb files transparently as plain text so treesitter, the LSP
  -- and nvim-cmp all work; saves back to .ipynb on write.
  use({ 'GCBallesteros/jupytext.nvim' })

  -- LSP / completion / diagnostics inside code cells (optional but nice).
  use({
    'quarto-dev/quarto-nvim',
    requires = {
      'jmbuhr/otter.nvim',
      { 'nvim-treesitter/nvim-treesitter', branch = 'main' },
    },
  })

end)

