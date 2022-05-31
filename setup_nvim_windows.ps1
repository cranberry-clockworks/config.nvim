#Requires -RunAsAdministrator

Write-Output "Install dependancies..."
choco install -y `
    neovim `    # Neovim iteself
    neovide `   # GUI client
    ripgrep `   # Fuzzy finder for telescope
    omnisharp ` # C# analyzer and linter
    llvm `      # Clang compiler for the tree-sitter
    vale        # Text style helper

$root = $(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])

Write-Output "Install vim-plug..."
Invoke-WebRequest -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
     New-Item "$root/nvim-data/site/autoload/plug.vim" -Force > $null

Write-Output "Fetching config..."
git clone https://github.com/cranberry-knight/nvim.config "$root/nvim" 2> $null

