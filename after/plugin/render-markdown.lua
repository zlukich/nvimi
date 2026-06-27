local ok, rm = pcall(require, "render-markdown")
if not ok then
    return
end

rm.setup({
    -- Block latex (multi-line $$...$$) always renders the converted unicode
    -- *in addition to* the raw source, which is cluttered and looks bad for
    -- dense formulas (latex2text mangles fracs/sums/underbraces). Disable block
    -- rendering and keep inline ($...$) latex, which replaces cleanly in place.
    -- For reading dense math nicely, view the rendered notebook (Jupyter/browser).
    latex = { enabled = true, block = false },
})
