// {
	count++
	pph = pph + $1
	ppd = ppd + $2
}

END {
	"/bin/grep -c ^processor /proc/cpuinfo" | getline processors
	print "Average is " pph / count " Points Per Hour, " ppd / count " Points Per Day"
	print "<tr>" >> "/etc/results.html"
	print "<td>Average</td><td></td>" >> "/etc/results.html"
	print "<td>" pph / count "</td>" >> "/etc/results.html"
	print "<td>" ppd / count "</td>" >> "/etc/results.html"
	print "</tr>" >> "/etc/results.html"
        print "Total is " pph * processors / count " Points Per Hour, " ppd * processors / count " Points Per Day"
        print "<tr>" >> "/etc/results.html"
        print "<td>Total</td><td></td>" >> "/etc/results.html"
        print "<td>" pph * processors / count "</td>" >> "/etc/results.html"
        print "<td>" ppd * processors / count "</td>" >> "/etc/results.html"
        print "</tr>" >> "/etc/results.html"
}
