#!/bin/sh
env
HOST_NAME="192.168.0.101"
USER_NAME="root"
VPATH="/var/tmp/midipi"
VPATH_BUILD="/var/tmp/midipi/build.xml"
echo "uploading files"
scp -r ../src $USER_NAME@$HOST_NAME:$VPATH
#scp -r ../lib $USER_NAME@$HOST_NAME:$VPATH
#scp -r build.xml $USER_NAME@$HOST_NAME:$VPATH
ssh $USER_NAME@$HOST_NAME <<'ENDSSH'
#ant -buildfile /var/tmp/midipi/build.xml
cd /var/tmp/midipi/bin/
java toban.midipi.midipi
exit
ENDSSH
