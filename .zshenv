export GOPATH=$HOME/Code/go
export PATH=/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:$HOME/bin:/usr/texbin:$GOPATH/bin
export PATH=/usr/local/heroku/bin:$PATH
export EDITOR=/usr/bin/vim

# Source mac environment settings if available.
[ -f $HOME/.zsh-mac ] && source $HOME/.zsh-mac

alias gloga='git log --decorate --oneline --graph --all'

function update_xbmc_library {
  curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://localhost:8080/jsonrpc
}

function ansible_digital_ocean_api_options {
  endpoints=(sizes regions images ssh_keys)
  for i in "${endpoints[@]}"; do
    url=`printf "https://api.digitalocean.com/%s/?client_id=%s&api_key=%s" $i $DO_CLIENT_ID $DO_API_KEY`
    curl -s $url | python -mjson.tool
  done
}

# Open a sublime-project in the current directory
function sublp {
  command -v subl >/dev/null 2>&1 || { echo "subl not found. Cannot continue." >&2; return 1; }

  if [ -n "$(find . -maxdepth 1 -name '*.sublime-project' -print -quit 2>&1)" ]; then
    echo Found project file. Opening...
    subl --project *.sublime-project
  else
    echo "No sublime project file found. Aborting..." >&2
    return 1
  fi
}

# Create a new Bootstrap HTML page at the given page. Mainly for quick testing
function new_bs_temp {
  bsfile="$HOME/Dropbox/code/templates/bootstrap-3.2-basic.html"
  if [ -f "$bsfile" ]; then
    if [ ! -f "$1" ]; then
      echo "Creating bootstrap html document at: $1"
      cp -n "$bsfile" "$1"
    else
      echo "File $1 exists. Not overwriting."
      echo "Exiting..."
      return 1
    fi
  else
    echo "Could not find bootstrap template file at $bsfile."
    echo "Exiting..."
    return 1
  fi
  return 0
}

# Output MIT license file content to be piped to a file.
# Usage: mit_license                   # Prints the license with the current year
#                                        and my name.
#        mit_license 2018              # Specifying year
#        mit_license 2018 Ryan Robeson # Specifying year and name
function mit_license {
  ruby -rerb -rDate <<-eos
    @year = "${1}".empty? ? nil : "${1}"
    @name = "${2}".empty? ? nil : "${2}"
    b = binding
    puts ERB.new(File.read("#{Dir.home}/Dropbox/code/templates/mit-license.txt.erb")).run b
eos
}

# Wakes up one of my dev machines.
# Usage: outsider_wakeup
function outsider_wakeup {
  echo "Waking up Outsider..."
  wakeonlan -i 192.168.116.255 44:8a:5b:c9:19:ef
}
