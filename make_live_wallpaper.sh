#!/usr/bin/env sh

function usage() {
  echo -e "Usage:" >&2
  echo -e "\t$0 <video_file> <background_name>" >&2
  exit 1
}

test $# -ne 2 && usage

backgroundpath=/usr/share/backgrounds/LiveWallpapers
propertypath=/usr/share/gnome-background-properties

videofile=$1
name=$2 # TODO must not be a path

not test -f $videofile && usage

framespath=$backgroundpath/$name
wallpaperxmlfile=$backgroundpath/$name.xml
propertyfile=$propertypath/live-wallpapers.xml

echo " [*] Creating paths for files..."

rm -rf $framespath $wallpaperxmlfile

mkdir -p $backgroundpath || exit 1
mkdir -p $propertypath || exit 1 # it must exist though...
mkdir -p $framespath || exit 1

echo " [*] Generating frames from video file..."

gst=$(which gst-launch 2>/dev/null || which gst-launch-1.0) # select proper one

$gst filesrc location=$videofile ! decodebin ! \
  videorate ! video/x-raw,framerate=10/1 ! \
  jpegenc ! multifilesink location=$framespath/frame%04d.jpg || exit 1

echo " [*] Creating background xml files..."

echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"     > $wallpaperxmlfile || exit 1
echo -e "<background>"                                  >> $wallpaperxmlfile
for framefile in $(ls $framespath); do
  echo -e "\t<static>"                                  >> $wallpaperxmlfile
  echo -e "\t\t<duration>0.05</duration>"               >> $wallpaperxmlfile
  echo -e "\t\t<file>${framespath}/${framefile}</file>" >> $wallpaperxmlfile
  echo -e "\t</static>"                                 >> $wallpaperxmlfile
done
echo -e "</background>"                                 >> $wallpaperxmlfile

echo " [*] Creating background entry in property xml file..."

if [[ -f $propertyfile ]]; then
  grep "<name>${name}" $propertyfile >/dev/null && exit 0 # already exists
  head --lines=-1 $propertyfile > "${propertyfile}.bkp" # remove last line "</wallpapers>"
  mv "${propertyfile}.bkp" $propertyfile
else 
  echo -e "<?xml version=\"1.0\"?>"                             > $propertyfile || exit 1
  echo -e "<!DOCTYPE wallpapers SYSTEM \"gnome-wp-list.dtd\">" >> $propertyfile
  echo -e "<wallpapers>"                                       >> $propertyfile
fi

echo -e "\t<wallpaper deleted=\"false\">"                    >> $propertyfile
echo -e "\t\t<name>${name}</name>"                           >> $propertyfile
echo -e "\t\t<filename>${wallpaperxmlfile}</filename>"       >> $propertyfile
echo -e "\t\t<options>zoom</options>"                        >> $propertyfile
echo -e "\t\t<shade_type>solid</shade_type>"                 >> $propertyfile
echo -e "\t\t<pcolor>#3465a4</pcolor>"                       >> $propertyfile
echo -e "\t\t<scolor>#000000</scolor>"                       >> $propertyfile
echo -e "\t</wallpaper>"                                     >> $propertyfile

echo -e "</wallpapers>"                                      >> $propertyfile
