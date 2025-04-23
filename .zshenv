# This file can be sourced multiple times (e.g. tmux).
# Watch out for side effects.

# Append to a PATH-like variable without duplicates (including symlinks) or
# empty directories.
# Usage: rr_path_like_append PATHLIKEVAR DIR...
#
# Based on https://unix.stackexchange.com/a/480523 with modifications for
# supporting any PATH-like variable and preventing duplicate symlinks in PATH
# (initial version assumed only realpaths in PATH).
rr_path_like_append() {
  local dirname
  local varname=$1
  shift 1

  for dirname in "${@}"; do
    dirname="${dirname%/}"
    [[ "${dirname:0:1}" == '/' &&
      ":${(P)varname}:" != *":${dirname}:"* &&
      ":${(P)varname}:" != *":${dirname:A}:"* &&
      -d "${dirname}" ]] || continue
    eval ${varname}=\"${(P)varname}:${dirname}\"
  done
  eval ${varname}="${(P)varname#:}"
  export ${varname}
}

# Prepend to a PATH-like variable without duplicates (including symlinks) or
# empty directories.
# Usage: rr_path_like_prepend PATHLIKEVAR DIR...
rr_path_like_prepend() {
  local dirname
  local varname=$1
  shift 1

  for dirname in "${@}"; do
    dirname="${dirname%/}"
    [[ "${dirname:0:1}" == '/' &&
      ":${(P)varname}:" != *":${dirname}:"* &&
      ":${(P)varname}:" != *":${dirname:A}:"* &&
      -d "${dirname}" ]] || continue
    eval ${varname}=\"${dirname}:${(P)varname}\"
  done
  eval ${varname}="${(P)varname#:}"
  export ${varname}
}

# Append to path without duplicates (including symlinks) or empty directories.
rr_path_append() {
  rr_path_like_append PATH "$@"
}

# Prepend to path without duplicates (including symlinks) or empty directories.
rr_path_prepend() {
  rr_path_like_prepend PATH "$@"
}

export GOPATH=$HOME/Code/go

export EDITOR=/usr/bin/vim

fpath=( $HOME/.oh-my-zsh/custom/completions $fpath )

rr_path_append /usr/local/bin /usr/local/sbin /usr/sbin /sbin

# Source mac environment settings if available.
[ -f $HOME/.zsh-mac ] && source $HOME/.zsh-mac

rr_path_append $HOME/bin

rr_path_append $GOPATH/bin

alias gloga='git log --decorate --oneline --graph --all'

# Add support for asdf set -s (ruby|nodejs|...) $VERSION
# that works similarly to rbenv shell. Calling without $VERSION
# reverts to the version specified in the nearest .tool-versions.
asdf() {
  if [[ $1 == "shell" ]]; then
    shift
    echo "Not supported. Try \`asdf set -s $@\` instead"
    return 1
  fi

  if [[ $1 == "set" && $2 == "-s" && -n $3 ]]; then
    if [[ -n $4 ]]; then
      export "ASDF_${(U)3}_VERSION=$4"
    else
      unset "ASDF_${(U)3}_VERSION"
    fi
  else
    command asdf "$@"
  fi
}

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
# Usage: sidious_wakeup
function sidious_wakeup {
  echo "Waking up Sidious..."
  wakeonlan -i 192.168.116.255 44:8a:5b:c9:19:ef
}

function sidious_sleep {
  echo "Putting sidious to sleep..."
  ssh sidious -t sudo systemctl hybrid-sleep
}

function esxi_wakeup {
  echo "Waking up ESXI host..."
  wakeonlan -i 192.168.116.255 28:92:4a:2d:54:a3
}

# Remove exited Docker containers
function remove_exited_containers {
  echo "Removing exited containers:"

  docker ps --filter status=dead --filter status=exited -a

  if read -q "continue?Continue? (y/n): "; then
    if (( $+commands[gxargs] )); then
      # macOS 10.12 xargs does not have '-r'
      xargs_cmd=gxargs
    else
      xargs_cmd=xargs
    fi

    docker ps --filter status=dead --filter status=exited -aq | $xargs_cmd -r docker rm -v
  fi
}

# Remove unused Docker images
function remove_unused_images {
  echo "Removing unused Docker images:"

  docker images --no-trunc | grep '<none>'

  if read -q "continue?Continue? (y/n): "; then
    if (( $+commands[gxargs] )); then
      # macOS 10.12 xargs does not have '-r'
      xargs_cmd=gxargs
    else
      xargs_cmd=xargs
    fi

    docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | $xargs_cmd -r docker rmi
  fi
}


function new_self_signed_cert {
  usage="
Usage: $0 subjectAltNames [keyName] [certName]

subjectAltNames      The names to set for the SANs (quoted and comma-separated)
                     'DNS:localhost,DNS:ryans-air'

keyName              The name of the private key file
                     (default=key.pem)

certName             The name of the cert file
                     (default=cert.pem)
"

  if [[ $# -eq 0 || $1 =~ "-?-h.*" ]]; then
    echo "$usage"
    return 1
  fi

  # ZSH idiom for checking command existence.
  # $commands is an associative array that lists all commands available to ZSH.
  # $+commands[openssl] says that if commands[openssl] is set, substitute 1, else 0.
  # See: http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion
  # https://unix.stackexchange.com/a/237084
  # https://www.zsh.org/mla/users/2011/msg00070.html
  if (( ! $+commands[openssl] )); then
    echo Could not find openssl. Exiting...
    return 1
  fi

  subjectAltNames="$1"
  keyName="${2:-key.pem}"
  certName="${3:-cert.pem}"

  if [[ -f "$keyName" || -f "$certName" ]]; then
    echo Not overwriting existing key and/or cert.
    echo Exiting...
    return 1
  fi

  # Both -reqexts SAN and -extensions SAN seem to be required
  openssl req -newkey rsa:2048 -nodes -keyout "$keyName" -x509 -days 365 -out "$certName" -subj "/C=US/ST=Tennessee/O=RR/OU=Dev/CN=localhost" -reqexts SAN -extensions SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=$subjectAltNames"))

  echo All done. Have a nice day!
}

### Deprecated ###
## See ~/Documents/ca/readme.md for updated commands
#
# Documenting for future automation
# Underscores are placeholders for real values
# Generate a self-signed Root CA
# openssl req -newkey rsa:4096 -keyout $ca.key.pem -x509 -days 3650 -out $ca.crt.pem -subj "/C=US/ST=Tennessee/O=RR/OU=Home/CN=_.ryanrobeson.com"

# Generate key (node)
# openssl genrsa -out $node.key.pem 2048

# Generate CSR (node)
# Currently extensions are not copied to certs, so there's no reason to add them here
# openssl req -new -key $node.key.pem -out $node.csr -subj "/C=US/ST=Tennessee/O=RR/OU=Home/CN=_._.ryanrobeson.com"

# Generate Cert from CSR (CA)
# openssl x509 -req -in $node.csr -CA $ca.crt.pem -CAkey $ca.key.pem -CAcreateserial -out $node.crt.pem -days 730 -sha256 -extfile <(printf subjectAltName=DNS:localhost,DNS:_,DNS:_._.ryanrobeson.com)
### END Deprecated ###
