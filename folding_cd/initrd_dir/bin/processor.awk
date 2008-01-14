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
	"uname -m" | getline arch
        if (arch == "x86_64") {
          bits=64
        } else {
          bits=32
        }
        if (count == 1) {
	  printf "Found 1 %dbit processor\n",bits
	  printf "Found 1 %dbit processor<BR>\n",bits >> "/etc/header.html"
	} else {
          printf "Found %d %dbit processors\n",count,bits
          printf "Found %d %dbit processors<BR>\n",count,bits >> "/etc/header.html"
	}
	printf "\nProgress:\n"
	printf"<BR><B>Progress</B><BR>\n" >> "/etc/header.html"
}
