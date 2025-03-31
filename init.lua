-- Essentials
vim.cmd('language en_GB')
vim.g.bulitin_lsp = true

-- Behaviours
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.hidden = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false
vim.opt.title = true
vim.opt.scrolloff = 8
vim.g.syntax_on = true
vim.cmd('filetype plugin indent on')

-- Seraching
vim.opt.grepprg = 'rg --vimgrep --smart-case --no-heading'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Indentation
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Appearance
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

-- Show invisibles
vim.opt.list = true
vim.opt.listchars = {
    tab = '▷ ',
    trail = '·',
    precedes = '«',
    extends = '»',
}

-- Encoding and endings
vim.opt.encoding = 'utf-8'
vim.opt.bomb = false
vim.opt.ffs = { 'unix', 'dos' }

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro nu rnu'
vim.g.netrw_list_hide = '^\\./$'

-- Keymaps
vim.g.mapleader = ' '

-- Lazy bootstrap
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

require("lazy").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            auto_install = true,
            ensure_installed = { "lua", },
            highlight = { enable = true },
            indent = { enable = true },
        }
    },
    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git", "Gdiffsplit", "Gblame", "Gpush", "Gpull" }
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'cranberry-knight/telescope-compiler.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
        },
        opts = {
            defaults = {
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case',
                    '--trim',
                },
            },
            pickers = {
                find_files = {
                    previewer = false,
                },
                buffers = {
                    previewer = false,
                    mappings = {
                        i = { ['<c-w>'] = 'delete_buffer' },
                        n = { ['<c-w>'] = 'delete_buffer' },
                    },
                },
            },
            extensions = {
                file_browser = {
                    previewer = false,
                    theme = 'ivy',
                    dir_icon = '■',
                    grouped = true,
                },
            },
        }
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'kyazdani42/nvim-web-devicons'
        },
        opts = {
            options = {
                icons_enabled = false,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
        }
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "mason.nvim",
        opts = {
            ensure_installed = {
                "lua_ls",
            }
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "mason-lspconfig.nvim" },
        config = function()
            -- Set up LSP servers installed via Mason
            local lspconfig = require("lspconfig")
            require("mason-lspconfig").setup_handlers({
                -- default handler (for servers with default config)
                function(server_name)
                    lspconfig[server_name].setup({ on_attach = on_attach, capabilities = capabilities })
                end,
                -- custom setup for specific servers (example: Lua)
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                diagnostics = { globals = { "vim" } }, -- recognize `vim` global
                                telemetry = { enable = false }
                            }
                        }
                    })
                end,
            })
            -- Diagnostic config (for example, disable virtual text)
            vim.diagnostic.config({ virtual_text = true, float = { border = "rounded" } })
        end
    },
})

local function map(key, action, description)
    vim.keymap.set('n', key, action, { desc = description })
end

function on_attach(client, bufnr)
    -- Enable omnifunc for builtin completion
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- Enable built-in LSP completions (Neovim 0.11+)
    vim.lsp.completion.enable() -- now LSP suggestions will auto-show in completion menu

    -- Keymaps for LSP actions (buffer-local)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    -- etc. (add more as desired)
end

-- Reload configuration
map('<F12>', function()
    dofile(vim.env.MYVIMRC)
    require('packer').sync()
end, 'Load configuration again')

-- Generic
map('<leader>n', '<cmd>nohlsearch<cr>', '[n]o highlight search')

map('<leader>tsc', function()
    if vim.wo.spell then
        vim.wo.spell = false
        vim.notify('Disable spellcheck')
        return
    end

    vim.wo.spell = true
    vim.bo.spelllang = 'en,ru'
    vim.notify('Enable spellcheck')
end, '[t]oggle [s]pell [c]heck')

map('<leader>thw', function()
    local width = vim.call('input', 'Enter new hard wrap text width: ')
    vim.opt.wrap = false
    vim.opt.textwidth = tonumber(width)
    vim.opt.colorcolumn = tostring(width)
end, '[t]oggle [h]ard [w]rap')

map('<leader>tsw', function()
    vim.opt.textwidth = tonumber(0)
    vim.opt.colorcolumn = tostring(0)
    vim.cmd('set wrap!')
    vim.notify('Enable text soft wrap')
end, '[t]oggle [s]oft [w]rap')

