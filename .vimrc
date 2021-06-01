source $VIMRUNTIME/defaults.vim " Source the defaults

let &t_ut=''              " https://sw.kovidgoyal.net/kitty/faq.html
set background=dark

filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]
set nocompatible          " get rid of Vi compatibility mode. SET FIRST!
set t_Co=256              " enable 256-color mode.
set nohlsearch            " Don't continue to highlight searched phrases.
set incsearch             " But do highlight as you type your search.
set autoindent            " auto-indent
set tabstop=2             " tab spacing
set shiftwidth=0          " indent/outdent by 4 columns
set shiftround            " always indent/outdent to the nearest tabstop
set smarttab              " use tabs at the start of a line, spaces elsewhere
set relativenumber        " Relative line numbering
set mouse=a               " enable mouse in all modes
set fileencoding=utf-8
set fileformat=unix
set foldmethod=syntax

highlight LanguageClientWarning ctermbg=DarkMagenta
highlight LanguageClientError   ctermbg=DarkRed
highlight ALEWarning ctermbg=DarkMagenta
highlight ALEError   ctermbg=DarkRed


" let g:hardtime_default_on = 1
let g:rust_recommended_style=0
let g:vista#renderer#enable_icon = 1
" let g:airline_theme = 'powerlineish'
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:ale_completion_enabled = 1
" let g:ale_rust_analyzer_executable = '/home/ecarroll/.local/bin/rust-analyzer'
" let g:ale_rust_rustfmt_executable  = '/home/ecarroll/.cargo/bin/rustfmt'
" let g:ale_fix_on_save = 1
" set omnifunc=ale#completion#OmniFunc
" let g:ale_set_highlights = 0
" let g:ale_fixers = {
" \   '*': ['remove_trailing_lines', 'trim_whitespace'],
" \   'javascript': ['eslint'],
" \   'rust': ['rustfmt']
" \}
" 
" let g:ale_rust_analyzer_config = {
" \  'rust': {
" \    'all_targets': 1,
" \    'build_on_save': 1,
" \  }
" \}
" 
" let g:ale_linters = {
" \  'perl': ['perl','perlcritic'],
" \  'rust': ['analyzer']
" \}

" let g:ale_perl_perl_options = '-c -Mwarnings -Ilib -It/lib'
" let g:airline#extensions#ale#enabled = 1

"  \ 'rust': ['rustup', 'run', 'stable', 'rust-analyzer'],
let g:LanguageClient_serverCommands = {
  \ 'rust': ['rust-analyzer'],
	\ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
	\ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
	\ 'python': ['/usr/local/bin/pyls'],
	\ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
	\ }


call plug#begin('~/.vim/plugged')
	" Plug 'vim-airline/vim-airline'
	" Plug 'vim-airline/vim-airline-themes'
	Plug 'liuchengxu/vista.vim'
	Plug 'vim-scripts/vis'
	Plug 'edkolev/promptline.vim'
	Plug 'edkolev/tmuxline.vim'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-surround'
	Plug 'takac/vim-hardtime'
	Plug 'junegunn/vim-easy-align'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'scrooloose/nerdtree'
	"Plug 'dense-analysis/ale'
	Plug 'autozimu/LanguageClient-neovim', {
		\ 'branch': 'next',
		\ 'do': 'bash install.sh',
		\ }
call plug#end()

" note that if you are using Plug mapping you should not use `noremap` mappings.
nmap <F5> <Plug>(lcn-menu)
nmap <silent>K <Plug>(lcn-hover)
nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> <F2> <Plug>(lcn-rename)

nnoremap <F2> :TagbarToggle<CR>
nnoremap <F3> :SyntasticToggleMode<CR>
nnoremap <F4> :HardTimeToggle<CR>
" nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
set pastetoggle=<F12>
inoremap <C-s> <esc>:w<cr>                 " save files
nnoremap <C-s> :w<cr>

" :%s/\(\S.*\)\@<! //g

autocmd BufNewFile,BufRead *.t   set filetype=perl
autocmd BufNewFile,BufRead *.asm set filetype=nasm
autocmd FileType typescript setlocal suffixesadd+=.ts,.mjs expandtab
autocmd FileType rust       autocmd  BufWritePre <buffer> call LanguageClient#textDocument_formatting_sync()
" autocmd BufWritePre rust call LanguageClient#textDocument_formatting_sync()

" autocmd BufNewFile,BufRead *.rs  set filetype=rust
