#!/usr/bin/env bash

PATHNAME=$(dirname $(readlink -f $0)) ; source ${PATHNAME}/config
scriptname=$(basename $(grep -lr headphone.profile $basedir/*.sh))
conffile="$basedir/${scriptname%.*}.yaml"

do_install() {
  mkdir -p ~/bin
  ln -s $basedir/$scriptname $HOME/bin/ 2>/dev/null
  if [[ $? -ne 0 ]]; then
    echo "The link probably already exist or file with the same name already in exist in ~/bin."
    exit 99
  fi

  echo "Installation is nearly completed."
  echo "Please edit the YAML file as needed."
  echo "After that, you're good to go."
}

default_install() {
  # This will install the script with default (blank) YAML config
  cat > "$conffile" << EOF
current: speaker
device:
  speaker:
    profile:
  headphone:
    profile:
volume:
  up: 5
  down: 5
EOF
  do_install
}

author_install() {
  # this will install audio-switcher.sh using my (hotfloppy) YAML config
  do_install
}

if [[ $# -le 1 ]]; then
  case $1 in
    me) author_install ;;
    *) default_install ;;
  esac
else
  default_install
fi

