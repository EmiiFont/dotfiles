-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

--- create autocmd to toggle transparency of nvim
vim.cmd([[
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight NeoTreeNormal ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight NormalNC ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight NeoTreeNormalNC ctermbg=NONE guibg=NONE
]])
