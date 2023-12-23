#!/bin/bash

# ffmpeg -i $(dirname $0)/../big_buck_bunny_480p_h264.mov -f mpegts "udp://172.16.20.9:5004?listen"

ffmpeg -i $(dirname $0)/../big_buck_bunny_480p_h264.mov -c:v libx264 -b:v 3000K -vf "scale=854:480" -f mpegts "udp://172.16.20.9:5004?listen"
