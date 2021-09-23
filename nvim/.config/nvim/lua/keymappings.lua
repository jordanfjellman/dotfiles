local map = require('helpers').map

map('n', '<Space>', '<NOP>')
map('i', 'jk', '<esc>')

map('n', '<Leader>h', ':set hlsearch!<CR>')
map('n', '<Leader>e', ':Lexplore<CR>')

-- Window Navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Indenting
map('v', '>', '>gv')
map('v', '<', '<gv')

