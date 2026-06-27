-- Then configure nvim-cmp in (for example) lua/yourname/cmp.lua
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            -- LuaSnip snippet expand
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
    mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "luasnip" },
    },
})
