set nocompatible
set number
set tabstop=4
set shiftwidth=4
set expandtab
set relativenumber

filetype off
syntax on
"syntax off

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'preservim/nerdtree'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'delimitMate.vim'
Plugin 'fatih/vim-go'
Plugin 'mattn/emmet-vim'
Plugin 'nvie/vim-flake8'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'ellisonleao/gruvbox.nvim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'sonph/onehalf', { 'rtp': 'vim' }

"php 
Plugin 'arnaud-lb/vim-php-namespace'
Plugin 'phpstan/vim-phpstan'



call vundle#end()            " required
filetype plugin indent on    " required

set cursorline
colorscheme onehalfdark

let g:airline_theme='onehalfdark'
let g:lightline = { 'colorscheme': 'onehalfdark' }


map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" start fzf
nmap <Space> :Files<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ }

function! s:getVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)

    if len(lines) == 0
        return ""
    endif

    let lines[-1] = lines[-1][:column_end - (&selection == "inclusive" ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]

    return join(lines, "\n")
endfunction




" search all selected
function! s:find_git_root()  
   return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

 command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'dir':s:find_git_root(),'options': '--delimiter : --nth 4..'}, <bang>0)


" end fzf

" toggle nerdtree
nmap <C-a> :NERDTreeToggle<CR>

" muñonsitos
:command WQ wq
:command Wq wq
:command W w
:command Q q


" colors fzf
function! s:update_fzf_colors()
    let rules =
                \ { 'fg':      [['Normal',       'fg']],
                \ 'bg':      [['Normal',       'bg']],
                \ 'hl':      [['Comment',      'fg']],
                \ 'fg+':     [['CursorColumn', 'fg'], ['Normal', 'fg']],
                \ 'bg+':     [['CursorColumn', 'bg']],
                \ 'hl+':     [['Statement',    'fg']],
                \ 'info':    [['PreProc',      'fg']],
                \ 'prompt':  [['Conditional',  'fg']],
                \ 'pointer': [['Exception',    'fg']],
                \ 'marker':  [['Keyword',      'fg']],
                \ 'spinner': [['Label',        'fg']],
                \ 'header':  [['Comment',      'fg']] }
    let cols = []
    for [name, pairs] in items(rules)
        for pair in pairs
            let code = synIDattr(synIDtrans(hlID(pair[0])), pair[1])
            if !empty(name) && code > 0
                call add(cols, name.':'.code)
                break
            endif
        endfor
    endfor
    let s:orig_fzf_default_opts = get(s:, 'orig_fzf_default_opts', $FZF_DEFAULT_OPTS)
    let $FZF_DEFAULT_OPTS = s:orig_fzf_default_opts .
                \ empty(cols) ? '' : (' --color='.join(cols, ','))
endfunction

augroup _fzf
    autocmd!
    autocmd ColorScheme * call <sid>update_fzf_colors()
augroup END



" coc completion on <tab>
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<Tab>" :
            \ coc#refresh()


"clang
let g:clang_library_path='/usr/lib/llvm-10/lib/libclang.so.1'


" infinite undo
" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif


"vim go
let g:go_fmt_command = "goimports"
noremap <C-u> :GoImplements<CR>

" VISUAL NOREMAPS
"
" C-r -> search current file and replace inserted text
" C-s -> search selection in project
" C-f -> search filename selection in project

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
vnoremap <C-s> <Esc>:Ag <C-R>=<SID>getVisualSelection()<CR><CR>
vnoremap <C-f> <Esc>:FZF -q <C-R>=<SID>getVisualSelection()<CR><CR>

"php
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction

autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>

let g:phpstan_analyse_level = 4
