-- nvim-treesitter `main` branch API (required for Neovim 0.12+).
-- The old `master` API (ensure_installed / highlight = { enable = true } /
-- require'nvim-treesitter.configs') was removed in the rewrite. On `main`:
--   * parsers are installed explicitly via require('nvim-treesitter').install()
--   * highlighting is started per-buffer with vim.treesitter.start()
local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
    return
end

ts.setup({})

local parsers = {
    "c", "go", "lua", "vim", "vimdoc", "query",
    "markdown", "markdown_inline", "python",
    "javascript", "typescript", "latex",
}

-- Install any missing parsers (async; safe to call every startup).
ts.install(parsers)

-- Start treesitter highlighting whenever we enter a buffer whose language has
-- a parser available. pcall keeps it quiet for filetypes without a parser.
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and vim.treesitter.language.add(lang) then
            pcall(vim.treesitter.start, args.buf, lang)
        end
    end,
})
