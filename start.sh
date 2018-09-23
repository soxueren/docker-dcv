#!/bin/bash

startfile="/root/.vnc/xstartup"

if [ -z "$ROOT_PASSWD" ]; then
ROOT_PASSWD=vnctest
echo "default set ROOT_PASSWD is vnctest"
fi

if [ -z "$VIEWER_PASSWD" ]; then
VIEWER_PASSWD=vnctest
echo "default set VIEWER_PASSWD is vnctest"
fi

if [ ! -f "$startfile" ]; then
echo "first start vncserver,please set your env: ROOT_PASSWD and VIEWER_PASSWD for dcvserver"
/init_commond.exp  "$ROOT_PASSWD" "$VIEWER_PASSWD"
vncserver -kill :1 && cp -f /tmp/xstartup /root/.vnc/xstartup &&  vncserver :1
 # && tail -f /vncserver.log
else
vncserver -kill :1 && cp -f /tmp/xstartup /root/.vnc/xstartup &&  vncserver :1
fi


if [ -z "$1" ] || [[ $1 =~ -h|--help ]]; then
echo "
vncserver [:display#] [−name desktop-name] [−geometry widthxheight] [−depth depth] [−pixelformat format] [−fp font-path] [−fg] [−autokill] [−noxstartup] [−xstartup script] [Xvnc-options...] 
vncserver −kill :display# 
vncserver −list
"
else
    # unknown option ==> call command
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '$@'"
    exec "$@"
fi
