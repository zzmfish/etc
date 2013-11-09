
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

map <C-G> :call GrepMenu()<CR>
map <C-G>t :call GrepText(expand("<cword>"))<CR>
map <C-G>w :call GrepWord(expand("<cword>"))<CR>
map <C-G>f :call GrepFunction(expand("<cword>"))<CR>
map <C-G>c :call GrepClass(expand("<cword>"))<CR>
map <C-G>b :call GrepBack()<CR>

"C++
function SetCppOptions()
  setlocal dict+=~/.vim/dict/cpp.txt
  syn region IfFoldContainer
    \ start="^\s*#\s*if\(n\?def\)\?\>"
    \ end="#\s*endif\>"
    \ transparent
    \ keepend extend
    \ containedin=NONE
    \ contains=ZhouzmFoldIf
  syn region ZhouzmFoldIf start="^\s*#if" end="^\s*#endif" contained contains=TOP fold transparent
  set foldmethod=syntax
  "set foldlevel=9999
  "set foldcolumn=0
endfunction
au FileType h,c,cpp call SetCppOptions()

"Python
function SetPythonOptions()
  set foldmethod=indent
  set foldnestmax=2
  set shiftwidth=2
endfunction
au FileType python call SetPythonOptions()
