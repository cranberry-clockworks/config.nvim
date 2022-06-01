local M = {}

function M.setup()
    require('nvim-treesitter.install').compilers = { "clang" }
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "rust",
            "c_sharp",
            "comment",
            "html",
            "lua",
            "python"
        },
        highlight = {
            enable = true,
        },
        indent = {
            enable = true
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = {"BufWrite", "CursorHold"}
        }
    }
end

return M
