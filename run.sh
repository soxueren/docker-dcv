#!/bin/bash

if [ $# -lt 2 ]; then 
    echo "usage: startdcv.sh  <VNC_PORT> <DCV_PORT> [<ROOT_PASSWD>] [<VIEWER_PASSWD>] [<VNC_DISPLAY>]"
else
echo "$1" "$2" "$3" "$4" "$5"
if [ ! -z "$1" ]; then
VNC_PORT="$1"
fi

if [ ! -z "$2" ]; then
DCV_PORT="$2"
fi

if [ -z "$3" ]; then
ROOT_PASSWD=Test@402
echo "default set ROOT_PASSWD is Test@402"
fi

if [ -z "$4" ]; then
VIEWER_PASSWD=Test@402
echo "default set VIEWER_PASSWD is Test@402"
fi

if [ -z "$5" ]; then
VNC_DISPLAY=1
echo "default set VNC_DISPLAY is 1"
fi

DISPLAY_PORT=$[5900+$VNC_DISPLAY]


echo "
docker run -it -d \
 -v /usr/local/blender:/usr/local/blender \ 
 -v /var/lib/nvidia-docker/volumes/nvidia_driver/346.35:/usr/local/nvidia:ro \
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
 -v /root/docker-dcv-vnc/xorg.conf:/etc/X11/xorg.conf \
 -e PATH=/usr/local/blender:${PATH} \
 -e ROOT_PASSWD=${ROOT_PASSWD} \
 -e VIEWER_PASSWD=${VIEWER_PASSWD} \
 -e VNC_DISPLAY=${VNC_DISPLAY} \
 -e DCV_DISPLAY=${VNC_DISPLAY} \
 -p ${VNC_PORT}:${DISPLAY_PORT}  -p ${DCV_PORT}:8443 \
 dcv-nv7:1.0.2
"

docker run -it -d  -v /usr/local/blender:/usr/local/blender -v /var/lib/nvidia-docker/volumes/nvidia_driver/346.35:/usr/local/nvidia:ro \
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
 -v /root/docker-dcv-vnc/xorg.conf:/etc/X11/xorg.conf \
 -e PATH=/usr/local/blender:${PATH} \
 -e ROOT_PASSWD=${ROOT_PASSWD} \
 -e VIEWER_PASSWD=${VIEWER_PASSWD} \
 -e VNC_DISPLAY=${VNC_DISPLAY} \
 -e DCV_DISPLAY=${VNC_DISPLAY} \
 -p ${VNC_PORT}:${DISPLAY_PORT} \
 -p ${DCV_PORT}:8443 \
 dcv-nv7:1.0.2

fi


