#!/bin/sh
# check_hang.sh - checks log files and kills the cores if hung at completion
#

while [ 1 ]
do
  # Run every 5 minutes
  sleep 300

  # For each instance
  instance=1
  while [ -d /etc/folding/$instance ]
  do
    # Check for FINISHED_UNIT without CoreStatus following
    grep -E 'FINISHED_UNIT|CoreStatus' /etc/folding/$instance/FAHlog.txt | tail -n 1 | grep -q FINISHED_UNIT
    if [ $?  -eq 0 ]
    then
      # Give the client a chance to kill the cores
      sleep 300
      grep -E 'FINISHED_UNIT|CoreStatus' /etc/folding/$instance/FAHlog.txt | tail -n 1 | grep -q FINISHED_UNIT
      if [ $?  -eq 0 ]
      then
        # Still there - it has hung so walk /proc looking for processes
        for procdir in `find /proc -name '[1-9]*' | awk '/\/proc\/[1-9]*$/ {print $0}'`
        do
          # Check if they are the right exe and the right cwd
          if [ -e $procdir/exe -a -e $procdir/cwd ]
          then
            if [ "`readlink $procdir/exe`" = "/etc/folding/$instance/FahCore_a1.exe" -a  "`readlink $procdir/cwd`" = "/etc/folding/$instance" ]
            then
              # kill -9 the core procs to free the hang
              kill -9 `echo $procdir | awk -F / '{print $3}'`
            fi
          fi
        done
      fi 
    fi
  instance=`expr $instance + 1`
  done
done
