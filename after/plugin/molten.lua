-- Jupyter notebook support: molten-nvim (kernel execution) + image.nvim
-- (inline plots) + jupytext (.ipynb <-> plain text) + quarto/otter (LSP in
-- code cells).
--
-- One-time setup after installing the plugins:
--   1. pip install pynvim jupyter jupyter_client
--   2. sudo apt install imagemagick libmagickwand-dev   (for image.nvim)
--   3. :PackerSync  then  :UpdateRemotePlugins  then restart nvim
--
-- These guards keep nvim from erroring if the plugins aren't installed yet.
local ok_image = pcall(require, "image")
if not ok_image then
    return
end

-- Inline images. Ghostty implements the kitty graphics protocol, so we drive
-- it through the "kitty" backend (there is no separate "ghostty" backend).
require("image").setup({
    backend = "kitty",
    integrations = {
        markdown = {
            enabled = true,
            only_render_image_at_cursor = true,
        },
    },
    max_width = 100,
    max_height = 12,
    max_height_window_percentage = math.huge,
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
})

-- image.nvim draws into the terminal's kitty-graphics layer. If nvim exits
-- while a molten plot is shown, the image can "freeze" onto the terminal.
-- Wipe all images before leaving, and on suspend, to avoid ghosting.
local function clear_images()
    pcall(function()
        require("image").clear()
    end)
end
vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
    callback = clear_images,
})

-- Open/save .ipynb as markdown-style plain text.
local ok_jupytext, jupytext = pcall(require, "jupytext")
if ok_jupytext then
    jupytext.setup({
        style = "markdown",
        output_extension = "md",
        force_ft = "markdown",
    })
end

-- Molten globals. Must be set before the remote plugin initializes, which is
-- why they live here in after/plugin (runs at startup, before any :Molten cmd).
vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20
vim.g.molten_auto_open_output = false
vim.g.molten_wrap_output = true
vim.g.molten_virt_text_output = true
vim.g.molten_virt_lines_off_by_1 = true

-- Keymaps under <leader>m (m = molten) to avoid clashing with the <leader>e*
-- Go error snippets in remap.lua.
local map = vim.keymap.set
-- Auto-detect the project's .venv and launch the Jupyter kernel from it, so
-- cells run with the project's packages. Falls back to the plain kernel picker
-- when no venv is found.
--
-- Each project's .venv must have ipykernel installed once:
--     .venv/bin/pip install ipykernel
local function find_venv_python()
    -- Prefer an already-activated venv (your shell shows "(.venv)").
    local active = os.getenv("VIRTUAL_ENV")
    if active and vim.fn.executable(active .. "/bin/python") == 1 then
        return active .. "/bin/python", active
    end
    -- Otherwise walk up from the current file looking for a .venv directory.
    local start = vim.fn.expand("%:p:h")
    if start == "" then
        start = vim.fn.getcwd()
    end
    local hits = vim.fs.find(".venv", { path = start, upward = true, type = "directory" })
    if hits[1] and vim.fn.executable(hits[1] .. "/bin/python") == 1 then
        return hits[1] .. "/bin/python", hits[1]
    end
    return nil
end

