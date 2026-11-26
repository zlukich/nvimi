#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/zlukich/nvimi.git"
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"
PACKER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/packer/start/packer.nvim"

mkdir -p "$LOCAL_BIN" "$LOCAL_OPT"

echo "==> 1. Ensuring ~/.local/bin is in PATH..."
for rc in "$HOME/.bashrc" "$HOME/.profile" "$HOME/.zshrc"; do
  if [ -f "$rc" ] && ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$rc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc"
  fi
done
export PATH="$LOCAL_BIN:$PATH"

echo "==> 2. Installing latest Neovim (x86_64 Linux)..."
curl -fL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz" -o /tmp/nvim-linux-x86_64.tar.gz
rm -rf "$LOCAL_OPT/nvim-linux-x86_64"
tar -C "$LOCAL_OPT" -xzf /tmp/nvim-linux-x86_64.tar.gz
ln -sf "$LOCAL_OPT/nvim-linux-x86_64/bin/nvim" "$LOCAL_BIN/nvim"
rm -f /tmp/nvim-linux-x86_64.tar.gz

echo "==> 3. Installing standalone tree-sitter CLI (required by nvim-treesitter 'main' branch)..."
curl -fL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz" | gunzip > "$LOCAL_BIN/tree-sitter"
chmod +x "$LOCAL_BIN/tree-sitter"

echo "==> 4. Installing ripgrep (required by Telescope live_grep / grep_string)..."
if ! command -v rg >/dev/null 2>&1; then
  RG_VER="14.1.1"
  curl -fL "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VER}/ripgrep-${RG_VER}-x86_64-unknown-linux-musl.tar.gz" -o /tmp/rg.tar.gz
  tar -xzf /tmp/rg.tar.gz -C /tmp
  mv "/tmp/ripgrep-${RG_VER}-x86_64-unknown-linux-musl/rg" "$LOCAL_BIN/rg"
  chmod +x "$LOCAL_BIN/rg"
  rm -rf /tmp/rg.tar.gz "/tmp/ripgrep-${RG_VER}-x86_64-unknown-linux-musl"
fi

echo "==> 5. Installing uv and Pyright (standalone runtime, avoids old system Node)..."
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
uv tool install --upgrade pyright

echo "==> 6. Cloning or updating zlukich/nvimi config..."
if [ -d "$NVIM_CONFIG_DIR/.git" ]; then
  git -C "$NVIM_CONFIG_DIR" pull --ff-only
else
  if [ -d "$NVIM_CONFIG_DIR" ]; then
    mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}.bak.$(date +%s)"
  fi
  git clone "$REPO_URL" "$NVIM_CONFIG_DIR"
fi

echo "==> 7. Bootstrapping packer.nvim..."
if [ ! -d "$PACKER_DIR" ]; then
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
fi

echo "==> 8. Syncing plugins and compiling Treesitter parsers..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'TSUpdate' -c 'sleep 10' -c 'qa!'

echo ""
echo "Done! Restart your shell (source ~/.bashrc) and launch 'nvim'."
