# This is for a 600 point Gromacs Bonus WU, but we report it without the
# bonus, i.e. as a 300 point Gromacs

/\([ \t]*0[ \t]*(%|percent)[ \t]*\)/ {
  split($1,A,"[\]\:\[]")
  initial = A[2] * 3600 + A[3] * 60 + A[4]
}

/\([ \t]*1[ \t]*(%|percent)[ \t]*\)/ {
  split($1,B,"[\]\:\[]")
  final = B[2] * 3600 + B[3] * 60 + B[4]
  diff = final - initial
  if (diff <= 0) {
    diff = 24 * 3600 + diff
  }
  print "Gromacs " 3 * 3600 / diff " points per hour, " 3 * 3600 * 24 / diff " points per day"
  print "<tr>" >> "/etc/results.html"
  print "<td>Gromacs</td>" >> "/etc/results.html"
  print "<td>" 3 * 3600 / diff "</td>" >> "/etc/results.html"
  print "<td>" 3 * 3600 * 24 / diff "</td>" >> "/etc/results.html"
  print "</tr>" >> "/etc/results.html"
  print 3 * 3600 / diff " " 3 * 3600 * 24 / diff >> "/etc/results"
}
