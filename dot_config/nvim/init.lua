require("config.lazy")

vim.cmd.source("~/.vimrc")

-- https://github.com/neovim/neovim/issues/29505#issuecomment-2196156331
local bg = "#0000a3"
local fg = "#ffff4d"
local set_terminal_default_colors = "\x1b]10;" .. fg .. "\a\x1b]11;" .. bg .. "\a"
local reset_terminal_colors = "\x1b]110\a\x1b]111\a"

io.stdout:write(set_terminal_default_colors)
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = vim.api.nvim_create_augroup("KittySetNormalColors", { clear = true }),
  callback = function()
    io.stdout:write(set_terminal_default_colors)
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("KittyUnsetNormalColors", { clear = true }),
  callback = function()
    io.stdout:write(reset_terminal_colors)
  end,
})
-- end https://github.com/neovim/neovim/issues/29505#issuecomment-2196156331

-- vim.opt.termguicolors = true

-- Wrap :retab!
-- %s/\s\+$//

-- vim.cmd("filetype plugin indent on") -- filetype detection[ON] plugin[ON] indent[ON]
vim.opt.compatible = false -- get rid of Vi compatibility mode. SET FIRST!
vim.opt.hlsearch = false -- Don't continue to highlight searched phrases.
vim.opt.incsearch = true -- But do highlight as you type your search.
vim.opt.autoindent = true -- auto-indent
vim.opt.tabstop = 2 -- tab spacing
vim.opt.shiftwidth = 0 -- indent/outdent by 4 columns
vim.opt.shiftround = true -- always indent/outdent to the nearest tabstop
vim.opt.smarttab = true -- use tabs at the start of a line, spaces elsewhere
vim.opt.expandtab = false
vim.opt.softtabstop = 0
-- set relativenumber                 -- Relative line numbering
vim.opt.mouse = "a" -- enable mouse in all modes
vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.foldmethod = "syntax"
vim.opt.clipboard = "unnamedplus"

-- vim.opt.pastetoggle = "<F12>"
vim.cmd("set shortmess-=F")

-- recommended style sucks, set in ftplugin
-- /usr/share/nvim/runtime/ftplugin/rust.vim
-- Debugged to that location with verbose set et?
-- See https://stackoverflow.com/a/9105889/124486
-- vim.api.nvim_set_var("rust_recommended_style", 0)
