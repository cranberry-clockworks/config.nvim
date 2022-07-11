require('cfg.plugins')
require('cfg.essentials')
require('cfg.statusline')

local plugins = vim.fn.glob(vim.fn.stdpath('config') .. '/lua/cfg/plugin/*.lua', 0, 1)
for _, m in ipairs(plugins) do
    dofile(m)
end

require('cfg.mappings')