-- Telescope
map('<leader>ff', require('telescope.builtin').find_files, '[f]ind [f]iles')
map('<leader>fk', require('telescope.builtin').keymaps, '[f]ind [k]eys')
map('<leader>fe', function()
    require('telescope').extensions.file_browser.file_browser({
        path = '%:p:h<cr>',
    })
end, 'Browse [F]iles [E]xplore around current one')
map(
    '<leader>fc',
    require('telescope').extensions.file_browser.file_browser,
    'Browse [f]iles in [c]urrent working directory'
)
map('<leader>fb', require('telescope.builtin').buffers, '[f]ind [b]uffer')
map('<leader>fg', require('telescope.builtin').live_grep, '[f]ind with [g]rep')
map('<leader>sf', require('telescope.builtin').filetypes, '[s]elect [f]iletype')
map(
    '<leader>sc',
    require('telescope').extensions.compiler.compiler,
    '[s]elect [c]ompiler'
)
map(
    '<leader>ss',
    require('telescope.builtin').spell_suggest,
    '[s]pell [s]uggests'
)
map('<leader>gb', require('telescope.builtin').git_branches, '[g]it [b]ranches')
map('<leader>gs', require('telescope.builtin').git_status, '[g]it [s]tatus')
map(
    '<leader>ws',
    require('telescope.builtin').lsp_dynamic_workspace_symbols,
    'Browse [w]orkspace [s]ymbols'
)

-- LSP
map('<leader>lr', vim.lsp.buf.rename, '[l]SP [r]ename')
map('<leader>lf', vim.lsp.buf.format, '[l]SP [f]ormat')
map(
    '<leader>ll',
    vim.diagnostic.setloclist,
    'Put [l]sp diagnostics to [l]ocation list'
)
map('<leader>l<del>', function()
    vim.cmd('LspStop')
    vim.diagnostic.reset()
    vim.notify('Detached LSP servers')
end, '[de]tach [l]sp server')

-- DAP
map(
    '<leader>db',
    require('dap').toggle_breakpoint,
    'Toggle [d]ebug [b]reakpoint'
)
map('<leader>dc', function()
    require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, 'Toggle [d]ebug breakpoint wiht [c]ondition')

map('<F5>', require('dap').continue, 'Debug continue')
map('<F6>', require('dap').run_last, 'Debug run last')
map('<leader>dt', require('dap').terminate, '[d]ebug [t]erminate')
map('<F10>', require('dap').step_over, 'Debug step over')
map('<F11>', require('dap').step_into, 'Debug step into')
map('<S-F11>', require('dap').step_out, 'Debug step out')

map('<leader>do', require('dap').repl.open, 'Debug [o]pen repl')
map('<leader>du', require('dapui').toggle, 'Debug toggle [u]i')

-- Neotest
map('<leader>tu', function()
    local nt = require('neotest')
    nt.summary.toggle()
    nt.output_panel.toggle()
end, '[t]oggle [t]est view')
map('<leader>tr', function()
    local nt = require('neotest')
    nt.output_panel.open()
    nt.run.run()
end, '[t]est [r]un current method')
map('<leader>td', function()
    local nt = require('neotest')
    nt.output_panel.close()
    nt.run.run({ strategy = 'dap' })
end, '[t]est [d]ebug current method')

-- Quickfix list
map('<leader>cn', '<cmd>cnext<cr>', 'Select [n]ext item in the quickfix list')
map(
    '<leader>cp',
    '<cmd>cprev<cr>',
    'Select [p]revious item in the quickfix list'
)
map('<leader>co', '<cmd>copen<cr>', '[o]pen the quickfix list')
map('<leader>cc', '<cmd>cclose<cr>', '[c]lose the quickfix list')

-- Location list
map('<leader>ln', '<cmd>lnext<cr>', 'Select [n]ext item in the [l]ocal list')
map(
    '<leader>lp',
    '<cmd>lprev<cr>',
    'Select [p]revious item in the [l]ocal list'
)
map('<leader>lo', '<cmd>lopen<cr>', '[o]pen the [l]ocal list')
map('<leader>lc', '<cmd>lclose<cr>', '[c]lose the [l]ocal list')

-- Diff
map('<leader>dw', '<cmd>Gwrite<cr>', '[d]iff [w]rite')
map(
    '<leader>dl',
    '<cmd>diffget //2 | diffupdate<cr>',
    'Select for [d]iff from [l]eft column'
)
map(
    '<leader>dr',
    '<cmd>diffget //3 | diffupdate<cr>',
    'Select for [d]iff from [r]ight column'
)

require('dotnet-tools').setup()
