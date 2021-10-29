#!/bin/bash
cd /Applications
inotifywait -m . -e create -e moved_to |
    while read dir action file; do
        extension="${file##*.}"
        if [ $extension == "deb" ]
        then
            com.github.donadigo.eddy $file
            rm $file
        fi
    done
