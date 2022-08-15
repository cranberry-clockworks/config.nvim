local M = {}

function M.setup()
    require('mason-tool-installer').setup {
        ensure_installed = {
            'vale',
            'prettier',
            'netcoredbg',
        },
        auto_update = true,
        run_on_start = true
    }
end

return M
