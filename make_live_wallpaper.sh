#!/usr/bin/env sh

backgroundpath=/usr/share/backgrounds/LiveWallpapers
propertypath=/usr/share/gnome-background-properties

name=$2
framespath=$backgroundpath/$name
wallpaperxmlfile=$backgroundpath/$name.xml
propertyfile=$propertypath/$name.xml

echo " [*] Creating paths for files..."

rm -rf $framespath $wallpaperxmlfile $propertyfile

mkdir -p $backgroundpath || exit 1
mkdir -p $propertypath || exit 1 # it must exist though...
mkdir -p $framespath || exit 1

echo " [*] Generating frames from video file..."

gst-launch-1.0 filesrc location=$1 ! decodebin ! \
  videorate ! video/x-raw,framerate=10/1 ! \
  jpegenc ! multifilesink location=$framespath/frame%04d.jpg || exit 1

echo " [*] Creating xml files..."

echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"    >> $wallpaperxmlfile || exit 1
echo -e "<background>"                                  >> $wallpaperxmlfile
for framefile in $(ls $framespath); do
  echo -e "\t<static>"                                  >> $wallpaperxmlfile
  echo -e "\t\t<duration>0.05</duration>"               >> $wallpaperxmlfile
  echo -e "\t\t<file>${framespath}/${framefile}</file>" >> $wallpaperxmlfile
  echo -e "\t</static>"                                 >> $wallpaperxmlfile
done
echo -e "</background>"                                 >> $wallpaperxmlfile

echo -e "<?xml version=\"1.0\"?>"                            >> $propertyfile || exit 1
echo -e "<!DOCTYPE wallpapers SYSTEM \"gnome-wp-list.dtd\">" >> $propertyfile
echo -e "<wallpapers>"                                       >> $propertyfile
echo -e "\t<wallpaper deleted=\"false\">"                    >> $propertyfile
echo -e "\t\t<name>${name}</name>"                           >> $propertyfile
echo -e "\t\t<filename>${wallpaperxmlfile}</filename>"       >> $propertyfile
echo -e "\t\t<options>zoom</options>"                        >> $propertyfile
echo -e "\t\t<shade_type>solid</shade_type>"                 >> $propertyfile
echo -e "\t\t<pcolor>#3465a4</pcolor>"                       >> $propertyfile
echo -e "\t\t<scolor>#000000</scolor>"                       >> $propertyfile
echo -e "\t</wallpaper>"                                     >> $propertyfile
echo -e "</wallpapers>"                                      >> $propertyfile
