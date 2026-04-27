if vim.g.loaded_nvim_docx == 1 then
  return
end
vim.g.loaded_nvim_docx = 1

-- Prevent Neovim's default zipPlugin from taking over .docx files
vim.g.zipPlugin_ext = '*.zip,*.jar,*.xpi,*.ja,*.war,*.ear,*.cel,*.apk,*.zpak,*.dirac,*.bz2,*.gz,*.xz,*.zst,*.tar,*.tgz,*.tbz,*.txz,*.tzst,*.docm,*.dotm,*.dotx,*.ear,*.epub,*.gox,*.idml,*.ipa,*.jar,*.kmz,*.nupkg,*.oxt,*.pk3,*.ps3,*.scz,*.smd,*.swz,*.vtx,*.war,*.xpi,*.xps'

-- Create autocommand group
local augroup = vim.api.nvim_create_augroup("NvimDocx", { clear = true })

-- Handle opening .docx files
vim.api.nvim_create_autocmd("BufReadCmd", {
  group = augroup,
  pattern = "*.docx",
  callback = function()
    require("nvim-docx").handle_docx_open()
  end,
})

-- Handle saving converted markdown back to .docx
vim.api.nvim_create_autocmd("BufWriteCmd", {
  group = augroup,
  pattern = "*.docx",
  callback = function()
    require("nvim-docx").handle_docx_save()
  end,
})
