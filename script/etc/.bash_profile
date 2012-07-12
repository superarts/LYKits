export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# alias locate.update="sudo /usr/libexec/locate.updatedb"
# export GREP_OPTIONS="--exclude="\*/.svn/\*""
export LANG=en_US.UTF-8
export PS1="\w\$ "
export SVN_EDITOR=vim
export dev01="74.53.0.160"
export staging01="74.53.0.136"
export edge03="74.53.0.168"
export sekond="209.59.222.249"
export v6000="192.168.1.101"
export mb470="192.168.1.102"
export imini="192.168.1.103"
export shots="~/Library/Application\ Support/Developer/Shared/Xcode/Screenshots/"
export iphoneapp="root@192.168.1.161:/Applications"
export iphonedoc="root@192.168.1.161:/var/mobile/Documents"
export iphone999="root@192.168.1.161:/var/mobile/Media/DCIM/999APPLE/*.PNG"
export iphone100="root@192.168.1.161:/var/mobile/Media/DCIM/100APPLE/*.PNG"
export NDK_ROOT="/Users/iphone/bin/android-ndk-r7"
# svnserve -d -r /Users/leo/Documents/svn
export PATH="/usr/local/bin:/usr/local/sbin:$PATH:/Developer/usr/bin/:~/bin:~/bin/script:~/bin/android-sdk-mac_x86/tools:~/bin/android-sdk-mac_x86/platform-tools:~/bin/android-ndk-r7"
# export MANPATH=/opt/local/share/man:$MANPATH
# export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# for dpkg: see http://www.saurik.com/id/7
export COPYFILE_DISABLE
export COPY_EXTENDED_ATTRIBUTES_DISABLE

# STARDICT_DATA_DIR		If set, sdcv use this variable as data directory, this is mean that sdcv search dic‐
# 						tionaries in $STARDICT_DATA_DIR\dic
# SDCV_HISTSIZE			If set, sdcv wrote in $(HOME)/.sdcv_history only last $(SDCV_HISTSIZE) words,  which
# 						you   seek   using  sdcv.  If  it  is  not  set,  then  last  2000  words  saved  in
# 						$(HOME)/.sdcv_history.
# SDCV_PAGER       		If SDCV_PAGER is set, its value is used as the  name of the program to use  to  dis‐
# 						play the dictionary’s article.
export STARDICT_DATA_DIR="/Users/iphone/doc/stardict"

# export DISPLAY=:0.0
# /Users/leo/bin/MouseFix/mousefix
# test -r /sw/bin/init.sh && . /sw/bin/init.sh
# trap "defaults write com.apple.Terminal VisorTerminal -dict-add Rows 39" EXIT

alias do-topmusic="cd ~/prj/iphone/topmusic/topmusic;vim topmusicAppDelegate.m topmusicAppDelegate.h -p" 
alias do-lykits="cd ~/prj/iphone/LYKits"
alias do-script="cd ~/prj/iphone/topmusic/script"
alias do-ssh="ssh 192.168.100.197 -l leo.l"
alias vim="/usr/local/bin/vim"
