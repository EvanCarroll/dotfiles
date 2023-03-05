vim.opt.background = 'dark'
-- vim.g["&t_ut"] = ''           -- https://sw.kovidgoyal.net/kitty/faq.html
-- Wrap :retab!
-- %s/\s\+$//

vim.cmd('filetype plugin indent on')  -- filetype detection[ON] plugin[ON] indent[ON]
vim.opt.termguicolors = true
vim.opt.compatible    = false         -- get rid of Vi compatibility mode. SET FIRST!
vim.opt.hlsearch      = false         -- Don't continue to highlight searched phrases.
vim.opt.incsearch     = true          -- But do highlight as you type your search.
vim.opt.autoindent    = true          -- auto-indent
vim.opt.tabstop       = 2             -- tab spacing
vim.opt.shiftwidth    = 0             -- indent/outdent by 4 columns
vim.opt.shiftround    = true          -- always indent/outdent to the nearest tabstop
vim.opt.smarttab      = true          -- use tabs at the start of a line, spaces elsewhere
vim.opt.expandtab     = false
vim.opt.softtabstop   = 0
-- set relativenumber                 -- Relative line numbering
vim.opt.mouse         = 'a'           -- enable mouse in all modes
vim.opt.fileencoding  = 'utf-8'
vim.opt.fileformat    = 'unix'
vim.opt.foldmethod    = 'syntax'
vim.opt.clipboard     = 'unnamedplus'


vim.opt.pastetoggle   = '<F12>'
vim.cmd('set shortmess-=F')

-- recommended style sucks, set in ftplugin
-- /usr/share/nvim/runtime/ftplugin/rust.vim
-- Debugged to that location with verbose set et? 
-- See https://stackoverflow.com/a/9105889/124486
vim.api.nvim_set_var('rust_recommended_style', 0)


-- let g:hardtime_default_on = 1
-- let g:rust_recommended_style=0

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

nmap('<F2>', ':TagbarToggle<CR>')
nmap('<F3>', ':SyntasticToggleMode<CR>')
nmap('<F4>', ':HardTimeToggle<CR>')
imap('<C-s>', '<esc>:w<cr>')
nmap('<C-s>', ':w<cr>')

-- :%s/\(\S.*\)\@<! //g

require('plugins')

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

