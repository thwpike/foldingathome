# This is for a 135 point Amber WU

/\([ \t]*7[ \t]*(%|percent)[ \t]*\)/ {
  split($1,A,"[\]\:\[]")
  initial = A[2] * 3600 + A[3] * 60 + A[4]
}

/\([ \t]*8[ \t]*(%|percent)[ \t]*\)/ {
  split($1,B,"[\]\:\[]")
  final = B[2] * 3600 + B[3] * 60 + B[4]
  diff = final - initial
  if (diff <= 0) {
    diff = 24 * 3600 + diff
  }
  print "Amber " 1.35 * 3600 / diff " points per hour, "  1.35 * 3600 * 24 / diff " points per day"
  print "<tr>" >> "/etc/results.html"
  print "<td>Amber</td>" >> "/etc/results.html"
  print "<td>" 1.35 * 3600 / diff "</td>" >> "/etc/results.html"
  print "<td>" 1.35 * 3600 * 24 / diff "</td>" >> "/etc/results.html"
  print "</tr>" >> "/etc/results.html"
  print 1.35 * 3600 / diff " " 1.35 * 3600 * 24 / diff >> "/etc/results"
}
