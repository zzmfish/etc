
function install()
{
    echo ">>> install $* <<<"
    sudo apt-get -y install $*
}

which screen    || install screen
which vim       || install vim-gtk
which ctags     || install ctags
which sshfs     || install sshfs

#fcitx
install fcitx fcitx-googlepinyin im-switch
im-config -n fcitx

#解决无法访问.local的问题
if [ ! -e /etc/nsswitch.conf.bak ]; then
    sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
    sudo sed -i "s/^hosts:.*/hosts: files dns/" /etc/nsswitch.conf
fi

#安装iNode
cd /home/iNode
rm -rf iNodeClient
tar zxf iNode.tgz
cd iNodeClient
sudo ./install.sh
install libgtk2.0-0:i386 libpangoxft-1.0-0:i386 libpangox-1.0-0:i386 libxxf86vm1:i386 libsm6:i386 libncurses5:i386
cd ~
