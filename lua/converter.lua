local utils = require("nvim-docx.utils")

local M = {}

function M.check_pandoc_available()
  local handle = io.popen("pandoc --version 2>/dev/null")
  if not handle then
    return false
  end
  local result = handle:read("*a")
  handle:close()
  return result ~= nil and result ~= "" and not result:match("command not found")
end

function M.docx_to_markdown(docx_path, md_path)
  if not M.check_pandoc_available() then
    utils.notify("Pandoc is not available. Please install pandoc.", "error")
    return false
  end

  local escaped_docx = utils.escape_path(docx_path)
  local escaped_md = utils.escape_path(md_path)
  
  local cmd = string.format("pandoc %s -t markdown -o %s --extract-media=%s 2>&1", 
    escaped_docx, escaped_md, utils.escape_path(utils.get_temp_dir()))
  
  local handle = io.popen(cmd)
  if not handle then
    utils.notify("Failed to execute pandoc command", "error")
    return false
  end
  
  local output = handle:read("*a")
  local success = handle:close()
  
  if not success then
    utils.notify("Pandoc conversion failed: " .. output, "error")
    return false
  end
  
  return vim.fn.filereadable(md_path) == 1
end

function M.markdown_to_docx(md_path, docx_path)
  if not M.check_pandoc_available() then
    utils.notify("Pandoc is not available. Please install pandoc.", "error")
    return false
  end

  local escaped_md = utils.escape_path(md_path)
  local escaped_docx = utils.escape_path(docx_path)
  
  local cmd = string.format("pandoc %s -f markdown -o %s 2>&1", escaped_md, escaped_docx)
  
  local handle = io.popen(cmd)
  if not handle then
    utils.notify("Failed to execute pandoc command", "error")
    return false
  end
  
  local output = handle:read("*a")
  local success = handle:close()
  
  if not success then
    utils.notify("Pandoc conversion failed: " .. output, "error")
    return false
  end
  
  return vim.fn.filereadable(docx_path) == 1
end