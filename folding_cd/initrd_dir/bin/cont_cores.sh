#!/bin/sh
# cont_cores.sh - continues cores for the specified instance
#

echo "cont_cores.sh for instance $1" >> /etc/folding/hanglog.txt

# Walk /proc looking for processes
for procdir in `find /proc -name '[0-9]*' | awk '/\/proc\/[0-9]*$/ {print $0}'`
do
  # Check if they are the right exe and the right cwd
  if [ -e $procdir/exe -a -e $procdir/cwd ]
  then
    if [ "`readlink $procdir/exe`" = "/etc/folding/$1/FahCore_a2.exe" -a  "`readlink $procdir/cwd`" = "/etc/folding/$1" ]
    then
      # kill -CONT the core procs to free the hang
      kill -18 `echo $procdir | awk -F / '{print $3}'`
      echo "Continuing " `echo $procdir | awk -F / '{print $3}'` >> /etc/folding/hanglog.txt
    fi
  fi
done
