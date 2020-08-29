#!/bin/bash

set -e

# superugly
find_args="! -name 0005-halium-get-rid-of-using-AudioFlinger-for-recording.patch ! -name 0006-halium-Enable-video-and-audio-recording-from-camera.patch"

MB=$1

USE_PATCH=0
if [ "$MB" != "--mb" ]; then
    USE_PATCH=1
fi

OLD_WD=`pwd`
cd hybris-patches

if [ "$USE_PATCH" == "1" ]; then
    for patch in `find . -name *.patch $find_args |sort`; do
        cd $OLD_WD/$(dirname $patch)
        patch -p1 < $OLD_WD/hybris-patches/$patch
    done
else
    MBS=$(find . -name *.patch $find_args -exec dirname {} \; |sort -u)
    for mb in $MBS; do
        cd $OLD_WD/$mb
	for patch in `find $OLD_WD/hybris-patches/$mb $find_args -type f -printf "%f\n" | sort`; do
      	    git am --no-gpg-sign $OLD_WD/hybris-patches/$mb/$patch
        done
    done
fi

