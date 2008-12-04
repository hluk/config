#!/bin/sh
IMG="/home/lukas/wallpapers/Briefing_by_tsutsu_di.jpg"

echo "--- Testing quality for \"$IMG\" ---"
echo "* Input ... "$(/usr/bin/identify "$IMG")
echo "* Resizing ..."

# imagemagick
/usr/bin/convert -resize 1280x1024^ "$IMG" "/home/lukas/dev/img/_test1.png" || exit 1

# PIL
python -c "
import Image
im = Image.open('$IMG')
# strech
#out = im.resize((1280,int(float(1280*im.size[1])/float(im.size[0]))),Image.BICUBIC)
# fill
out = im.resize((int(float(1024*im.size[0])/float(im.size[1])), 1024),Image.BICUBIC)
out.save('/home/lukas/dev/img/_test2.png', 'PNG')" || exit 1

/usr/bin/feh /home/lukas/dev/img/_test*.png
rm /home/lukas/dev/img/_test*.png

