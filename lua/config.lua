local M = {}

M.defaults = {
  pandoc_path = "pandoc",                                    -- Path to the pandoc executable
  temp_dir = vim.fn.stdpath("cache") .. "/nvim-docx",       -- Temporary directory for intermediate files
  auto_cleanup = true,                                       -- Automatically clean up temporary files after processing
  debug = false,                                             -- Enable debug mode for verbose logging
}

M.options = M.defaults

function M.setup(opts)
  -- Merge user options with defaults
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  -- Validate pandoc availability
  local converter = require("nvim-docx.converter")
  if not converter.check_pandoc_available() then
    vim.api.nvim_err_writeln("nvim-docx: Pandoc is not available. Please install pandoc.")
    return false
  end
  
  -- Ensure temp directory exists
  local utils = require("nvim-docx.utils")
  utils.ensure_temp_dir()
  
  return true
end