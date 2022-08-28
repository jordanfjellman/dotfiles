local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
if not has_autopairs then
  return
end
autopairs.setup()
