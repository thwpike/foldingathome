#!/bin/sh
# check_hang.sh - checks log files and kills the cores if hung at completion
#

while [ 1 ]
do
  # Run every 5 minutes
  sleep 300

  # Clean up the log file
  if [ -f /etc/folding/hanglog.txt ]
  then
    tail -n 1000 /etc/folding/hanglog.txt > /tmp/hanglog.txt
    mv /tmp/hanglog.txt /etc/folding/hanglog.txt
  fi

  # For each instance
  instance=1
  while [ -d /etc/folding/$instance ]
  do
    echo `date` " Checking instance " $instance >> /etc/folding/hanglog.txt

    # Check for FINISHED_UNIT without CoreStatus following
    grep -E 'FINISHED_UNIT|CoreStatus' /etc/folding/$instance/FAHlog.txt | tail -n 1 | grep -q FINISHED_UNIT
    if [ $?  -eq 0 ]
    then
      # Give the client a chance to kill the cores
      echo "Potential hang found, waiting to see if it clears..." >> /etc/folding/hanglog.txt

      sleep 300
      grep -E 'FINISHED_UNIT|CoreStatus' /etc/folding/$instance/FAHlog.txt | tail -n 1 | grep -q FINISHED_UNIT
      if [ $?  -eq 0 ]
      then
        echo "Hang failed to clear, killing cores" >> /etc/folding/hanglog.txt

        # Still there - it has hung so walk /proc looking for processes
        for procdir in `find /proc -name '[0-9]*' | awk '/\/proc\/[0-9]*$/ {print $0}'`
        do
          # Check if they are the right exe and the right cwd
          if [ -e $procdir/exe -a -e $procdir/cwd ]
          then
            if [ "`readlink $procdir/exe`" = "/etc/folding/$instance/FahCore_a1.exe" -a  "`readlink $procdir/cwd`" = "/etc/folding/$instance" ]
            then
              # kill -9 the core procs to free the hang
              kill -9 `echo $procdir | awk -F / '{print $3}'`
              echo "Killing " `echo $procdir | awk -F / '{print $3}'` >> /etc/folding/hanglog.txt
            fi
          fi
        done
      fi 
    fi
  instance=`expr $instance + 1`
  done
done
