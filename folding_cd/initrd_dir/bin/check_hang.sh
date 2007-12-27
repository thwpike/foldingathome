#!/bin/sh
# check_hang.sh - checks log files and kills the cores if hung at completion
#
# TBD!!!! This will not work on multiple SMP instances, need to parse cwd 
#         symbolic link from the proc entries and only kill -9 those procs
#         that are in the correct cwd.

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
        # Still there - it has hung
        killall -9 FahCore_a1.exe > /dev/null 2>&1 &
      fi 
    fi
  instance=`expr $instance + 1`
  done
done
