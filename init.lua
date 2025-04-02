-- Essentials
vim.cmd('language en_GB')
vim.g.bulitin_lsp = true

-- Behaviours
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect', 'popup' }
vim.o.pumheight = 15
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
        cmd = { "G", "Git", "Gdiffsplit", "Gblame", "Gpush", "Gpull" },
        keys = {
            { '<leader>dw', '<cmd>Gwrite<cr>',                   desc = '[d]iff [w]rite' },
            { '<leader>dl', '<cmd>diffget //2 | diffupdate<cr>', desc = 'Select for [d]iff from [l]eft column' },
            { '<leader>dr', '<cmd>diffget //3 | diffupdate<cr>', desc = 'Select for [d]iff from [r]ight column' }
        }
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'cranberry-knight/telescope-compiler.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
        },
        keys = {
            { '<leader>ff', function() require('telescope.builtin').find_files() end,                                          desc = '[f]ind [f]iles' },
            { '<leader>fk', function() require('telescope.builtin').keymaps() end,                                             desc = '[f]ind [k]eys' },
            { '<leader>fe', function() require('telescope').extensions.file_browser.file_browser({ path = '%:p:h<cr>', }) end, desc = 'Browse [f]iles [e]xplore around current one' },
            { '<leader>fc', function() require('telescope').extensions.file_browser.file_browser() end,                        desc = 'Browse [f]iles in [c]urrent working directory' },
            { '<leader>fb', function() require('telescope.builtin').buffers() end,                                             desc = '[f]ind [b]uffer' },
            { '<leader>fg', function() require('telescope.builtin').live_grep() end,                                           desc = '[f]ind with [g]rep' },
            { '<leader>sf', function() require('telescope.builtin').filetypes() end,                                           desc = '[s]elect [f]iletype' },
            { '<leader>sc', function() require('telescope').extensions.compiler.compiler() end,                                desc = '[s]elect [c]ompiler' },
            { '<leader>ss', function() require('telescope.builtin').spell_suggest() end,                                       desc = '[s]pell [s]uggests' },
            { '<leader>gb', function() require('telescope.builtin').git_branches() end,                                        desc = '[g]it [b]ranches' },
            { '<leader>gs', function() require('telescope.builtin').git_status() end,                                          desc = '[g]it [s]tatus' },
            { '<leader>ws', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,                       desc = 'Browse [w]orkspace [s]ymbols' },
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
                    hidden = true,
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
        "danymat/neogen",
        keys = {
            { '<leader>ng', function() require('neogen').generate() end, desc = '[N]eogen [g]enarate comment' },
        },
        opts = {
            languages = {
                cs = {
                    template = { annotation_convention = "xmldoc" }
                }
            }
        }
    },
    { 'echasnovski/mini.comment', version = '*', config = function() require('mini.comment').setup() end },
    { 'echasnovski/mini.pairs',   version = '*', config = function() require('mini.pairs').setup() end },
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
        keys = {
            { '<leader>lr', function() vim.lsp.buf.rename() end,        desc = '[l]SP [r]ename' },
            { '<leader>lf', function() vim.lsp.buf.format() end,        desc = '[l]SP [f]ormat' },
            { '<leader>ll', function() vim.diagnostic.setloclist() end, desc = 'Put [l]sp diagnostics to [l]ocation list' },
            {
                '<leader>l<del>',
                function()
                    vim.cmd('LspStop')
                    vim.diagnostic.reset()
                    vim.notify('Detached LSP servers')
                end,
                desc = '[de]tach [l]sp server'
            },
        },
        config = function()
            local lspconfig = require("lspconfig")
            local function on_attach(client, bufnr)
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
                vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true, })
            end
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({ on_attach = on_attach })
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                diagnostics = { globals = { "vim" } },
                                telemetry = { enable = false }
                            }
                        }
                    })
                end,
            })
            vim.diagnostic.config({ virtual_lines = true, })
        end
    },
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            "nvim-neotest/nvim-nio",
            'rcarriga/nvim-dap-ui',
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
                command = 'netcoredbg',
                args = { '--interpreter=vscode' },
            }

            dap.configurations.cs = {
                {
                    type = 'coreclr',
                    name = 'Launch netcoredbg',
                    request = 'launch',
                    program = function()
                        local d = require('dotnet-tools')
                        local path = d.get_debug_dll_path()
                        if path then
                            return path
                        end
                        error(
                            'Select the debug target using the :DotnetTargetDebug command first'
                        )
                    end,
                    args = function()
                        return {}
                    end,
                },
            }
        end,
        keys = {
            { '<leader>db', function() require('dap').toggle_breakpoint() end,                                    desc = 'Toggle [d]ebug [b]reakpoint' },
            { '<leader>dc', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Toggle [d]ebug breakpoint wiht [c]ondition' },
            { '<F5>',       function() require('dap').continue() end,                                             desc = 'Debug continue' },
            { '<F6>',       function() require('dap').run_last() end,                                             desc = 'Debug run last' },
            { '<leader>dt', function() require('dap').terminate() end,                                            desc = '[d]ebug [t]erminate' },
            { '<F10>',      function() require('dap').step_over() end,                                            desc = 'Debug step over' },
            { '<F11>',      function() require('dap').step_into() end,                                            desc = 'Debug step into' },
            { '<S-F11>',    function() require('dap').step_out() end,                                             desc = 'Debug step out' },
            { '<leader>do', function() require('dap').repl.open() end,                                            desc = 'Debug [o]pen repl' },
            { '<leader>du', function() require('dapui').toggle() end,                                             desc = 'Debug toggle [u]i' },
        }
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            'Issafalcon/neotest-dotnet',
        },
        opts = function()
            return {
                adapters = {
                    require('neotest-dotnet'),
                }
            }
        end,
        keys = {
            {
                '<leader>tu',
                function()
                    local nt = require('neotest')
                    nt.summary.toggle()
                    nt.output_panel.toggle()
                end,
                desc = '[t]oggle [t]est view'
            },
            { '<leader>tr', function()
                local nt = require('neotest')
                nt.output_panel.open()
                nt.run.run()
            end, '[t]est [r]un current method' },
            { '<leader>td', function()
                local nt = require('neotest')
                nt.output_panel.close()
                nt.run.run({ strategy = 'dap' })
            end, '[t]est [d]ebug current method' },
        }
    }
})



local function map(key, action, description)
    vim.keymap.set('n', key, action, { desc = description })
end

-- Reload configuration
map('<F12>', function()
    dofile(vim.env.MYVIMRC)
    require('packer').sync()
end, 'Load configuration again')

-- Generic
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

require('dotnet-tools').setup()
