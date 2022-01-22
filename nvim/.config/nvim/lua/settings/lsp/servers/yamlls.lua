local M = {}

M.opts = {
  filetypes = { "yaml", "yml" },
  settings = {
    yaml = {
      completion = true,
      customTags = {
        "!And",
        "!If",
        "!Not",
        "!Equals",
        "!Equals sequence",
        "!Or",
        "!FindInMap sequence",
        "!Base64",
        "!Cidr",
        "!Ref",
        "!Sub",
        "!GetAtt",
        "!GetAZs",
        "!ImportValue",
        "!Select",
        "!Select sequence",
        "!Split",
        "!Join sequence"
      },
      format = {
        enable = true,
      },
      hover = true,
      validate = true,
    }
  },
}

return M

