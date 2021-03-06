" Cameron Lane's .vimrc customization file
" Last change: 2020-08-30
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" Plugins
call plug#begin('~/.vim/plugged')
    Plug 'airblade/vim-gitgutter'
    Plug 'cespare/vim-toml'
    Plug 'dbakker/vim-lint' " lints vimrc
    Plug 'edkolev/tmuxline.vim'
    Plug 'ekalinin/Dockerfile.vim'
    Plug 'fatih/vim-go', {'tag': '*' , 'do': ':GoInstallBinaries'}
    Plug 'flazz/vim-colorschemes'
    Plug 'hashivim/vim-terraform', {'for': 'terraform'}
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'lepture/vim-jinja'
    Plug 'mattn/gist-vim' | Plug 'mattn/webapi-vim' " dependencies are expressed like this
    Plug 'maxmellon/vim-jsx-pretty'
    Plug 'pangloss/vim-javascript'
    Plug 'rust-lang/rust.vim', {'for': 'rust'}
    Plug 'Rykka/riv.vim', {'for': 'rst'}
    Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' | Plug 'Valloric/YouCompleteMe', { 'dir': '~/.vim/plugged/YouCompleteMe', 'do': './install.py' }
    Plug 'tomtom/tcomment_vim'
    Plug 'tpope/vim-fugitive'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'w0rp/ale'
call plug#end()

" Key Remappings
nnoremap <Space> <Nop>
let mapleader = "\<Space>"
" don't leave the home row
inoremap jj <Esc>
" better window navigation
nnoremap <silent> <C-h> :wincmd h<cr>
nnoremap <silent> <C-j> :wincmd j<cr>
nnoremap <silent> <C-k> :wincmd k<cr>
nnoremap <silent> <C-l> :wincmd l<cr>
" Disable highlighting
map <silent> <Leader><Leader> :noh<cr>
" Diff put/get for fugitive
nmap <Leader>u :diffput<cr>
nmap <Leader>g :diffget<cr>
" copy to system clipboard
xnoremap <Leader>y "*y
" cut to system clipboard
xnoremap <Leader>d "*d
" paste from system clibpard
nmap <Leader>p <F7>"+p<F7>
noremap <Leader>P <F7>"+P<F7>
" paste from system clibpoard
noremap <Leader>v <F7>"*p<F7>
noremap <Leader>V <F7>"*P<F7>
" fix python tracebacks
nnoremap <Leader>tb :%s/#012/\r/ge<cr>
" fix trailing whitespace
nnoremap <Leader>ws :%s/\s\+$//e<cr>
nnoremap <C-p> :Files<cr>

" Enable filetype plugins
filetype plugin on
filetype indent on

" useful for when you're working on your vimrc or using the -u option to load
" alternate vimrc
set nocompatible

" Appearance & Fonts
syntax enable                           " If using a dark background within the editing area and syntax highlighting
set background=dark                     " set a dark background
colorscheme solarized
" these make colors on windows & prompt terminals correct
" let g:solarized_termcolors=256
" set term=xterm-256color
" set t_ut=

" Also switch on highlighting the last used search pattern.
if &t_Co > 4 || has("gui_running")
    syntax on                           " Switch syntax highlighting on, when the terminal has colors
    set hlsearch                        " highlight when searching
    set guifont=Liberation_Mono_for_Powerline:h10 " if using gui, make sure powerline fonts are available
endif

" General Editor settings
set encoding=utf-8                      " always work with unicode files
set fileencoding=utf-8                  " always work with unicode files
set backspace=indent,eol,start          " allow backspacing over everything in insert mode
set history=50                          " keep 50 lines of command line history
set ruler                               " show the cursor position all the time
set showcmd                             " display incomplete commands
set incsearch                           " do incremental searching
set spell                               " check spelling by default.
set showmatch                           " Show matching brackets.
set incsearch                           " Incremental search
set autowrite                           " Automatically save before commands like :next and :make
set number                              " Enable line numbers by default
set relativenumber                      " Enable relative line numbers by default
set tabstop=4 shiftwidth=4 expandtab    " prefer spaces over tabs
set laststatus=2                        " always show status bar (helpful for airline)
set pastetoggle=<F7>                    " set the pastetoggle to F7
set clipboard=unnamed                   " use systemclipboard

