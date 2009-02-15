#!/bin/sh

# Check for VMWare
isVMWare
noVMWare=$?
isVPC
noVPC=$?
grep -q "QEMU Virtual CPU" /proc/cpuinfo
noQEMU=$?

while [ 1 ]
do
  sleep `expr $1 \* 60`
  myip=`cat /tmp/myip`

  # For each instance
  instance=1
  while [ -d /etc/folding/$instance ]
  do
    cd /etc/folding/$instance
    if [ -f latest.$myip.$instance ]
    then
      last=`cat latest.$myip.$instance`
      if [ "$last" = "B" ]
      then
        new=A
      else
        new=B
      fi
    else
      new=A
    fi

    tar cf backup.$myip.$new.$instance machinedependent.dat queue.dat work > /dev/null 2>&1
    rm -f latest.$myip.$instance
    echo $new > latest.$myip.$instance
    # If tftpserverip exists then do a TFTP backup
    serverip=`cat /tmp/tftpserverip`
    if [ "$serverip" != "" ]
    then
      tftp -p $serverip -l backup.$myip.$new.$instance -r backup.$myip.$new.$instance > /dev/null 2>&1
      tftp -p $serverip -l latest.$myip.$instance -r latest.$myip.$instance > /dev/null 2>&1
    fi

    # Save a copy for the webpage link
    mv backup.$myip.$new.$instance /etc/folding/$instance/backup.tar

    # Backup to USB drive A if present
    mount -n -t vfat /dev/sda1 /usba > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
      # Make any directories necessary
      mkdir -p /usba/folding/$instance/work
      # Copy across any files that are newer than what is on the USB drive
      for name in machinedependent.dat queue.dat `find work -type f`
      do
        if [ ! -f /usba/folding/$instance/$name ]
        then
          cp /etc/folding/$instance/$name /usba/folding/$instance/$name
        elif [ /etc/folding/$instance/$name -nt /usba/folding/$instance/$name ]
        then
          cp /etc/folding/$instance/$name /usba/folding/$instance/$name
        fi
      done
      umount /usba
    fi

    # Backup to USB drive B if present
    mount -n -t vfat /dev/sdb1 /usbb > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
      # Make any directories necessary
      mkdir -p /usbb/folding/$instance/work
      # Copy across any files that are newer than what is on the USB drive
      for name in machinedependent.dat queue.dat `find work -type f`
      do
        if [ ! -f /usbb/folding/$instance/$name ]
        then
          cp /etc/folding/$instance/$name /usbb/folding/$instance/$name
        elif [ /etc/folding/$instance/$name -nt /usbb/folding/$instance/$name ]
        then
          cp /etc/folding/$instance/$name /usbb/folding/$instance/$name
        fi
      done
      umount /usbb
    fi

    # Backup to hard drive image if VMWare and booted by syslinux
    if [ $noVMWare -eq 0 -o $noQEMU -eq 0 -o $noVPC -eq 0 ] 
    then
      if [ "`cat /proc/sys/kernel/bootloader_type`" = "49" ]
      then
        mount -n -t vfat /dev/hda1 /hda
        if [ $? -eq 0 ]
        then
          # Make any directories necessary
          mkdir -p /hda/folding/$instance/work
          # Copy across any files that are newer than what is on the hard drive image
          for name in machinedependent.dat queue.dat `find work -type f`
          do
            if [ ! -f /hda/folding/$instance/$name ]
            then
              cp /etc/folding/$instance/$name /hda/folding/$instance/$name
            elif [ /etc/folding/$instance/$name -nt /hda/folding/$instance/$name ]
            then
              cp /etc/folding/$instance/$name /hda/folding/$instance/$name
            fi
          done

          # Clean up any stale files in the work directory
          slot=0
          while [ "$slot" -lt "10" ]
          do
            state=`queueinfo /hda/folding/$instance/queue.dat $slot`
            if [ "$state" -eq "0" ]
            then
              rm -f /hda/folding/$instance/work/*_0$slot*
            fi
            slot=`expr $slot + 1`
          done

          umount /hda
        fi
      else
        echo "Hard drive image is corrupted, not backing up"
      fi
    fi

    # Next instance
    instance=`expr $instance + 1`
  done

  # If we were hiding the backup links on the webpage, make them available now
  if [ -f /etc/folding/index.backup ]
  then
    mv /etc/folding/index.backup /etc/folding/index.html
  fi
done
