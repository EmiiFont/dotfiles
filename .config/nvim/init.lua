--[[

Kickstart Guide:
  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

--]]

require 'options'
require 'keymaps'
require 'lazy-plugin'

vim.o.background = 'dark' -- or "light" for light mode

vim.cmd.colorscheme 'catppuccin-macchiato'
vim.o.linebreak = true

local function configure_wrap_navigation()
  if vim.wo.wrap then
    -- Map navigation for wrapped lines
    vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '^', 'g^', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '$', 'g$', { noremap = true, silent = true })
  else
    -- Reset to default navigation
    vim.api.nvim_set_keymap('n', 'j', 'j', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'k', 'k', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '^', '^', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '$', '$', { noremap = true, silent = true })
  end
end

local function toggle_wrap()
  vim.wo.wrap = not vim.wo.wrap
  configure_wrap_navigation()
end

-- Map <leader>W to toggle word wrap and configure navigation
vim.keymap.set('n', '<leader>W', toggle_wrap, { noremap = true, silent = true })

-- Automatically run the function when the wrap option changes
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'wrap',
  callback = configure_wrap_navigation,
})

-- Run the function once on startup
configure_wrap_navigation()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
