vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

require("fjellyvim.core.globals").setup()
require("fjellyvim.core.keymaps").setup()
require("fjellyvim.core.options").setup()
require("fjellyvim.core.settings").setup()
