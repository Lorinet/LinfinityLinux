#!/bin/bash
inotifywait -m Applications -e create -e moved_to |
    while read dir action file; do
        extension="${file##*.}"
        if [ $extension == "deb" ]
        then
            e
        fi
    done
