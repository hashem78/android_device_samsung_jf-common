#!/sbin/busybox sh
# Copyright (c) 2012, Code Aurora Forum. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of Code Aurora Forum, Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

BB=/sbin/busybox

# don't run with multirom fstab
if [ -e /mrom.fstab ]; then
    exit 0
fi

$BB mount -o remount,rw /;

$BB mv /fstab.qcom /fstab.org;

FS_CACHE0=$(eval $(/sbin/blkid /dev/block/mmcblk0p18 | /sbin/busybox cut -c 24-); /sbin/busybox echo $TYPE);
FS_DATA0=$(eval $(/sbin/blkid /dev/block/mmcblk0p29 | /sbin/busybox cut -c 24-); /sbin/busybox echo $TYPE);
FS_SYSTEM0=$(eval $(/sbin/blkid /dev/block/mmcblk0p16 | /sbin/busybox cut -c 24-); /sbin/busybox echo $TYPE);

if [ "$FS_SYSTEM0" == "ext4" ]; then
	$BB sed -i "s/# EXT4SYS//g" /tmpfstab;
elif [ "$FS_SYSTEM0" == "f2fs" ]; then
	$BB sed -i "s/# F2FSSYS//g" /tmpfstab;
fi;

if [ "$FS_CACHE0" == "ext4" ]; then
	$BB sed -i "s/# EXT4CAC//g" /tmpfstab;
elif [ "$FS_CACHE0" == "f2fs" ]; then
	$BB sed -i "s/# F2FSCAC//g" /tmpfstab;
else
	$BB sed -i "s/# F2FSCAC//g" /tmpfstab;
fi;

if [ "$FS_DATA0" == "ext4" ]; then
	$BB sed -i "s/# EXT4DAT//g" /tmpfstab;
elif [ "$FS_DATA0" == "f2fs" ]; then
	$BB sed -i "s/# F2FSDAT//g" /tmpfstab;
fi;

$BB mv /tmpfstab /fstab.qcom;
