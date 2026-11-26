# nvimi

Personal Neovim configuration (`0.12+`) built around `nvim-treesitter` (`main` branch), native `vim.lsp` + `mason.nvim`, `telescope.nvim`, `harpoon`, `neo-tree`, `claudecode.nvim`, and Jupyter/Molten workflow support.

## Quick Install (Linux x86_64 — No `sudo` Required)

Run the automated setup script to install Neovim, `tree-sitter-cli`, `ripgrep`, `uv` + `pyright`, `packer.nvim`, and all plugins/parsers into `~/.local` and `~/.config/nvim`:

```bash
curl -fsSL [https://raw.githubusercontent.com/zlukich/nvimi/main/install.sh](https://raw.githubusercontent.com/zlukich/nvimi/main/install.sh) | bash
source ~/.bashrc
```

## System Prerequisites

If you prefer installing dependencies manually rather than using `install.sh`, make sure the following tools are available in your `PATH`:

| Dependency | Purpose | Install Command (User-Local / No `sudo`) |
| :--- | :--- | :--- |
| **Neovim `0.12+`** | Required for `nvim-treesitter` `main` branch & `vim.lsp.config` | Download `nvim-linux-x86_64.tar.gz` from [Neovim Releases](https://github.com/neovim/neovim/releases) into `~/.local/opt` |
| **C Compiler (`gcc` / `cc`)** | Compiles Treesitter language parsers | `sudo apt install -y build-essential` (or `pacman -S base-devel`) |
| **`tree-sitter` CLI** | Builds grammar files for `nvim-treesitter` (`main`) | Download `tree-sitter-linux-x64.gz` from [Tree-sitter Releases](https://github.com/tree-sitter/tree-sitter/releases) into `~/.local/bin/tree-sitter` |
| **`ripgrep` (`rg`)** | Powers Telescope `live_grep` and `grep_string` | `sudo apt install -y ripgrep` or static binary in `~/.local/bin/rg` |
| **`pyright`** | Python LSP diagnostics & hover | `uv tool install pyright` (avoids outdated system Node.js) |
| **Node.js `20+` / `npm`** *(optional)* | Required only if installing JS/JSON servers like `biome` via Mason | Install LTS via [`nvm`](https://github.com/nvm-sh/nvm) |

> **Note on `apt` / `snap` conflicts:** On Ubuntu/Debian servers, remove outdated system packages (`sudo apt remove neovim`) or ensure `~/.local/bin` appears before `/usr/bin` in `$PATH`.

## Manual Setup

1. **Clone this repository:**
   ```bash
   git clone [https://github.com/zlukich/nvimi.git](https://github.com/zlukich/nvimi.git) ~/.config/nvim
   ```

2. **Install `packer.nvim`:**
   ```bash
   git clone --depth 1 [https://github.com/wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim) \
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
   ```

3. **Install plugins & Treesitter parsers:**
   Open `nvim` and run:
   ```vim
   :PackerSync
   :TSUpdate
   ```

4. **Verify installation:**
   ```vim
   :checkhealth vim.lsp
   :checkhealth telescope
   ```

## Repository Structure

```text
~/.config/nvim/
├── init.lua                # Entry point (loads lua/zlukich)
├── install.sh              # Automated bootstrap script
├── lua/zlukich/
│   ├── init.lua            # Core module loader
│   ├── packer.lua          # Plugin declarations (packer.nvim)
│   ├── remap.lua           # Global keybindings
│   └── set.lua             # Editor options & indentation
└── after/plugin/
    ├── lsp.lua             # Mason & native vim.lsp.config setup
    ├── treesitter.lua      # nvim-treesitter 'main' branch parser & FileType setup
    ├── telescope.lua       # Fuzzy finder keymaps
    ├── harpoon.lua         # Quick file navigation
    ├── neotree.lua         # File explorer sidebar
    ├── completions.lua     # nvim-cmp + LuaSnip setup
    ├── molten.lua          # Jupyter kernel execution & image.nvim integration
    └── ...                 # Colors, lualine, render-markdown, claudecode, undotree
```
