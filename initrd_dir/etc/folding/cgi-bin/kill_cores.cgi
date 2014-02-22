#!/bin/sh
# kill_cores.cgi - Invokes kill_cores.sh and returns to the index page

cd /bin
kill_cores.sh $QUERY_STRING

echo "Content-type: text/html"
echo ""
echo "<html><head><META HTTP-EQUIV=\"Refresh\" CONTENT=\"60;URL=/\">"
echo "<SCRIPT LANGUAGE=\"JavaScript\"><!--"
echo "function redirect () { setTimeout(\"go_now()\",60000); }"
echo "function go_now ()   { window.location.href = \"/\"; }"
echo "//--></SCRIPT></head>"
echo "<body onLoad \"redirect()\">"
echo "Folding cores for instance $QUERY_STRING killed."
echo "<BR>This page will refresh back to the main page for this diskless folder in 60 seconds."
echo "<BR>If this does not work, click <a href="/">here</a>."
echo "</body></html>"
echo ""
