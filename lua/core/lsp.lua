vim.lsp.enable('clangd')
vim.lsp.enable('lua-language-server')

vim.diagnostic.config({
  virtual_text = {
    enabled = true,
    prefix = '',
    spacing = 1,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})
