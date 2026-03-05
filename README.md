# Dunst for Everything

A hyper-minimalist, keyboard-centric desktop environment.

The entire graphical interface—from system status to interactive menus—is built entirely out of shell scripts and routed through `dunst`.

A lot of rices bloat ur screen with useless information using Dusnt more or less helps fixing the issue.

## Features

* **Zero-Panel Architecture:** No permanent taskbars or system trays taking up screen real estate.
* **The "Ghost" System Tray:** A custom bash script that queries background processes and uses Dunst's Pango markup to render a dynamic, auto-scaling pill showing active background applications.
* **Native Power Menu:** An interactive session menu built by stacking single-action Dunst notifications, bypassing the need for external launchers like Rofi.
* **Custom OSDs:** Volume and brightness sliders rendered as minimal Dunst progress bars.

## Dependencies

* **Window Manager:** MangoWC (or any Wayland compositor)
* **UI Engine:** Dunst
* **Scripting:** bash, libnotify (`notify-send` / `dunstify`)
* **Typography:** Any Nerd Font (for text-based iconography)

## Installation

Clone the repository and symlink the directories to your config folder:
^ I would only recommed following these steps if you are using a fresh install since in the repo the whole config is bundled
so stuff like my monitor,keyboard config are in here. What would be best would be to edit/remove these files after you download and tweak them to your liking

```bash
git clone [https://github.com/ernestoCruz05/dotfiles.git](https://github.com/ernestoCruz05/dotfiles.git) ~/dotfiles
ln -sfn ~/dotfiles/mango ~/.config/mango
ln -sfn ~/dotfiles/dunst ~/.config/dunst
