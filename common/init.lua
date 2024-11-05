-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- add your plugins here
        { "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
        { "neovim/nvim-lspconfig" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/nvim-cmp" },
        {
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
            main = 'nvim-treesitter.configs', -- Sets main module to use for opts
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
            opts = {
                ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
                -- Autoinstall languages that are not installed
                auto_install = true,
                highlight = {
                    enable = true,
                    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                    --  If you are experiencing weird indenting issues, add the language to
                    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                    additional_vim_regex_highlighting = { 'ruby' },
                },
                indent = { enable = true, disable = { 'ruby' } },
            }
        },
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            -- or                              , branch = '0.1.x',
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                require("telescope").setup({})

                local builtin = require("telescope.builtin")
                vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
                vim.keymap.set("n", "<C-p>", builtin.git_files, {})
                vim.keymap.set("n", "<leader>pws", function()
                    local word = vim.fn.expand("<cword>")
                    builtin.grep_string({ search = word })
                end)
                vim.keymap.set("n", "<leader>pWs", function()
                    local word = vim.fn.expand("<cWORD>")
                    builtin.grep_string({ search = word })
                end)
                vim.keymap.set("n", "<leader>ps", function()
                    builtin.grep_string({ search = vim.fn.input("Grep > ") })
                end)
            end,
        },
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
        },
        {
            "seblj/roslyn.nvim",
            ft = "cs",
            opts = {
                exe = "Microsoft.CodeAnalysis.LanguageServer",
            },
        },
    },
    checker = { enabled = true },
})

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities =
    vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    end,
})

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})
-- Works only on nixos
local vue_language_server_path = vim.fs.joinpath(
    vim.fs.dirname(vim.fs.dirname(vim.fn.system("echo -n $(readlink -f $(which vue-language-server))"))),
    "lib/node_modules/@vue/language-server"
)
lspconfig.ts_ls.setup({
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
            },
        },
    },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})
lspconfig.volar.setup({})

-- require('lspconfig').omnisharp.setup({
-- cmd = { "OmniSharp" }
-- })

local cmp = require("cmp")

cmp.setup({
    sources = {
        { name = "nvim_lsp" },
    },
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
})

local lsp_zero = require("lsp-zero")

lsp_zero.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ["lua_ls"] = { "lua" },
    },
})

vim.cmd.colorscheme("tokyonight-night")
