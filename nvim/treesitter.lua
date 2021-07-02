require 'nvim-treesitter.install'.compilers = { "clang" }

require'nvim-treesitter.configs'.setup {
--    ensure_installed = {"rust", "c_sharp"},
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    }
}