local function molten_init_venv()
    local py, venv = find_venv_python()
    if not py then
        vim.notify("No .venv found - opening kernel picker", vim.log.levels.WARN)
        vim.cmd("MoltenInit")
        return
    end

    -- The kernel process needs ipykernel from inside the venv.
    vim.fn.system({ py, "-c", "import ipykernel" })
    if vim.v.shell_error ~= 0 then
        vim.notify("ipykernel missing in venv. Run:  " .. venv .. "/bin/pip install ipykernel", vim.log.levels.ERROR)
        return
    end

    -- Name the kernelspec after the project folder (parent of .venv).
    local project = vim.fn.fnamemodify(venv, ":h:t")
    local kernel = "venv-" .. project:gsub("[^%w_-]", "_")
    local spec_dir = vim.fn.expand("~/.local/share/jupyter/kernels/") .. kernel

    -- Register the kernelspec on demand (idempotent: only if missing).
    if vim.fn.isdirectory(spec_dir) == 0 then
        vim.fn.system({
            py, "-m", "ipykernel", "install", "--user",
            "--name", kernel, "--display-name", "Python (" .. project .. ")",
        })
        if vim.v.shell_error ~= 0 then
            vim.notify("Failed to register kernel for " .. project, vim.log.levels.ERROR)
            return
        end
    end

    -- jupyter_client writes the kernel connection file here; if the dir is
    -- missing the kernel fails to launch ("No such file ... runtime/kernel-*.json").
    vim.fn.mkdir(vim.fn.expand("~/.local/share/jupyter/runtime"), "p")

    vim.cmd("MoltenInit " .. kernel)
    vim.notify("Molten kernel: " .. kernel .. "  (" .. py .. ")", vim.log.levels.INFO)
end

map("n", "<leader>mi", molten_init_venv, { desc = "Molten: init kernel from project .venv", silent = true })
-- Plain picker if you ever want to choose a different kernel manually.
map("n", "<leader>mI", "<cmd>MoltenInit<cr>", { desc = "Molten: init (pick kernel)", silent = true })
map("n", "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", { desc = "Molten: evaluate operator", silent = true })
map("n", "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", { desc = "Molten: evaluate line", silent = true })
map("n", "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", { desc = "Molten: re-evaluate cell", silent = true })
map("v", "<leader>m", ":<C-u>MoltenEvaluateVisual<cr>gv", { desc = "Molten: evaluate selection", silent = true })
map("n", "<leader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>", { desc = "Molten: enter output", silent = true })
map("n", "<leader>mh", "<cmd>MoltenHideOutput<cr>", { desc = "Molten: hide output", silent = true })
map("n", "<leader>md", "<cmd>MoltenDelete<cr>", { desc = "Molten: delete cell", silent = true })
map("n", "<leader>mC", clear_images, { desc = "Molten: clear stuck inline images", silent = true })

-- Quarto / otter: turn on LSP + completion inside code cells when editing a
-- notebook (markdown/quarto buffers).
local ok_quarto, quarto = pcall(require, "quarto")
if ok_quarto then
    quarto.setup({
        lspFeatures = {
            enabled = true,
            languages = { "python" },
            chunks = "all",
        },
        -- Send cells to molten (not vim-slime, which isn't installed).
        codeRunner = {
            enabled = true,
            default_method = "molten",
            ft_runners = { python = "molten" },
        },
    })
    map("n", "<leader>mq", function()
        quarto.activate()
    end, { desc = "Molten: activate quarto LSP in cells", silent = true })

    -- Auto-activate the quarto runner + LSP for notebook buffers, so <leader>mc
    -- (run cell) works immediately without a manual <leader>mq first. Limited to
    -- .ipynb/.qmd so plain markdown notes aren't affected.
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "quarto" },
        callback = function(args)
            local name = vim.api.nvim_buf_get_name(args.buf)
            if name:match("%.ipynb$") or name:match("%.qmd$") then
                vim.schedule(function()
                    pcall(quarto.activate)
                end)
            end
        end,
    })

    -- Cell-based execution. Molten has no concept of the ```python fenced
    -- "cells" in a jupytext-markdown notebook; quarto's runner detects the
    -- code chunk under the cursor and sends it to molten.
    local ok_runner, runner = pcall(require, "quarto.runner")
    if ok_runner then
        map("n", "<leader>mc", function()
            runner.run_cell()
        end, { desc = "Molten: run current cell", silent = true })
        map("n", "<leader>ma", function()
            runner.run_above()
        end, { desc = "Molten: run cell + all above", silent = true })
        map("n", "<leader>mA", function()
            runner.run_all()
        end, { desc = "Molten: run all cells", silent = true })
    end
end
