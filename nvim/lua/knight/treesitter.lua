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

require "nvim-treesitter.configs".setup {
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
  },
}
