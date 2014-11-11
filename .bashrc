# Environment query
#   Which system are we using?
#   Will add Mac support later

equery="$(expr substr $(uname -s) 1 5)"
if [ $equery == "MINGW" ] ; then
    system="windows"
else
    system="linux"
fi

#
# Let's construct the bash prompt!
# 

# Colors
# We're assuming the terminal emulator uses
# Solarized - http://ethanschoonover.com/solarized

esc=$(printf '\033')
K="${esc}[30m${esc}[1m"        # black, escaped for sed
R="${esc}[31m${esc}[1m"        # red, escaped for sed
G="${esc}[32m${esc}[1m"        # green, escaped for sed
B="${esc}[34m${esc}[1m"        # blue, escaped for sed
M="${esc}[35m${esc}[1m"        # magenta, escaped for sed
C="${esc}[36m${esc}[1m"        # cyan, escaped for sed
W="${esc}[37m${esc}[1m"        # white, escaped for sed
Y="${esc}[\033m${esc}[33m"     # yellow (muted)
O="${esc}[0m"

# Git helper functions
# To glean branch information

git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' -e 's/(//g' -e 's/)//g'
}

git_tag () {
  git describe --tags 2> /dev/null
}

git_info () {
    if [ -d .git ]; then
        DEL_COUNT=$(git status --porcelain 2> /dev/null | grep " D " | wc -l)
        MOV_COUNT=$(git status --porcelain 2> /dev/null | grep " M " | wc -l)
        local DELETED=""
        local MOVED=""
        if [ "$DEL_COUNT" -ne "0" ] ; then
            local DELETED="${B}::${W}${R}-${DEL_COUNT}${B}"
        fi
        if [ "$MOV_COUNT" -ne "0" ] ; then
            local MOVED="${B}::${W}${M}+${MOV_COUNT}${B}"
        fi
        local BRANCH="${W}$(git_branch)${B}"
    
        # This is really a really hacky solution until I can get sed to play
        # nice with terminal escape codes
    
        local TAGA=$(echo -e "$(git_tag)" | sed -e 's/-g.*//')
        local TAGB=$(git log --pretty=format:'%h' -n 1)
        if [ "$TAGB" != "" ] ; then
            local TAGB="${B}::${W}$TAGB"
        fi
        local TAG="${W}${TAGA}${TAGB}${B}"
    
        if [ -z $(ls -a | grep .git\$) ] ; then
            echo ""
        else
            echo -e "${K}::${B}[${BRANCH}${MOVED}${DELETED}]${K}::${B}[${TAG}]" | sed -e 's/\\\[//g' -e 's/\\\]//g' -e 's/ //g'
        fi
    fi
}

colored_dir() {
    local DIR=$(pwd)
    echo -e "$(pwd | sed -e 's/\/c\/Users\/[^\/]*/~/g' -e "s/\//${K}\/${M}/g")"
}

# Finally, the bash prompt itself
PS1="\n${K}::${B}(${W}\u${B}::${W}\h$B)${K}::${B}[\$(colored_dir)${K}/${B}]\$(git_info)\n${K}::${B}($Y$ $O"

#
# Dependencies
#

if [ $system == "windows" ] ; then
    source /c/Program\ Files\ \(x86\)/Git/etc/git-completion.bash
fi

#
# Conveniences
#

# Embellishments to common commands

# Custom commands
alias la='ls -a'
alias ll='ls -alF'

# Common commands
alias deploy='git add . ; git commit -a ; git push deploy'
alias stage='git add . ; git commit -a ; git push stage'
alias update='git add . ; git commit -a ; git push origin'

if [ $system != "windows" ] ; then
  alias svim='sudo vim'
else
    # AWS key locations
    key=""
    ip=""
    alias awssh="ssh -i $key -v ec2-user@$ip"
fi
