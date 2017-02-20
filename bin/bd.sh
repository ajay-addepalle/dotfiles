#!/bin/bash
xrandr --output eDP-1 --brightness $(xrandr --current --verbose | grep Brightness | awk -F: '{if($2<0.1){print(0.1)}else{print($2-0.1)}}')