" FileType specific settings
" au FileType python set colorcolumn=80   " add an 80 char bg highlight
" set 2 space tabs for the following filetypes
autocmd FileType ruby,haml,eruby,yaml,sass,cucumber,javascript,html set ai sw=2 sts=2 et
" highlight json as though it were JS
autocmd BufNewFile,BufRead *.json setlocal ft=javascript
" the following extensions should be treated like ruby
autocmd BufNewFile,BufRead {Gemfile,VagrantFile,*.pp} set ft=ruby
" cython files should be treated like python
autocmd BufNewFile,BufRead *.pyx setlocal ft=python
" Go uses tabs not spaces
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal tabstop=4


" set persistent undo
if has('persistent_undo')
    set undodir=$HOME/.vim/undo
    set undolevels=10000
    set undofile
endif

noremap <F8> :! make<cr>

" Go vim specific bindings
au FileType go nmap <Leader>gr <Plug>(go-run)
au FileType go nmap <Leader>gb <Plug>(go-build)
au FileType go nmap <Leader>gt <Plug>(go-test)
au FileType go nmap <Leader>gc <Plug>(go-coverage)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

" Rust vim specific bindings
au FileType rust nmap <Leader>rr <Plug>(rust-run)
au FileType rust nmap <Leader>rb <Plug>(rust-build)
au FileType rust nmap <Leader>rt :RustTest<cr>
au FileType rust nmap <Leader>rc <Plug>(rust-coverage)
au FileType rust nmap <Leader>rd <Plug>(rust-doc)
" Plugin specific values

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_iminsert = 1
let g:airline_powerline_fonts = 1
let g:airline_section_z = '%3l/%L:%2c'
" let g:airline#extensions#tmuxline#enabled = 0

" tmuxline
" let g:tmuxline_powerline_separators = 0

" vim-gist
let g:gist_post_private = 1
let g:gist_show_privates = 1
" let g:gist_api_url = 'https://my_company.com/api/v3'
let g:gist_use_password_in_gitconfig = 0
if executable('pbcopy')
    let g:gist_clip_command = 'pbcopy'
endif
if executable('xclip')
    let g:gist_clip_command = 'xclip'
endif

let g:gist_curl_options= '-Lv'

" highlight trailing whitespace in any filetype
hi ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" format with goimports instead of gofmt
let g:go_fmt_command = substitute(expand(system('which goimports')), '\n', '', '')

" ALE https://github.com/w0rp/ale
let g:ale_python_flake8_executable = substitute(expand(system('which pylint')), '\n', '', '')
let g:ale_nodejs_eslint_executable = substitute(expand(system('which eslint')), '\n', '', '')
let g:ale_completion_enabled = 0
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint', 'prettier'],
\}
let g:ale_fix_on_save = 1
" nmap <silent> <C-p> <Plug>(ale_previous_wrap)
" nmap <silent> <C-n> <Plug>(ale_next_wrap)
"
let g:terraform_align = 1
let g:terraform_fold_sections = 1
let g:terraform_remap_spacebar = 1
let g:terraform_fmt_on_save = 1

":help :RustFmt
let g:rustc_command = substitute(expand(system('asdf which rustc')), '\n', '', '')
let g:rust_clip_command = 'xclip -selection clipboard'
let g:rustfmt_command = substitute(expand(system('asdf which rustfmt')), '\n', '', '')
let g:rustfmt_autosave = 1
let g:rustfmt_emit = 1
let g:rustfmt_fail_silently = 0

let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsListSnippets="<C-S-Space>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everythingin the .git/ folder)
" --color: Search color options
" command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color "always"'.shellescape(<q-args>), 1, <bang>0)
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
