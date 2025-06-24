if vim.g.loaded_nvim_docx == 1 then
  return
end
vim.g.loaded_nvim_docx = 1

-- Create autocommand group
local augroup = vim.api.nvim_create_augroup("NvimDocx", { clear = true })

-- Handle opening .docx files
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup,
  pattern = "*.docx",
  callback = function()
    require("nvim-docx").handle_docx_open()
  end,
})

-- Handle saving converted markdown back to .docx
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  callback = function()
    require("nvim-docx").handle_docx_save()
  end,
})
