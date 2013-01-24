#!/bin/bash

alias grepcode="grep --binary-files=without-match --exclude-dir='.svn' --exclude-dir='.git' --exclude='cscope.files' --exclude='cscope.out' --exclude='tags'"
alias share_folder="python -m SimpleHTTPServer"
alias fanqiang="ssh -p 59 -TN -D 7070 zzmfish@vpn.ofan.me"

function indexcode()
{
  find -name "*.mk" -o -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.s" -o -name "*.S" -o -name "*.java" > cscope.files
  cscope -bkq
  ctags -R
}

function color_table()
{
  for fgColor in 30 31 32 33 34 35 36 37 38 39; do
    for bgColor in 40 41 42 43 44 45 46 47 48 49; do
      echo -ne "\033[$bgColor;$fgColor"m"$fgColor;$bgColor\033[0m\t"
    done
    echo
  done
  echo
  for color in 0 1 2 4 5 7 22 24 25 27 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 49; do
    echo -ne "\033[$color""m$color\033[0m "
  done
  echo
}

function color_man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1m") \
        LESS_TERMCAP_md=$(printf "\e[30;47m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

function svnstatus()
{
  svn status \
    | sed "s/^M\s.*/\x1b[33m&\x1b[0m/" \
    | sed "s/^D\s.*/\x1b[36m&\x1b[0m/" \
    | sed "s/^A\s.*/\x1b[32m&\x1b[0m/" \
    | sed "s/^!\s.*/\x1b[31m&\x1b[0m/" \

}

function svndiff()
{
  filename=$1
  tmpfile=`mktemp`
  svn cat $filename > $tmpfile
  vimdiff $tmpfile $filename
}

function svncommit()
{
    files=''
    for f in `svn status | grep "^M\s" | sed 's/^M\s\+//'`; do
        svndiff $f
        while true; do
            read -p "[1] commit, [2] skip, [3] cancel? " choice
            case $choice in
            1)
                files="$files $f"
                echo -e "\033[32m$f will be commited\033[0m"
                sleep 1
                break
                ;;
            2)
                echo -e "\033[33m$f will be skipped\033[0m"
                break
                ;;
            3)
                return
                ;;
            esac
        done
    done
    echo $files
}