#!/bin/bash
cd /Applications

function updateAppList {
    rm *.app
    for entry in "/usr/share/applications"/*
    do
        echo $entry > $"$(awk -F '=' '/\<Name\>/ {print $2}' $entry).app"
    done

}

updateAppList
exit

inotifywait -m . -e delete -e moved_to |
    while read dir action file; do
        extension="${file##*.}"
        if [ $extension == "deb" ]
        then
            com.github.donadigo.eddy $file
            rm $file
        fi
    done
