#!/bin/sh

# Download a file
download() {
wget http://reilly.homeip.net/folding/update/$1
if [ $? -eq 1 ]
then
  echo "Failed to get latest $1 from the diskless folding website"
  echo "</body></html>"
  exit 0
fi
}

# Do the actual update
do_update() {
  cd /tmp
  if [ ! -e version.txt ]
  then
    download version.txt
  fi
  if [ ! -e kernel32 ]
  then
    download kernel32
  fi
  if [ ! -e kernel64 ]
  then 
    download kernel64
  fi
  if [ ! -e initrd ]
  then
    download initrd
  fi
  if [ ! -e syslinux.cfg ]
  then
    download syslinux.cfg
  fi
  if [ ! -e fold.txt ]
  then
    download fold.txt
  fi
  cp version.txt kernel32 kernel64 initrd syslinux.cfg fold.txt $1
}

# Main begins here
# Check the latest version on the website
echo "Content-type: text/html"
echo ""
echo "<html><body>" 
updated=0
cd /tmp
download version.txt

# Check for VMs
isVMWare
noVMWare=$?
isVPC
noVPC=$?
grep -q "QEMU Virtual CPU" /proc/cpuinfo
noQEMU=$?

if [ $noVMWare -eq 0 -o $noQEMU -eq 0 -o $noVPC -eq 0 ]
then
  mount -n -t vfat /dev/hda1 /hda
  if [ $? -eq 0 ]
  then
  if [ `cat /tmp/version.txt` -ge `cat /hda/version.txt` ]
  then
    do_update /hda
    updated=1
  fi
  umount /hda
fi

mount -n -t vfat /dev/sda1 /usba > /dev/null 2>&1
noUSBa=$?
if [ $noUSBa -eq 0 ]
then
  if [ `cat /tmp/version.txt` -ge `cat /usba/version.txt` ]
  then
    do_update /usba
    updated=1
  fi
  umount /usba
fi

mount -n -t vfat /dev/sdb1 /usbb > /dev/null 2>&1
noUSBb=$?
if [ $noUSBb -eq 0 ]
then
  if [ `cat /tmp/version.txt` -ge `cat /usbb/version.txt` ]
  then
    do_update /usbb
    updated=1
  fi
  umount /usbb
fi

if [ "$updated" -eq "1" ]
then
  echo "Version updated please reboot."
else
  echo "You have the latest version installed already."
fi
echo "</body></html>"

