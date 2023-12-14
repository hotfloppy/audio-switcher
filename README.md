# Audio Switcher

A simple script to help change which audio devices we would like to use; speaker or headphone.

## Dependencies

* **yq** ( https://github.com/mikefarah/yq )
  * **Note:** don't confuse with another *yq*, which is just a wrapper for *jq*
* **pactl**
  * **Arch:** provided by **libpulse**
  * **Ubuntu:** provided by **pulseaudio-utils**
* **notify-send**
  * **Arch:** provided by **libnotify**
  * **Ubuntu:** provided by **libnotify-bin**

## How to install:

1. Make sure required dependencies has been installed
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
It would be better if you assigned this to a hotkey so that it's easier to use.<br>
My personal fav is:

| Hotkey  | Command | Description |
| --- | --- | --- |
| F8  | `$REPOPATH/audio-switcher.sh`  | To change audio device |
| F11  | `$REPOPATH/audio-switcher.sh down` | To decrease volume |
| F12  | `$REPOPATH/audio-switcher.sh up` | To increase volume |

**Note:** change *$REPOPATH* to actual path containing *audio-switcher.sh*
