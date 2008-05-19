#!/bin/sh
if [ "$REQUEST_METHOD" != "POST" ]
then
  echo "Content-type: text/html"
  echo ""
  echo "<html><body>"
  echo "Must use post method"
  echo "</body></html>"
  exit 0
fi

read POST_STRING
while true
do
  HEX="$(echo "$POST_STRING" | sed 's#^.*%\(..\).*#\1#')"
  if [ "$HEX" = "$POST_STRING" ]
  then
    break;
  fi
  REP=$(echo -e \\x$HEX)
  POST_STRING="$(echo "$POST_STRING" | sed 's#^\(.*\)%\(..\)#\1'$REP'#')"
done
POST_STRING=`echo $POST_STRING | sed 's/&/ /g'`

cat <<_EndOfSyslinux.cfg_ > /tmp/syslinux.cfg
PROMPT 1
DEFAULT fold
DEFAULT64 fold64
TIMEOUT 150
DISPLAY fold.txt

LABEL fold
    KERNEL kernel32
    APPEND initrd=initrd $POST_STRING BENCHMARK=no

LABEL fold64
    KERNEL kernel64
    APPEND initrd=initrd $POST_STRING BENCHMARK=no

LABEL benchmark
    KERNEL kernel32
    APPEND initrd=initrd $POST_STRING BENCHMARK=yes

LABEL benchmark64
    KERNEL kernel64
    APPEND initrd=initrd $POST_STRING BENCHMARK=yes
_EndOfSyslinux.cfg_

# Only if running VMWare and booted from the hard drive then
# update the hard drive image
isVMWare
noVMWare=$?
grep -q "QEMU Virtual CPU" /proc/cpuinfo
noQEMU=$?
if [ $noVMWare -eq 0 -o $noQEMU -eq 0 ]
then
  if [ "`cat /proc/sys/kernel/bootloader_type`" = "49" ]
  then
    mount -n -t vfat /dev/hda1 /hda
    cp /tmp/syslinux.cfg /hda/syslinux.cfg
    umount /hda
  fi
fi

# Update any USB sticks
mount -n -t vfat /dev/sda1 /usba > /dev/null 2>&1
noUSBa=$?
if [ $noUSBa -eq 0 ]
then
  echo "USB drive A found, reconfiguring..."
  cp /tmp/syslinux.cfg /usba/syslinux.cfg
  echo "Done"
  umount /usba
fi
mount -n -t vfat /dev/sdb1 /usbb > /dev/null 2>&1
noUSBb=$?
if [ $noUSBb -eq 0 ]
then
  echo "USB drive B found, reconfiguring..."
  cp /tmp/syslinux.cfg /usbb/syslinux.cfg
  echo "Done"
  umount /usbb
fi

rm /tmp/syslinux.cfg

echo "Content-type: text/html"
echo ""
echo "<html><head><META HTTP-EQUIV=\"Refresh\" CONTENT=\"15;URL=/\">"
echo "<SCRIPT LANGUAGE=\"JavaScript\"><!--"
echo "function redirect () { setTimeout(\"go_now()\",15000); }"
echo "function go_now ()   { window.location.href = \"/\"; }"
echo "//--></SCRIPT></head>"
echo "<body onLoad \"redirect()\">"
if [ $noVMWare -eq 0 -o $noQEMU -eq 0 ]
then
  if [ "`cat /proc/sys/kernel/bootloader_type`" = "49" ]
  then
    echo "Configuration for this Diskless Folding VM changed. A reboot will be required for the new configuration to take effect."
  fi
fi
echo "<BR>This page will refresh back to the main page for this diskless folder 
in 15 seconds."
echo "<BR>If this does not work, click <a href="/">here</a>."
echo "</body></html>"
echo ""
