local M = {}

function M.setup()
    local dap = require('dap')
    local o = { silent = true, noremap = true }
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, o)
    vim.keymap.set('n', '<leader>dB',
        function ()
            dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end,
        o
    )

    vim.keymap.set('n', '<f1>', dap.continue, o)
    vim.keymap.set('n', '<f2>', dap.step_over, o)
    vim.keymap.set('n', '<f3>', dap.step_into, o)
    vim.keymap.set('n', '<f4>', dap.step_out, o)

    vim.keymap.set('n', '<leader>dr', dap.repl.open, o)

    dap.adapters.coreclr = {
        type = 'executable',
        command = vim.fn.stdpath('data')..'/netcoredbg/netcoredbg',
        args = {'--interpreter=vscode'}
    }

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
        },
    }
end

function M.setup_ui()
    local dap = require('dap')
    local ui = require('dapui')

    ui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
        ui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        ui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        ui.close()
    end

    vim.keymap.set('n', '<leader>dt', ui.toggle, { silent = true, noremap = true, })

end

return M
