# Audio Switcher

A simple script to help change which audio devices we would like to use; speaker or headphone.

## Dependencies

* yq (https://github.com/mikefarah/yq)
* pactl (provided by libpulse (Arch), pulseaudio-utils (Ubuntu))
* notify-send (comes with libnotify (Arch), libnotify-bin (Ubuntu))

## How to install:

1. Make sure required dependencies met.
2. Clone this repository into $REPOPATH of your choosing
3. Install using $REPOPATH/install.sh
4. Run audio-switcher.sh once to generate the YAML file
5. Edit audio-switcher.yaml as needed
6. Done

## Usage:

* To change audio devices<br>
`$ audio-switcher.sh`

* To increase volume<br>
`$ audio-switcher.sh up`

* To decrease volume<br>
`$ audio-switcher.sh down`
<br><br>
---
<br>
**ps -<br>
My suggestion is that you assign this to a hotkey so it's easier to use.<br>
My personal fav is:<br>
`F8` to change audio device<br>
`Pause` to increase volume<br>
`Scroll` Lock to decrease the volume.**