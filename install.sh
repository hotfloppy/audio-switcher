#!/usr/bin/env bash

mkdir -p ~/bin
ln -s $PWD/audio-switcher.sh ~/bin/ 2>/dev/null
if [[ $? -ne 0 ]]; then
  echo "The link probably already exist or file with the same name already in exist in ~/bin."
  exit 99
fi

echo "Installation is nearly completed."
echo "Please edit the YAML file as needed."
echo "After that, you're good to go."
