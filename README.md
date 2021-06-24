# Audio Switcher

A simple script to help change which audio devices we would like to use; speaker or headphone.

## Dependencies

* yq (https://github.com/mikefarah/yq)
* pactl (provided by libpulse (Arch), pulseaudio-utils (Ubuntu))
* notify-send (comes with libnotify (Arch), libnotify-bin (Ubuntu))

## How to install:

1. Make sure required dependencies met.
2. Clone this repository into `$REPOPATH` (*e.g: /home/kucing/github*) of your choosing
3. Navigate into `$REPOPATH` and install using `install.sh`
4. Edit `audio-switcher.yaml` as needed using the `audio-switcher.yaml.example` as a reference.
    * Or you can just run `audio-switcher.sh` in terminal, and it will tell you what needed to be done.
5. Voila!

## Usage:

* To change audio devices<br>
`$ audio-switcher.sh`

* To increase volume<br>
`$ audio-switcher.sh up`

* To decrease volume<br>
`$ audio-switcher.sh down`

## Suggestion
It would be better if you assign this to a hotkey so it's easier to use.<br>
My personal fav is:
<br>

* `F8` to change audio device
* `Pause` to increase volume
* `Scroll Lock` to decrease the volume