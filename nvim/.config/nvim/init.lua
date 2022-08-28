require("fjellyvim.globals").setup()
require("fjellyvim.options").setup()
require("fjellyvim.plugins").setup()
require("fjellyvim.diagnostic").setup()
require("fjellyvim.diagnostic").setup_keymaps()
require("fjellyvim.theme").setup()
require("fjellyvim.lsp").setup_keymaps()

----------------------------------
-- Highlight ---------------------
----------------------------------
-- cmd([[hi! link LspCodeLens CursorColumn]])
-- cmd([[hi! link LspReferenceText CursorColumn]])
-- cmd([[hi! link LspReferenceRead CursorColumn]])
-- cmd([[hi! link LspReferenceWrite CursorColumn]])
