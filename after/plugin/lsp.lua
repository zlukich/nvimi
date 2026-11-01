-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings
local capabilities = vim.tbl_deep_extend(
  'force',
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { 'pyright', 'biome' },
  handlers = {
    function(server_name)
      -- Verwende die neue API für automatisch installierte Server
      vim.lsp.enable(server_name)
    end,
  }
})

-- LSP Keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}
    -- Add inside your LspAttach callback
    -- Press K a second time to jump into the hover window (scroll with j/k/<C-d>/<C-u>, close with q)
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover({ border = 'rounded', max_height = 25, max_width = 90 })
    end, opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', function()
      vim.lsp.buf.signature_help({ border = 'rounded' })
    end, opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- Make floating window borders stand out from the background
local function float_highlights()
  vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#3b5bdb', bold = true })
end
float_highlights()
vim.api.nvim_create_autocmd('ColorScheme', { callback = float_highlights })

vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float({ border = 'rounded' })
end, {
  desc = 'Show diagnostic under cursor',
})

vim.keymap.set('n', '<leader>q', function()
  vim.diagnostic.setloclist()
  vim.cmd('lopen')
end, {
  desc = 'Open diagnostics list',
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {
  desc = 'Previous diagnostic',
})

vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {
  desc = 'Next diagnostic',
})

-- Konfiguriere zusätzliche Server mit der neuen API
vim.lsp.config.gleam = {
  cmd = { 'gleam', 'lsp' },
  filetypes = { 'gleam' },
  root_markers = { 'gleam.toml' },
  capabilities = capabilities,
}

vim.lsp.config.ocamllsp = {
  cmd = { 'ocamllsp' },
  filetypes = { 'ocaml', 'ocaml.menhir', 'ocaml.interface', 'ocaml.ocamllex', 'reason', 'dune' },
  root_markers = { '*.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace' },
  capabilities = capabilities,
}

-- Aktiviere die Server
vim.lsp.enable('gleam')
vim.lsp.enable('ocamllsp')
