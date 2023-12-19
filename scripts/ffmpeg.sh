#!/bin/bash

ffmpeg -i $(dirname $0)/../big_buck_bunny_480p_h264.mov -f mpegts "tcp://10.1.1.1:5004?listen"
