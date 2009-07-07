#!/bin/sh
# oneunit.cgi - shuts down current threads and reinvokes with -oneunit flag

echo "Content-type: text/html"
echo ""
echo "<html><body>"
echo "Killing current threads, may take a while for them to die.<p>"
killall fah6

# Wait for them to die
count=120
while [ $count ]
do
  ps | grep -q fah6
  if [ $? -eq 0 ]
  then
    echo "."
    count=`expr count - 1`
    sleep 1
  else
    break
  fi
done
if [ $count -eq 0 ]
then
  echo "Cannot kill processes<p>"
  echo "Click <a href="/">here</a> to return to the main page."
  echo "</body></html>"
  echo ""
  exit 0
fi

echo "Restarting with -oneunit flag<p>"

numprocs=`grep -c "^processor" /proc/cpuinfo`
arch=`uname -m`
SMPCPUS=`awk -F \" '/"SMPCPUS" value="." checked="true"/ {print $6}' /etc/folding/cd.html`
if [ "$arch" = "x86_64" -a $numprocs -gt 1 ]
then
  smp=1
  carry=`expr $numprocs % $SMPCPUS`
  if [ $carry -gt 0 ]
  then
    numprocs=`expr $numprocs / $SMPCPUS + 1`
  else
    numprocs=`expr $numprocs / $SMPCPUS`
  fi
else
  smp=0
fi

while [ "$numprocs" -gt "0" ]
do
  cd /etc/folding/$numprocs
  if [ $smp -eq 1 ]
  then
    ./fah6 -local -forceasm -oneunit -smp $SMPCPUS > /dev/null 2>&1 &
  else
    ./fah6 -local -forceasm -oneunit > /dev/null 2>&1 &
  fi

  numprocs=`expr $numprocs - 1`
done

echo "Done.<p>"
echo "Click <a href="/">here</a> to return to the main page."
echo "</body></html>"
echo ""
