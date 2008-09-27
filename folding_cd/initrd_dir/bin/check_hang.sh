#!/bin/sh
# check_hang.sh - checks log files and kills/continues the cores if hung at completion
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
        kill_cores.sh $instance
      fi 
    fi

    # Check for upload and not trying to download following
    grep -E 'Number of Units Completed|Preparing to get new work unit' /etc/folding/$instance/FAHlog.txt | tail -n 1 | grep -q 'Number of Units Completed'
    if [ $?  -eq 0 ]
    then
      # Give the client a chance to continue
      echo "Potential stop found, waiting to see if it clears..." >> /etc/folding/hanglog.txt

      sleep 300
      grep -E 'Number of Units Completed|Preparing to get new work unit' /etc/folding/$instance/FAHlog.txt | tail -n 1 | grep -q 'Number of Units Completed'
      if [ $?  -eq 0 ]
      then
        echo "Stop failed to clear, Continuing cores" >> /etc/folding/hanglog.txt
        cont_cores.sh $instance
      fi
    fi

  instance=`expr $instance + 1`
  done
done
