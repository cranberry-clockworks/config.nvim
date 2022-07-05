local M = {}

function M.setup()
    local dap = require('dap')
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)

    vim.keymap.set('n', '<f1>', dap.continue)
    vim.keymap.set('n', '<f2>', dap.step_over)
    vim.keymap.set('n', '<f3>', dap.step_into)

    vim.keymap.set('n', '<leader>dr', dap.repl.open)

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
