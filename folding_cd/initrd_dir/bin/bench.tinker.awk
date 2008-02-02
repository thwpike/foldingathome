# This is for a 241 point 400 frame Tinker WU

/^\[[0-9:]+\] Folding@Home Client Core Version/ {
  version = $5 " " $6 " " $7 " " $8 " " $9
}

/\([ \t]*1[ \t]*\)/ {
  split($1,A,"[\]\:\[]")
  initial = A[2] * 3600 + A[3] * 60 + A[4]
}

/\([ \t]*2[ \t]*\)/ {
  split($1,B,"[\]\:\[]")
  final = B[2] * 3600 + B[3] * 60 + B[4]
  diff = final - initial
  if (diff <= 0) {
    diff = 24 * 3600 + diff
  }
  print "Tinker " version " " 0.6025 * 3600 / diff " points per hour, " 0.6025 * 3600 * 24 / diff " points per day"
  print "<tr>" >> "/etc/results.html"
  print "<td>Tinker</td>" >> "/etc/results.html"
  print "<td>" version "</td>" >> "/etc/results.html"
  print "<td>" 0.6025 * 3600 / diff "</td>" >> "/etc/results.html"
  print "<td>" 0.6025 * 3600 * 24 / diff "</td>" >> "/etc/results.html"
  print "</tr>" >> "/etc/results.html"
  print 0.6025 * 3600 / diff " " 0.6025 * 3600 * 24 / diff >> "/etc/results"
}
