require('cfg.plugins')
require('cfg.essentials')
require('cfg.statusline')

local plugins = vim.fn.glob('./lua/cfg/plugin/*.lua', 0, 1)
for _, m in ipairs(plugins) do
    m = string.gsub(m, '[\\/]', '.')
    m = string.gsub(m, '^%.%.lua%.', '')
    m = string.gsub(m, '%.lua$', '')
    require(m)
end

require('cfg.mappings')
