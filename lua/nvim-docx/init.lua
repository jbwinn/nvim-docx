local converter = require("nvim-docx.converter")
local config = require("nvim-docx.config")
local utils = require("nvim-docx.utils")

local M = {}

function M.setup(opts)
  return config.setup(opts)
end

function M.handle_docx_open()
  local docx_path = vim.fn.expand("%:p")
  
  if not utils.is_docx_file(docx_path) then
    return
  end

  if not vim.fn.filereadable(docx_path) then
    utils.notify("DOCX file not readable: " .. docx_path, "error")
    return
  end

  -- Create temporary markdown file
  local temp_md = utils.create_temp_md_file()
  
  -- Convert DOCX to Markdown
  local success = converter.docx_to_markdown(docx_path, temp_md)
  if not success then
    utils.notify("Failed to convert DOCX to Markdown: " .. docx_path, "error")
    return
  end

  -- Read the converted markdown content
  local content = vim.fn.readfile(temp_md)
  if not content then
    utils.notify("Failed to read converted markdown file", "error")
    utils.cleanup_temp_file(temp_md)
    return
  end

  -- Clear current buffer and set the markdown content
  vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
  
  -- Set buffer metadata to track the conversion
  vim.b.nvim_docx_original_path = docx_path
  vim.b.nvim_docx_temp_md = temp_md
  vim.b.nvim_docx_active = true
  
  -- Set buffer as modified to reflect we're working with converted content
  vim.bo.modified = false
  vim.bo.filetype = "markdown"
  
  -- Clean up temp file if auto_cleanup is enabled
  if config.options.auto_cleanup then
    utils.cleanup_temp_file(temp_md)
    vim.b.nvim_docx_temp_md = nil
  end

  utils.notify("DOCX file converted to Markdown for editing", "info")
end

function M.handle_docx_save()
  -- Only handle saves for buffers that were converted from DOCX
  if not vim.b.nvim_docx_active then
    return
  end

  local original_docx = vim.b.nvim_docx_original_path
  if not original_docx then
    utils.notify("No original DOCX path found", "error")
    return
  end

  -- Get current buffer content
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Create temporary markdown file with current content
  local temp_md = utils.create_temp_md_file()
  vim.fn.writefile(content, temp_md)

  -- Convert markdown back to DOCX
  local success = converter.markdown_to_docx(temp_md, original_docx)
  
  -- Clean up temporary file
  utils.cleanup_temp_file(temp_md)
  
  if success then
    utils.notify("Markdown content saved back to DOCX: " .. vim.fn.fnamemodify(original_docx, ":t"), "info")
    vim.bo.modified = false
  else
    utils.notify("Failed to save markdown back to DOCX", "error")
  end
end

return M