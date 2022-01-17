# Video to Live Wallpaper Converter

Gnome supports live/dynamic wallpaper as an xml which contains a list of pictures and their timeframe.

to use a video as a live wallpaper, the video must be splitted into many pictures, and each picture shown in a fraction of second.

gnome by default doesn't change the background picture fast enough, so this extension must be installed for a smooth and fast play: [Speed Background](https://extensions.gnome.org/extension/4761/speed-background/)

find free live wallpapers at: [](https://mylivewallpapers.com/)

NOTE: only tested on manjaro/gnome, but it should work pretty much on any gnome.

## Requirements

 - `gstreamer` (for gst-launch)
 - `coreutils` (for realpath)

## Usage

requires root permissions.

installs files at `/usr/share/backgrounds/LiveWallpapers` and `propertypath=/usr/share/gnome-background-properties`.

```
# ./make_live_wallpaper.sh <video-file> <output-name>

# example:

./make_live_wallpaper.sh ~/Pictures/LiveWallpapers/mylivewallpapers.com-Glow-Waves.mp4 Glow-Waves
```

now you can set the background either with `settings -> change background` or selecting xml file at `/usr/share/backgrounds/LiveWallpapers/<name>.xml` by gnome-tweaks.
