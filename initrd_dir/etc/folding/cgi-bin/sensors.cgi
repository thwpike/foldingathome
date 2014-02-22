#!/bin/sh
# sensors.cgi - invokes sensors

echo "Content-type: text/html"
echo ""
echo "<html><body>"
/bin/sensors
echo "</body></html>"
echo ""
