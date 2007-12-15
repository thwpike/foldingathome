BEGIN {
	printf "Processor Detection\n"
	printf "<B>Processor Detection</B><BR>\n" >> "/etc/header.html"
}

/^processor\t: / {
	processor=$3
	count++
}

/^model name\t: / {
	sub("^model name\t: ", "")
	printf "Processor %d is an %s\n",processor,$0
	printf "Processor %d is an %s<BR>\n",processor,$0 >> "/etc/header.html"
}

END {
	printf "Found %d processor(s)\n",count
	printf "Found %d processor(s)<BR>\n",count >> "/etc/header.html"
	printf "\nProgress\n"
	printf"<BR><B>Progress</B><BR>\n" >> "/etc/header.html"
}
