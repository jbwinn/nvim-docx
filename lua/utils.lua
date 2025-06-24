local M = {}

function M.is_docx_file(filepath)
  return vim.fn.fnamemodify(filepath, ":e"):lower() == "docx"
end

function M.create_temp_md_file()
  return vim.fn.tempname() .. ".md"
end

function M.get_temp_dir()
  local config = require("nvim-docx.config")
  return config.options and config.options.temp_dir or vim.fn.stdpath("cache") .. "/nvim-docx"
end

function M.ensure_temp_dir()
  local temp_dir = M.get_temp_dir()
  if vim.fn.isdirectory(temp_dir) == 0 then
    vim.fn.mkdir(temp_dir, "p")
  end
  return temp_dir
end

function M.cleanup_temp_file(filepath)
  if filepath and vim.fn.filereadable(filepath) == 1 then
    vim.fn.delete(filepath)
  end
end

function M.notify(message, level)
  level = level or "info"
  vim.notify(message, vim.log.levels[level:upper()] or vim.log.levels.INFO)
end

function M.escape_path(path)
  -- Escape shell special characters in file paths
  return vim.fn.shellescape(path)
end