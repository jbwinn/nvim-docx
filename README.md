# nvim-docx

A Neovim plugin that enables transparent editing of Microsoft Word (.docx) files by converting them to Markdown for editing and back to .docx on save.

## Features

- 📝 Open .docx files directly in Neovim
- 🔄 Automatic conversion to Markdown for editing
- 💾 Save changes back to .docx format
- 🧹 Automatic cleanup of temporary files
- ⚡ Powered by Pandoc for reliable conversion

## Requirements

- Neovim 0.7+
- [Pandoc](https://pandoc.org/) installed and available in PATH

## Installation

### Using lazy.nvim

```lua
{
  "daanh/nvim-docx",
  config = function()
    require("nvim-docx").setup({
      -- Optional configuration
      debug = false,
      auto_cleanup = true,
    })
  end,
}
```

### Using packer.nvim

```lua
use {
  "daanh/nvim-docx",
  config = function()
    require("nvim-docx").setup()
  end
}
```

## Usage

1. Simply open a `.docx` file in Neovim: `nvim document.docx`
2. The plugin automatically converts it to Markdown for editing
3. Edit the content as normal Markdown
4. Save the file (`:w`) to convert back to .docx format

## Configuration

```lua
require("nvim-docx").setup({
  pandoc_path = "pandoc",                                    -- Path to pandoc executable
  temp_dir = vim.fn.stdpath("cache") .. "/nvim-docx",       -- Temporary directory
  auto_cleanup = true,                                       -- Auto-cleanup temp files
  debug = false,                                             -- Enable debug logging
})
```

## How it Works

1. When you open a `.docx` file, the plugin intercepts the `BufReadPre` event
2. Pandoc converts the `.docx` file to Markdown format
3. The Markdown content is loaded into the Neovim buffer
4. You edit the content as normal Markdown
5. On save (`BufWritePost`), the plugin converts the Markdown back to `.docx`
6. The original `.docx` file is updated with your changes

## Limitations

- Complex Word formatting may not be perfectly preserved
- Images and media are extracted to the temp directory
- Some Word-specific features (comments, track changes) are not supported
- Conversion quality depends on Pandoc's capabilities

## Troubleshooting

### Pandoc not found
Make sure Pandoc is installed and available in your PATH:
```bash
# Check if pandoc is available
pandoc --version

# Install on Arch Linux
sudo pacman -S pandoc

# Install on Ubuntu/Debian
sudo apt install pandoc

# Install on macOS
brew install pandoc
```

## License

MIT License
