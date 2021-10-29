#!/bin/bash
APPNAME=$(<"$1")
echo $APPNAME
gtk-launch $(basename $APPNAME)
