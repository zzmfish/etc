
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

"折叠
set foldmarker=#if,#endif
set foldmethod=marker
set foldlevel=9999

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

function DiffCVS()
  let filename = expand('%')
  let tempname = tempname()
  execute "!cvs update -p " . filename . " > " . tempname
  execute "vertical diffsplit " . tempname
endfunction

function DiffSVN()
  let filename = expand('%')
  let tempname = tempname()
  execute "!svn cat " . filename . " > " . tempname
  execute "vertical diffsplit " . tempname
endfunction

function Run()
  let fileName = expand('%')
  if fileName =~ '\.py$'
    execute '!python ' . fileName
  else
    if getline(1) =~ '^#!'
      execute '!./' . expand('%')
    endif
  endif
endfunction

function Build()
  let keyword = '/ff3/mozilla/'
  let keyword2 = '/ff3/mozobj/'
  let filePath = expand('%:p')
  let p1 = stridx(filePath, keyword)
  if p1 > 0
    let path = strpart(filePath, 0, p1) . keyword2
    let p1 = p1 + strlen(keyword)
    let p2 = stridx(filePath, '/', p1)
    if p2 > 0
      let path = path . strpart(filePath, p1, p2 - p1)
      execute '!cd ' . path . '; pwd; color-make'
    endif
  else
    execute '!color-make'
  endif
endfunction

function Dot()
  let filename = expand('%')
  if strlen(filename) > 4 && strpart(filename, strlen(filename) - 4) == '.dot'
    let pngfile = strpart(filename, 0, strlen(filename) - 4) . '.png'
    execute 'silent !dot -Tpng ' . filename . ' -o ' . pngfile
    execute 'silent !eog ' . pngfile .' &>/dev/null &'
    redraw!
  endif
endfunction

map <F3> :call FindFile()<CR> 
map <F4> :call Build()<CR>
map <F5> :call Run()<CR>
map <F6> :call SVNDiff()<CR>
map <C-H> :tabprevious<CR>
map <C-L> :tabnext<CR>
command Dot call Dot()

au FileType cpp setlocal dict+=~/.vim/dict/cpp.txt
au FileType h setlocal dict+=~/.vim/dict/h.txt

