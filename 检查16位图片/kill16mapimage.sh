#!/bin/bash
DIRECTORY="/Users/YiMi/Desktop/网付/网付"
echo "------------------------------"
echo "Passed Resources with xcassets folder argument is <$DIRECTORY>"
echo "------------------------------"
echo "Processing asset:"

find "$DIRECTORY" -name '*png' -print0 | while read -d $'\0' file; 
do 
    echo "---------$file"
    sips -m "/System/Library/Colorsync/Profiles/sRGB Profile.icc" "$file" --out "$file"
done

echo "------------------------------"
echo "script successfully finished"
echo "------------------------------"


