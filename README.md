# Requirements for Windows

1. Plugin manager `vim-plug`.

    ```PowerShell

    iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
        ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force

    ```

2. `clang`
    Used to compile tree-sitter objects.
    https://github.com/llvm/llvm-project/releases/

3. `ripgrep`
    As provider for `telescope` plugin fuzzy search.
    https://github.com/BurntSushi/ripgrep/releases

4. Language Servers
    1. Rust
        Compile with your own hands.
        ```Shell

        $ git clone https://github.com/rust-analyzer/rust-analyzer.git && cd rust-analyzer
        $ cargo xtask install

        ```
    2. OmniSharp-Roslyn
        https://github.com/OmniSharp/omnisharp-roslyn
