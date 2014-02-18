export GOPATH=$HOME/Code/go
export PATH=/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:$HOME/bin:/usr/texbin:$GOPATH/bin
export PATH=/usr/local/heroku/bin:$PATH
export EDITOR=/usr/bin/vim

function wakeup_server {
  ssh -p1022 root@ryansconnect2home.bounceme.net '/usr/bin/ether-wake 00:26:b9:15:92:e9'
}

function poweroff_server {
  ssh ryan@server 'sudo poweroff'
}

function update_xbmc_library {
  curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://localhost:8080/jsonrpc
}