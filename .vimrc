let &t_ut='' " https://sw.kovidgoyal.net/kitty/faq.html

color darkblue

syntax enable             " enable syntax highlighting (previously syntax on).
filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]
set rnu                   " Relative line numbering
set nocompatible          " get rid of Vi compatibility mode. SET FIRST!
set t_Co=256              " enable 256-color mode.
set nohlsearch            " Don't continue to highlight searched phrases.
set incsearch             " But do highlight as you type your search.
set autoindent            " auto-indent
set tabstop=2             " tab spacing
set shiftwidth=0          " indent/outdent by 4 columns
set shiftround            " always indent/outdent to the nearest tabstop
set smarttab              " use tabs at the start of a line, spaces elsewhere
set mouse=a               " enable mouse in all modes
set fileencoding=utf-8
set fileformat=unix

" without this, SpellBad is messed up. This causes problem with Syntastic.
" we can fix this problem otherwise by
" http://stackoverflow.com/a/6009026/124486
" or, http://stackoverflow.com/q/17677441/124486
" set background=light
" set background=dark


let g:hardtime_default_on = 1
let g:vista#renderer#enable_icon = 1
let g:airline_theme = 'powerlineish'
let g:ale_completion_enabled = 1
let g:ale_rust_analyzer_executable = '/home/ecarroll/.local/bin/rust-analyzer'
let g:ale_rust_rustfmt_executable  = '/home/ecarroll/.cargo/bin/rustfmt'
let g:ale_fix_on_save = 1
set omnifunc=ale#completion#OmniFunc

" let g:ale_rust_rustfmt_options = '--config control_brace_style=ClosingNextLine'

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'rust': ['rustfmt']
\}

let g:ale_rust_analyzer_config = {
\  'rust': {
\    'all_targets': 1,
\    'build_on_save': 1,
\  }
\}

let g:ale_linters = {
\  'perl': ['perl','perlcritic'],
\  'rust': ['analyzer']
\}

" let g:ale_perl_perl_options = '-c -Mwarnings -Ilib -It/lib'
let g:airline#extensions#ale#enabled = 1


call plug#begin('~/.vim/plugged')

Plug 'rust-lang/rust.vim'
Plug 'liuchengxu/vista.vim'
Plug 'vim-scripts/vis'
Plug 'edkolev/promptline.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'takac/vim-hardtime'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'dense-analysis/ale'

call plug#end()

set foldmethod=syntax
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END


nnoremap <F2> :TagbarToggle<CR>
nnoremap <F3> :SyntasticToggleMode<CR>
nnoremap <F4> :HardTimeToggle<CR>
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
set pastetoggle=<F12>
inoremap <C-s> <esc>:w<cr>                 " save files
nnoremap <C-s> :w<cr>

" :%s/\(\S.*\)\@<! //g

autocmd BufNewFile,BufRead *.t   set filetype=perl
autocmd BufNewFile,BufRead *.asm set filetype=nasm
autocmd FileType typescript setlocal suffixesadd+=.ts,.mjs
