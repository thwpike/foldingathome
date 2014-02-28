#!/bin/sh

start_tinker ()
{
echo "Starting benchmark of Tinker WU"
echo "Starting benchmark of Tinker WU<BR>" >> /etc/header.html
cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
cd /etc/fold.tinker
/etc/fold.tinker/FAH502-Linux.exe -forceasm -advmethods > /dev/null 2>&1 &
echo $! > /tmp/tinker.pid
bench_start=`expr $bench_start + 1`
free_procs=`expr $free_procs - 1`
}

start_amber ()
{
echo "Starting benchmark of Amber WU"
echo "Starting benchmark of Amber WU<BR>" >> /etc/header.html
cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
cd /etc/fold.amber
/etc/fold.amber/FAH502-Linux.exe -forceasm -advmethods > /dev/null 2>&1 &
echo $! > /tmp/amber.pid
bench_start=`expr $bench_start + 1`
free_procs=`expr $free_procs - 1`
}

start_bonusgromacs ()
{
echo "Starting benchmark of Gromacs WU"
echo "Starting benchmark of Gromacs WU<BR>" >> /etc/header.html
cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
cd /etc/fold.bonusgromacs
/etc/fold.bonusgromacs/FAH502-Linux.exe -forceasm -advmethods > /dev/null 2>&1 &
echo $! > /tmp/bonusgromacs.pid
bench_start=`expr $bench_start + 1`
free_procs=`expr $free_procs - 1`
}

start_gromacs33 ()
{
echo "Starting benchmark of Gromacs3.3 WU"
echo "Starting benchmark of Gromacs3.3 WU<BR>" >> /etc/header.html
cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
cd /etc/fold.gromacs33
/etc/fold.gromacs33/FAH502-Linux.exe -forceasm -advmethods > /dev/null 2>&1 &
echo $! > /tmp/gromacs33.pid
bench_start=`expr $bench_start + 1`
free_procs=`expr $free_procs - 1`
}

check_tinker ()
{
grep -q '([ \t]*2[ \t]*)' /etc/fold.tinker/FAHlog.txt
if [ $? -eq 0 ]
then
  echo "Finished benchmark of Tinker WU"
  echo "Finished benchmark of Tinker WU<BR>" >> /etc/header.html
  if [ $bench_start -lt 4 ] && [ $bench_done -lt 3 ]
  then
    kill `cat /tmp/tinker.pid`
  else
    echo "Leaving Tinker WU running to load the processor"
    echo "Leaving Tinker WU running to load the processor<BR>" >> /etc/header.html
  fi
  rm /tmp/tinker.pid
  bench_done=`expr $bench_done + 1`
  free_procs=`expr $free_procs + 1`
  awk -f /bin/bench.tinker.awk /etc/fold.tinker/FAHlog.txt
  cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
fi
}

check_amber ()
{
grep -q '([ \t]*1[ \t]*\(%\|percent\)[ \t]*)' /etc/fold.amber/FAHlog.txt
if [ $? -eq 0 ]
then
  echo "Finished benchmark of Amber WU"
  echo "Finished benchmark of Amber WU<BR>" >> /etc/header.html
  if [ $bench_start -lt 4 ] && [ $bench_done -lt 3 ]
  then
    kill `cat /tmp/amber.pid`
  else
    echo "Leaving Amber WU running to load the processor"
    echo "Leaving Amber WU running to load the processor<BR>" >> /etc/header.html
  fi
  rm /tmp/amber.pid
  bench_done=`expr $bench_done + 1`
  free_procs=`expr $free_procs + 1`
  awk -f /bin/bench.amber.awk /etc/fold.amber/FAHlog.txt
  cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
fi
}

check_bonusgromacs ()
{
grep -q '([ \t]*1[ \t]*\(%\|percent\)[ \t]*)' /etc/fold.bonusgromacs/FAHlog.txt
if [ $? -eq 0 ]
then
  echo "Finished benchmark of Gromacs WU"
  echo "Finished benchmark of Gromacs WU<BR>" >> /etc/header.html
  if [ $bench_start -lt 4 ] && [ $bench_done -lt 3 ]
  then
    kill `cat /tmp/bonusgromacs.pid`
  else
    echo "Leaving Gromacs WU running to load the processor"
    echo "Leaving Gromacs WU running to load the processor<BR>" >> /etc/header.html
  fi
  rm /tmp/bonusgromacs.pid
  bench_done=`expr $bench_done + 1`
  free_procs=`expr $free_procs + 1`
  awk -f /bin/bench.bonusgromacs.awk /etc/fold.bonusgromacs/FAHlog.txt
  cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
fi
}

