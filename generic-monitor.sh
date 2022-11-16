#!/usr/bin/env bash

# This is just a script I used to parse currently in use audio device
# and update into Generic Monitor item in xfce4-panel.

device=$(yq e ' .current ' /home/hotfloppy/github/audio-switcher/audio-switcher.yaml)

if [[ "$device" == "headphone" ]]; then
  echo " 🎧 "
elif [[ "$device" == "speaker" ]]; then
  echo " 🔊"
fi
