#!/usr/bin/env bash

PATHNAME=$(dirname $(readlink -f $0))
source ${PATHNAME}/config

# check dependencies
if [[ ! $(which yq 2>/dev/null) ]]; then echo "'yq' not available. Install: https://github.com/mikefarah/yq" ; exit 99 ; fi
if [[ ! $(which pactl 2>/dev/null) ]]; then echo "'pactl' not available. You might want to install 'pulseaudio-utils' first." ; exit 99 ; fi
if [[ ! $(which notify-send 2>/dev/null) ]]; then echo "'notify-send' not available. You might want to install 'libnotify-bin' first." ; exit 99 ; fi

conffile="$basedir/${scriptname%.*}.yaml"

conffile_error() {
  echo -e "${red}${bold}\nConfig file: $conffile\n"
  echo -e "Please first make sure that the config file are properly configured.\n"
  echo "Edit the config file to add your speaker and headphone name if you haven't."
  echo -e "  ** To retrieve card's name:\n\t${yellow}${bold}pactl list cards | grep -i alsa.card_name${nc}"
  echo -e "  ${red}${bold}** To retrieve card's profile:\n\t${yellow}${bold}pactl list cards | grep -iE 'alsa.card_name|profile\('\n"
  echo -e "${red}${bold}And make sure to not leaving the volume increment or decrement value empty."
  echo -e "  ** The value is percentage. Recommended value is 5."
  echo -e "\n${yellow}${bold}Example:\n"
  echo -e "$(eval $lines)${green}${bold}\n\
current: speaker\n\
device:\n\
  speaker: HDA Intel PCH\n\
    profile: output:analog-stereo\n\
  headphone: FANTECH OCTANE 7.1\n\
    profile: output:analog-stereo+input:multichannel-input\n\
volume:\n\
  up: 5\n\
  down: 5"
  echo -e "${yellow}${bold}$(eval $lines)${nc}"
  exit 99
}

param_error() {
  echo -e "${red}${bold}\nError: Too many parameters\n"
  echo -e "$scriptname will accept 1 parameter or none only.\n"
  echo -e "up\n  to increase volume\n"
  echo -e "down\n  to decrease volume\n"
  echo -e "(no parameter)\n  to change audio device\n"
  echo -e "${yellow}${bold}Example:\n"
  eval $lines
  echo -e "${green}${bold}  $scriptname up\n  $scriptname down\n  $scriptname"
  echo -e "${yellow}${bold}$(eval $lines)${nc}"
  exit 99
}

check_config() {
  #
  # Check if config file exist.
  # If doesn't exist, create one with default template
  #
  if [[ ! -f ${conffile} ]]; then
    cat >> "$conffile" << EOF
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
    conffile_error
    exit 99
  #
  # If exist, parse all value into variables
  #
  else
    current=$(yq e ' .current ' "$conffile")
    speaker_name=$(yq e ' .device.speaker.name ' "$conffile")
    speaker_profile=$(yq e ' .device.speaker.profile ' "$conffile")
    headphone_name=$(yq e ' .device.headphone.name ' "$conffile")
    headphone_profile=$(yq e ' .device.headphone.profile ' "$conffile")
    volup=$(yq e ' .volume.up ' "$conffile")
    voldown=$(yq e ' .volume.down ' "$conffile")

    if [[ -z "$speaker_name" ]] || [[ -z "$headphone_name" ]]; then
      conffile_error
      exit 99
    fi

    if [[ -z "$speaker_profile" ]] || [[ -z "$headphone_profile" ]]; then
      conffile_error
      exit 99
    fi

    if [[ -z "$volup" ]] || [[ -z "$voldown" ]]; then
      conffile_error
      exit 99
    fi
  fi
}

increase_vol() {
  curvol=$(pactl list sinks | grep '^[[:space:]]Volume:' | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
  if [[ $curvol -lt 100 ]]; then
    pactl set-sink-volume @DEFAULT_SINK@ +${volup}%
  elif [[ $curvol -gt 100 ]]; then
    pactl set-sink-volume @DEFAULT_SINK@ 100%
  elif [[ $curvol -eq 100 ]]; then
    notify-send -t 2000 "Volume is already at max level (100%)."
  fi
  exit
}

decrease_vol() {
  pactl set-sink-volume @DEFAULT_SINK@ -${voldown}%
  exit
}

# accept 1 parameter or none only.
# "up" to increase volume
# "down" to decrease volume
# none to change audio device
if [[ $# -gt 1 ]]; then
  # check run from terminal or hotkey. 1 = hotkey, 2 = terminal
  if [[ $SHLVL -eq 2 ]]; then
    param_error
  elif [[ $SHLVL -eq 1 ]]; then
    notify-send -t 5000 "$(param_error)"
  fi
fi

check_config

#
# If there's 1 parameter, check if correct one and increase/decrease volume
#
if [[ $# -eq 1 ]]; then
  case $1 in
    up) increase_vol ;;
    down) decrease_vol  ;;
    *) param_error ;;
  esac
fi

#
# If no parameter given, proceed with changing audio device.
#
# Start with turning off all audio devices
#
cards_count=$(pactl list cards | grep Card | wc -l)
for ((card=0; card<${cards_count}; card++)); do
  pactl set-card-profile $card off
done

#
# Somehow, the position of each audio devices randomly changes on reboot, 
# so we need to retrieve the correct position of the cards.
#
headphone_position=$(pactl list cards | grep -B 6 -i "alsa.card_name = \"$headphone_name\"" | grep Card | awk -F'#' '{ print $2 }')
speaker_position=$(pactl list cards | grep -B 6 -i "alsa.card_name = \"$speaker_name\"" | grep Card | awk -F'#' '{ print $2 }')

enable_headphone() {
  echo "Switched to Headphone"
  notify-send -t 2000 "Switched to Headphone"
  pactl set-card-profile $headphone_position $headphone_profile
  yq e ' .current = "headphone" ' -i $conffile
}

enable_speaker() {
  echo "Switched to Speaker"
  notify-send -t 2000 "Switched to Speaker"
  pactl set-card-profile $speaker_position $speaker_profile 
  yq e ' .current = "speaker" ' -i $conffile
}

if [[ "$current" == "headphone" ]]; then
  enable_speaker
else
  enable_headphone
fi