check_gromacs33 ()
{
grep -q '([ \t]*1[ \t]*\(%\|percent\)[ \t]*)' /etc/fold.gromacs33/FAHlog.txt
if [ $? -eq 0 ]
then
  echo "Finished benchmark of Gromacs3.3 WU"
  echo "Finished benchmark of Gromacs3.3 WU<BR>" >> /etc/header.html
  if [ $bench_start -lt 4 ] && [ $bench_done -lt 3 ]
  then
    kill `cat /tmp/gromacs33.pid`
  else
    echo "Leaving Gromacs3.3 WU running to load the processor"
    echo "Leaving Gromacs3.3 WU running to load the processor<BR>" >> /etc/header.html
  fi
  rm /tmp/gromacs33.pid
  bench_done=`expr $bench_done + 1`
  free_procs=`expr $free_procs + 1`
  awk -f /bin/bench.gromacs33.awk /etc/fold.gromacs33/FAHlog.txt
  cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
fi
}

failed_download ()
{
  echo -e "\n\n\nFailed to download the client from Stanford's website."
  echo ""
  echo "Please double check your Gateway and DNS information"
  echo "and reboot afterwards."
  echo "Gateway: " `route -n | awk '/^0.0.0.0/ {print $2}'`
  echo "DNS servers: " `awk '{print $2}' /etc/resolv.conf`
  while  [ 1 ]
  do
    sleep 86400
  done
}

# Main begins here, we are in /etc/folding and httpd is already running
# Start by downloading the necessary code
wget http://www.stanford.edu/group/pandegroup/release/FAH502-Linux.exe
if [ $? -eq 1 ]
then
  failed_download
fi
wget http://www.stanford.edu/~pande/Linux/x86/Core_65.fah
if [ $? -eq 1 ]
then
  failed_download
fi
wget http://www.stanford.edu/~pande/Linux/x86/Core_78.fah
if [ $? -eq 1 ]
then
  failed_download
fi
wget http://www.stanford.edu/~pande/Linux/x86/Core_82.fah
if [ $? -eq 1 ]
then
  failed_download
fi
wget http://www.stanford.edu/~pande/Linux/x86/Core_a0.fah
if [ $? -eq 1 ]
then
  failed_download
fi

tail -c +513 Core_65.fah > core_65.fah.bz2
tail -c +513 Core_78.fah > core_78.fah.bz2
tail -c +513 Core_82.fah > core_82.fah.bz2
tail -c +513 Core_a0.fah > core_a0.fah.bz2
bunzip2 core_65.fah.bz2
bunzip2 core_78.fah.bz2
bunzip2 core_82.fah.bz2
bunzip2 core_a0.fah.bz2
chmod 755 FAH502-Linux.exe core_*.fah

echo
echo
echo "Folding Benchmark CD"
echo "Copyright notfred 2006-2008"
echo "See http://reilly.homeip.net/folding"
echo "Results are shown below and on the web at http://"`cat /tmp/myip`
echo
echo

awk -f /bin/processor.awk /proc/cpuinfo

# Create the remote reboot files
if [ "$REBOOT" = "enabled" ]
then

cat << EOF > reboot.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=iso-8859-1">
<TITLE>Reboot</TITLE>
</HEAD>
<BODY LANG="en-US" DIR="LTR">
<P ALIGN=LEFT><FONT SIZE=3>Click <a href="cgi-bin/reboot.cgi">here</a> to reboot this diskless folder.</FONT></P> 
<P ALIGN=LEFT><FONT SIZE=3>Click <a href="/">here</a> to return to the homepage.</FONT></P>
</BODY></HTML>
EOF

cat << EOF > /bin/do_reboot.sh
#!/bin/sh
/bin/sleep 1
/bin/reboot -f
EOF
chmod 755 /bin/do_reboot.sh

cat << EOF > cgi-bin/reboot.cgi
#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "<html><head><META HTTP-EQUIV=\"Refresh\" CONTENT=\"90;URL=/\">"
echo "<SCRIPT LANGUAGE=\"JavaScript\"><!--"
echo "function redirect () { setTimeout(\"go_now()\",90000); }"
echo "function go_now ()   { window.location.href = \"/\"; }"
echo "//--></SCRIPT></head>"
echo "<body onLoad \"redirect()\">"
echo "Remote reboot command sent."
echo "<BR>This page will refresh back to the main page for this diskless folder in 90 seconds."
echo "<BR>If this does not work, click <a href="/">here</a>."
echo "</body></html>"
echo ""
/bin/do_reboot.sh > /dev/null 2>&1 &
EOF
chmod 755 cgi-bin/reboot.cgi

else 
cat << EOF > reboot.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=iso-8859-1">
<TITLE>Reboot</TITLE>
</HEAD>
<BODY LANG="en-US" DIR="LTR">
<P ALIGN=LEFT><FONT SIZE=3>Reboot is disabled.</FONT></P>
<P ALIGN=LEFT><FONT SIZE=3>Click <a href="/"here</a> to return to the homepage.</FONT></P>
</BODY></HTML>
EOF
fi

