require('solarized').setup({
  styles = {
    comments = { italic = true },
  },
})

-- Transparent background: Neovim paints no background color of its own, so
-- the Ghostty wallpaper shows through at whatever strength Ghostty's own
-- background-image-opacity is set to. Neovim has no opacity knob of its
-- own (a terminal app can only pass the background through or paint over
-- it solid) — to make the image more/less visible, tune
-- background-image-opacity in ~/.config/ghostty/config.ghostty instead.
require('tokyonight').setup({
  style = 'storm',
  transparent = true,
  styles = {
    sidebars = 'transparent',
    floats = 'transparent',
  },
})

-- Apply the right colorscheme for the current background:
--   light -> solarized (matches the Ghostty "iTerm2 Solarized Light" theme)
--   dark  -> tokyonight storm, transparent (shows the Ghostty blue wallpaper)
local function apply_theme()
  if vim.o.background == 'light' then
    vim.cmd.colorscheme('solarized')
  else
    vim.cmd.colorscheme('tokyonight')
  end
end

vim.o.background = 'dark'
apply_theme()

-- Toggle between light (solarized) and dark (tokyonight) on the fly.
vim.keymap.set('n', '<leader>tt', function()
  vim.o.background = (vim.o.background == 'dark') and 'light' or 'dark'
  apply_theme()
end, { desc = 'Toggle light/dark theme' })
