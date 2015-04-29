#!/bin/bash

alias grepcode="grep --binary-files=without-match --exclude-dir='.svn' --exclude-dir='.git' --exclude='cscope.files' --exclude='cscope.out' --exclude='tags'"
alias share_folder="python -m SimpleHTTPServer"
alias fanqiang="ssh -p 59 -TN -D 7070 zzmfish@vpn.ofan.me"
alias mount_secret="sudo mount -t ecryptfs -o ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_enable_filename_crypto=y,ecryptfs_passthrough=n"
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'

export EDITOR=vim

function cscope_index()
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

function add_app_desktop()
{
    #名称
    local name=`zenity --title="输入名称" --entry`
    if [ -z "$name" ]; then
        echo "ERROR: name is empty"
        return
    fi
    echo "名称：$name"

    #文件
    local exec=`zenity --title="选择程序" --file-selection`
    if [ -z "$exec" ]; then
        echo "ERROR: file is empty"
        return
    fi
    echo "程序：$exec"

    #图标
    local icon=`zenity --title="选择图标" --file-selection --file-filter="*.png *.gif *.jpg *.svg" --file-filter="*.*"`
    echo "图标：$icon"

    #创建desktop文件 
    local tmp=`mktemp`
    echo "[Desktop Entry]" > $tmp
    echo "Name=$name" >> $tmp
    echo "Exec=$exec" >> $tmp
    echo "Icon=$icon" >> $tmp
    echo "Terminal=false" >> $tmp
    echo "Type=Application" >> $tmp
    echo "StartupNotify=true" >> $tmp
    cat $tmp
    chmod u+x $tmp
    destdir="$HOME/.local/share/applications"
    cp -iv $tmp "$destdir/$name.desktop"
    nautilus $destdir
}

function tether_android()
{
    #设置电脑
    IP=`ip -o -f inet addr | grep eth0 | grep "inet" | grep -Po "\b\d+\.\d+\.\d+\.\d+\b" | head -n 1`
    echo "IP=$IP"
    sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
    sudo ifconfig usb0 192.168.42.1 netmask 255.255.255.0 up
    sudo iptables -t nat -A POSTROUTING -s 192.168.42.1/24 -j SNAT --to-source $IP

    #设置手机
    adb shell su -c "/data/busybox route add default gw 192.168.42.1"
    adb shell su -c "busybox route add default gw 192.168.42.1"
    adb shell su -c "setprop net.dns1 8.8.8.8"
}

function hex2dec()
{
    echo "obase=10; ibase=16; $1" | bc
}

function dec2hex()
{
    echo "obase=16; ibase=10; $1" | bc
}

function check_port()
{
    port=$1
    if [ -z "$port" ]; then
        return 1
    fi
    if [ `netstat -anp 2>/dev/null | grep ":$port\b" | wc -l` == 0 ]; then
        return 1
    else
        return 0
    fi
}

function csindex()
{
    find -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" > cscope.files
    cscope -bkq
    ctags -R
}

function ssh_list()
{
    #参数处理
    action="ssh"
    for arg in $@; do
        if [ "$arg" == "-m" ]; then
            action="sshfs"
        fi
    done

    #显示ssh列表
    f="$HOME/.ssh_list"
    if [ -e "$f" ]; then
        id=1
        printf "+---------------------------------------------------------------+\n"
        printf "| %-2s | %-13s | %-20s | %-4s | %-10s |\n" "Id" "HostName" "Address" "Port" "User"
        printf "+---------------------------------------------------------------+\n"
        cat $f | (
            while true; do
                read hostName hostIp hostPort userName
                if [ -z "$hostName" ]; then
                    break
                fi
                printf "| %-2s | %-13s | %-20s | %-4s | %-10s |\n" "$id" "$hostName" "$hostIp" "$hostPort" "$userName"
                id=$(($id+1))
            done
        )
        printf "+---------------------------------------------------------------+\n"
    fi

    #输入选择
    read -p "Id: " select

    #登录选择的ssh
    tmp=`mktemp`
    cat $f | sed "${select}q;d" >> $tmp
    read hostName hostIp hostPort userName <$tmp
    if [ -n "$hostName" ]; then
        case $action in
        ssh)
            cmd="ssh -p $hostPort $userName@$hostIp"
            ;;
        sshfs)
            mkdir -p $HOME/mount/$hostName
            cmd="sshfs -o nonempty -p $hostPort $userName@$hostIp: $HOME/mount/$hostName"
            ;;
        esac

        echo $cmd
        $cmd
    else
        echo "Error: invalid selection!"
    fi
}

#显示目录深度
function dirdepth()
{
    dir_name=$1
    if [ -z "$dir_name" ]; then
        #目标目录为空
        return
    fi
    dst_dir=`echo $PWD | grep -o "^.*\/$dir_name\b"`
    if [ -z "$dst_dir" ]; then
        #找不到目标目录
        return
    fi
    cur_depth=`echo $PWD | tr -dc "/" | wc -c`
    dst_depth=`echo $dst_dir | tr -dc "/" | wc -c`
    depth=$(($cur_depth-$dst_depth))

    result=""
    for i in `seq $depth`; do
        result="../$result"
    done
    echo $result
}
