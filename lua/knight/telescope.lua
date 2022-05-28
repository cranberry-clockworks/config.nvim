require('telescope').setup{
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim",
        },
        results_title = '';
        preview_title = '';
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
    }
}