# Create the remote poweroff files
if [ "$POWEROFF" = "enabled" ]
then

cat << EOF > poweroff.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=iso-8859-1">
<TITLE>Poweroff</TITLE>
</HEAD>
<BODY LANG="en-US" DIR="LTR">
<P ALIGN=LEFT><FONT SIZE=3>Click <a href="cgi-bin/poweroff.cgi">here</a> to poweroff this diskless folder.</FONT></P> 
<P ALIGN=LEFT><FONT SIZE=3>Click <a href="/">here</a> to return to the homepage.</FONT></P>
</BODY></HTML>
EOF

cat << EOF > /bin/do_poweroff.sh
#!/bin/sh
/bin/sleep 1
/bin/poweroff -f
EOF
chmod 755 /bin/do_poweroff.sh

cat << EOF > cgi-bin/poweroff.cgi
#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "<html><body>Remote poweroff command sent.</body></html>"
echo ""
/bin/do_poweroff.sh > /dev/null 2>&1 &
EOF
chmod 755 cgi-bin/poweroff.cgi

else 
cat << EOF > poweroff.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=iso-8859-1">
<TITLE>Poweroff</TITLE>
</HEAD>
<BODY LANG="en-US" DIR="LTR">
<P ALIGN=LEFT><FONT SIZE=3>Poweroff is disabled.</FONT></P>
<P ALIGN=LEFT><FONT SIZE=3>Click <a href="/">here</a> to return to the homepage.</FONT></P>
</BODY></HTML>
EOF
fi

cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html

num_procs=`grep -c ^processor /proc/cpuinfo`
free_procs=$num_procs
bench_start=0
bench_done=0

# Use up extra processors
cd /etc
while [ $free_procs -gt 4 ]
do
  load_procs=`expr $num_procs + 1 - $free_procs`
  echo "Loading processor $load_procs"
  echo "Loading processor $load_procs<BR>" >> /etc/header.html
  cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
  mkdir -p load_$load_procs
  if [ `expr $load_procs % 4` -eq 0 ]
  then
    cd /etc/fold.tinker
    cp -dR * ../load_$load_procs
  elif [ `expr $load_procs % 4` -eq 1 ]
  then
    cd /etc/fold.amber
    cp -dR * ../load_$load_procs
  elif [ `expr $load_procs % 4` -eq 2 ]
  then
    cd /etc/fold.bonusgromacs
    cp -dR * ../load_$load_procs
  else
    cd /etc/fold.gromacs33
    cp -dR * ../load_$load_procs
  fi 
  cd ../load_$load_procs
  /etc/load_$load_procs/FAH502-Linux.exe -forceasm -advmethods > /dev/null 2>&1 &
  safety=0
  while [ ! -f /tmp/fah/* ]
  do
    echo "Waiting for folding to start"
    sleep 1
    safety=`expr $safety + 1`
    if [ $safety -gt 10 ]
    then
      killall FAH502-Linux.exe
      echo "Benchmarking error - some processes failed to start. Please reboot ..."
      echo "Benchmarking error - some processes failed to start. Please reboot ...<BR>" >> /etc/header.html
      cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
      while [ 1 ]
      do
        sleep 3600
      done
    fi
  done
  rm -f /tmp/fah/*
  cd ..
  free_procs=`expr $free_procs - 1`
done 

# Real benchmark
while [ $bench_done -lt 4 ]
do
  if [ $free_procs -gt 0 ] && [ $bench_start -lt 4 ]
  then
    case $bench_start in
      0) start_tinker;;
      1) start_amber;;
      2) start_bonusgromacs;;
      3) start_gromacs33;;
    esac
  else
    sleep 60
    num_folding=`ps -ww | grep FAH502-Linux.exe | grep -v grep | wc -l`
    if [ $num_folding -lt $num_procs ]
    then
      killall FAH502-Linux.exe
      echo "Benchmarking error - some processes died. Please reboot ..."
      echo "Benchmarking error - some processes died. Please reboot ...<BR>" >> /etc/header.html
      cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
      while [ 1 ]
      do
        sleep 3600
      done
    fi
    if [ -f /tmp/tinker.pid ]
    then
      check_tinker
    fi
    if [ -f /tmp/amber.pid ]
    then
      check_amber
    fi
    if [ -f /tmp/bonusgromacs.pid ]
    then
      check_bonusgromacs
    fi
    if [ -f /tmp/gromacs33.pid ]
    then
      check_gromacs33
    fi
  fi
done

echo
echo
awk -f /bin/average.awk /etc/results
echo
echo
killall FAH502-Linux.exe
echo "Benchmarking complete. Please reboot ..."
echo "Benchmarking complete. Please reboot ...<BR>" >> /etc/header.html
cat /etc/header.html /etc/results.html /etc/footer.html > /etc/folding/index.html
while [ 1 ]
do
    sleep 3600
done
