" Nixos Neovim Configurations
" - Definitions
set relativenumber
set hidden
set nowrap
set encoding=utf-8
set pumheight=10
set fileencoding=utf-8
set ruler
set cmdheight=2
set iskeyword+=-
set mouse=a
set splitbelow
set splitright
set conceallevel=0
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set number
set background=dark
set showtabline=1
set nobackup
set nowritebackup
set updatetime=200
set timeoutlen=500
set formatoptions -=cro
set clipboard=unnamedplus
set foldmethod=indent
set autoread
set laststatus=2
set guifont=Cascadia\ Code:h8
" - Directives
"
filetype plugin indent on
syntax enable

" - Plugin Settings
let mapleader = ";"
let g:startify_session_dir = '~/.config/nvim/session'
let g:tokyonight_style = "night"
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'

let g:neovide_cursor_vfx_mode = "railgun"

let g:vista#renderer#enable_icons = 1
let g:vista#renderer#icons = {
\   "function": "𝑓",
\   "variable": "𝓥",
\   "struct": "{}",
\  }


autocmd BufWritePre * %s/\s\+$//e
autocmd FocusGained,BufEnter * :checktime
autocmd FocusGained,BufWritePost * :syntax sync fromstart
autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

command! -nargs=0 ShowDocs :call s:show_documentation()
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 Todo :call s:todo()
command! -nargs=* SpTerm sp | terminal <args>
command! -nargs=* VspTerm sp | terminal <args>

map Q <NOP>
map gQ <NOP>
map <leader>rf :set foldmethod=indent<CR>zM<CR>
map <leader>uf :set foldmethod=manual<CR>zR<CR>
map <leader>vt :VspTerm <CR>
map <leader>st :SpTerm <CR>
map <leader>vv :Vista coc !<CR>

tnoremap <Esc> <C-\><C-n>
nnoremap o o<Esc>
nnoremap O O<Esc>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-H><C-H>

nnoremap <C-S-J> <C-W><C-S-J>
nnoremap <C-S-K> <C-W><C-S-K>
nnoremap <C-S-L> <C-W><C-S-L>
nnoremap <C-S-H> <C-H><C-S-H>

nnoremap <S-Tab> :tabnext<cr>
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gt <Plug>(coc-type-definition)
nnoremap <silent> sd :call <SID>show_documentation()<CR>
nnoremap <silent> fmt :Format <CR>
nnoremap <silent> st :Todo<CR>

nnoremap == <C-W>=

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt

nnoremap <leader>sc :source $MYVIMRC<CR>
nnoremap <leader><S>c :sp $MYVIMRC<CR>
nnoremap <leader>c :vsp $MYVIMRC<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! s:todo() abort
  let entries = []
  for cmd in ['git grep -niIw -e TODO -e FIXME -e BUG -- "./*"  2> /dev/null',
            \ 'grep -rniIw -e TODO -e FIXME -e BUG . 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction

colorscheme tokyonight

function! ConnectedTo() abort
    if empty(glob( v:severname )) && has("gui")
        return "🔌:".v:servername
    endif
endfunction

let g:lightline = {
  \  'colorscheme': 'tokyonight',
  \  'active': {
  \    'left': [["connected_to"],[ 'coc_errors', 'coc_warnings', 'coc_ok' ], [ 'coc_status'  ]]
  \  },
  \  'component_function': {
  \    'method': 'ConnectedTo'
  \  }
  \ }

call lightline#coc#register()
