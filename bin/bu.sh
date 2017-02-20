#!/bin/bash
xrandr --output eDP-1 --brightness $(xrandr --current --verbose | grep Brightness | awk -F: '{if($2>0.9){print(1.0)}else{print($2+0.1)}}')
