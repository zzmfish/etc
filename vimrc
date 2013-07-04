
set hlsearch
set incsearch
set autoindent
set tabstop=4 expandtab
set fileencodings=utf-8,gbk
set fileencoding=utf-8
set termencoding=utf-8
set t_Co=256
set mouse=n
set diffopt=iwhite,vertical
colorscheme desert

"折叠
set foldmethod=syntax
set foldlevel=9999
set foldcolumn=0

filetype plugin on
syntax on

"winmanager
:map <c-w><c-t> :WMToggle<cr> 

"taglist
nnoremap <silent> <F8> :TlistToggle<CR>

"cscope
map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

"netrw
let g:netrw_winsize=30
let g:netrw_browse_split=3

if has("cscope")
  set csprg=/usr/bin/cscope
  set csto=0
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
      cs add cscope.out
  " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
  endif
  set csverb
endif

function! Run()
  let fileName = expand('%')
  if fileName =~ '\.py$'
    execute '!python ' . fileName
  else
    if getline(1) =~ '^#!'
      execute '!./' . expand('%')
    endif
  endif
endfunction

function! Dot()
  let filename = expand('%')
  if strlen(filename) > 4 && strpart(filename, strlen(filename) - 4) == '.dot'
    let pngfile = strpart(filename, 0, strlen(filename) - 4) . '.png'
    execute 'silent !dot -Tpng ' . filename . ' -o ' . pngfile
    execute 'silent !eog ' . pngfile .' &>/dev/null &'
    redraw!
  endif
endfunction

map <F3> :call FindFile()<CR> 
map <F5> :call Run()<CR>
map <C-H> :tabprevious<CR>
map <C-L> :tabnext<CR>
command! Dot call Dot()

"grep
command! -nargs=1 Grep :!grep --binary-files=without-match --color=always -n
    \ --exclude-dir='.svn' --exclude-dir='.git'
    \ --exclude='cscope.files' --exclude='cscope.out' --exclude='tags' --exclude='*.log'
    \ <args> * -r
command! -nargs=1 GrepWord :Grep "\b<args>\b"
command! -nargs=1 GrepClass :Grep "\bclass <args>\s*[:{\n]"
command! -nargs=1 GrepFunction :Grep "^[^\(]\+[: ]<args>\(.*\)\s\+[{\n]"

au FileType h,c,cpp setlocal dict+=~/.vim/dict/cpp.txt

au FileType h,c,cpp syn region IfFoldContainer
    \ start="^\s*#\s*if\(n\?def\)\?\>"
    \ end="#\s*endif\>"
    \ transparent
    \ keepend extend
    \ containedin=NONE
    \ contains=ZhouzmFoldIf

au FileType h,c,cpp syn region ZhouzmFoldIf start="^\s*#if" end="^\s*#endif" contained contains=TOP fold transparent

