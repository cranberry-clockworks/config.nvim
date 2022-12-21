local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')
        .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            'git',
            'clone',
            '--depth',
            '1',
            'https://github.com/wbthomason/packer.nvim',
            install_path,
        })
        vim.cmd('packadd packer.nvim')
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    use({ 'wbthomason/packer.nvim' })
    use({
        'rebelot/kanagawa.nvim',
        config = function()
            vim.cmd('colorscheme kanagawa')
        end,
    })
    use({ 'tpope/vim-fugitive' })
    use({ 'tpope/vim-surround' })
    use({
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').compilers = { 'clang' }
            require('nvim-treesitter.install').update({ with_sync = true })()
        end,
        config = function()
            require('nvim-treesitter.configs').setup({
                auto_install = true,
                highlight = {
                    enable = true,
                },
            })
        end,
    })
    use({
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'cranberry-knight/telescope-compiler.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
        },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
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
            })
            telescope.load_extension('compiler')
            telescope.load_extension('file_browser')
        end,
    })
    use({
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Signature
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
            { 'jose-elias-alvarez/null-ls.nvim' },
        },
        config = function()
            local lsp = require('lsp-zero')
            lsp.preset('recommended')
            lsp.set_preferences({
                sign_icons = {
                    error = 'E',
                    warn = 'W',
                    hint = 'H',
                    info = 'I',
                },
            })

            local sources = lsp.defaults.cmp_sources()
            table.insert(sources, { name = 'nvim_lsp_signature_help' })

            lsp.setup_nvim_cmp({
                sources = sources,
            })

            lsp.configure('sumneko_lua', {
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file('', true),
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            local null_ls = require('null-ls')
            null_ls.setup({
                on_attach = lsp.build_options('null-ls').on_attach,
                sources = {
                    null_ls.builtins.diagnostics.vale.with({
                        extra_args = {
                            '--config',
                            vim.fn.expand(
                                vim.opt.runtimepath:get()[1] .. '/vale.ini'
                            ),
                        },
                        extra_filetypes = { 'gitcommit' },
                    }),
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.csharpier,
                    null_ls.builtins.formatting.prettier,
                },
            })

            lsp.setup()
        end,
    })
    use({
        'rcarriga/nvim-dap-ui',
        requires = {
            'mfussenegger/nvim-dap',
        },
        config = function()
            local dap = require('dap')
            local ui = require('dapui')
            ui.setup({
                icons = {
                    expanded = '▾',
                    collapsed = '▸',
                    current_frame = '→',
                },
                controls = {
                    enabled = false,
                },
            })

            dap.listeners.after.event_initialized['dapui_config'] = function()
                ui.open({})
            end
            dap.listeners.before.event_terminated['dapui_config'] = function()
                ui.close({})
            end
            dap.listeners.before.event_exited['dapui_config'] = function()
                ui.close({})
            end

            dap.adapters.coreclr = {
                type = 'executable',
                command = vim.fn.stdpath('data')
                    .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg',
                args = { '--interpreter=vscode' },
            }

            dap.configurations.cs = {
                {
                    type = 'coreclr',
                    name = 'launch - netcoredbg',
                    request = 'launch',
                    cwd = '${workspaceFolder}',
                    program = function()
                        return vim.fn.input(
                            'Path to dll: ',
                            vim.fn.getcwd(),
                            'file'
                        )
                    end,
                },
            }
        end,
    })
    use({
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
    })
    use({
        'danymat/neogen',
        requires = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            local ng = require('neogen')
            ng.setup({
                snippet_engine = 'luasnip',
                languages = {
                    cs = {
                        template = {
                            annotation_convention = 'xmldoc',
                        },
                    },
                },
            })
        end,
    })
    use({
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup({
                options = {
                    icons_enabled = false,
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                },
            })
        end,
    })

    if packer_bootstrap then
        require('packer').sync()
    end
end)

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
vim.opt.bomb = true
vim.opt.ffs = { 'dos', 'unix' }

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro nu rnu'
vim.g.netrw_list_hide = '^\\./$'

-- Keymaps
vim.g.mapleader = ' '

local function map(key, action, description)
    vim.keymap.set('n', key, action, { desc = description })
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
