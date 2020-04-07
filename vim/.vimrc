"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins                                                                     "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible " be iMproved, required
filetype off " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'fatih/vim-go'
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'Shougo/neocomplete.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'bling/vim-airline'
Plugin 'bling/vim-bufferline'
Plugin 'tpope/vim-fugitive'
Plugin 'morhetz/gruvbox'
Plugin 'junegunn/goyo.vim'
Plugin 'Chiel92/vim-autoformat'
Plugin 'elixir-editors/vim-elixir'
Plugin 'slashmili/alchemist.vim'
Plugin 'mhinz/vim-mix-format'
Plugin 'HerringtonDarkholme/yats.vim'
Plugin 'liuchengxu/vim-which-key'

call vundle#end()
filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General viewing                                                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" colors
try
  colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
endtry

" use the mouse
set mouse=a

" fix backspace
set backspace=start,eol,indent

" make it prettier
set background=dark

" makes sure the status line displays automatically
set laststatus=2

" turn on syntax highlighting
syntax on

" set terminal title to file name
set title

" Set to auto read when a file is changed from the outside
set autoread

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Ignore case when searching
set ignorecase

" Highlight search results
set hlsearch

" Search each letter as you type
set incsearch

" Automatically display line number
set number

" word wrapping
set wrap
set linebreak

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General code writing                                                        "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" fold based on indent
set foldmethod=indent

" dont fold by default
set nofoldenable

" set commentary comment types
autocmd FileType python set commentstring=#\ %s
autocmd FileType ruby set commentstring=#\ %s

" auto close the omnicomplete window
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Show and clear all extraneous whitespace automatically
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd BufWritePre * :%s/\s\+$//e

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key maps                                                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set the leader to the Space key
let mapleader = " "

" map ; to be the same thing as : in normal mode
nnoremap ; :

" write on capital W
command! W  write

" toggle spell checking
map <leader>s <nop>
map <leader>s :set spell!<CR>

" Remap VIM 0 to first non-blank character
map 0 ^

" toggle line numbers
map <leader>l :set number!<CR> :set foldcolumn=0<CR>

" turn on spell checking
map <leader>p :set paste!<CR>

set smartindent

" autoindent copies the indentation from the previous line,
set autoindent

" tabstop changes the width of the tab character
set tabstop=2
au BufEnter,BufNew *.py set tabstop=4

" expandtab inserts spaces whenever the tab key is pressed
set expandtab
autocmd FileType go set noexpandtab
autocmd FileType markdown set noexpandtab

" shiftwidth changes the number of space characters inserted for indentation
set shiftwidth=2
au BufEnter,BufNew *.py set shiftwidth=4

" softtabstop makes the backspace key treat the four spaces like a tab
set softtabstop=2
au BufEnter,BufNew *.py set softtabstop=4

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim artifact files                                                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set permanent undo files
set undofile

" maximum number of changes that can be undone
set undolevels=1000

" maximum number lines to save for undo on a buffer reload
set undoreload=10000

" Don't drop swap and undo files all over the place
set directory=~/.vim/tmp
set undodir=~/.vim/tmp

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic Settings                                                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Neocoplete Configuration                                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:neocomplete#enable_at_startup = 1

" use tab to cycle through items
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" use enter to select an item
inoremap <expr><CR>  pumvisible() ? "\<C-y>" : "\<CR>"

" disable the help preview
set completeopt-=preview

" use arrows to select completion results
let g:neocomplete#enable_cursor_hold_i = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP Configuration                                                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CtrlP keyboard shortcut
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'

" Start search where top-most .git directory is found
let g:ctrlp_working_path_mode = 'ra'

let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = {
  \ 'dir': join([
    \'build$',
    \'node_modules$',
    \'third-party$',
    \'vendor$',
    \'tmp$',
  \], '\|')}

let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree Settings                                                           "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>n :NERDTreeToggle<CR>
map <leader>f :NERDTreeFind<CR><C-w><C-w><CR>

" Open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif

" Open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeShowHidden = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Goyo Settings                                                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>g :Goyo<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C++ Settings                                                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:syntastic_cpp_checkers = []
let g:syntastic_c_checkers = []

let g:syntastic_cpp_include_dirs = [
  \"/usr/local/osquery/include",
\]

let g:syntastic_cpp_compiler_options = join([
  \"-std=c++17",
  \"-DOSQUERY_BUILD_SDK_VERSION=syntastic",
  \"-DOSQUERY_BUILD_PLATFORM=syntastic",
  \"-DOSQUERY_BUILD_DISTRO=syntastic",
  \], " ")

:autocmd BufWritePre *.cpp,*.cc,*.h,*.hpp :Autoformat

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Elixir Settings                                                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:mix_format_on_save = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Go Settings                                                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" https://github.com/fatih/vim-go/wiki/FAQ-Troubleshooting says this is required
filetype plugin indent on

let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }
let g:go_list_type = "quickfix"

" enabled syntax highlighting for more symbol types in Go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" run goimports instead of go fmt on save
let g:go_fmt_command = "goimports"

" build the code on save
autocmd BufWritePre *.go :GoBuild

" keyboard shortcuts
map <leader>b :GoBuild<CR>
map <leader>d :GoDef<CR>
