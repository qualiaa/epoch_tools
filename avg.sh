#!/bin/bash
# avg.sh: generate barcharts of averages from output of tabulate.sh

width=0.5
plotfile="/var/tmp/plotfile"
temp="/var/tmp/temp.dat"

for file in "$@"; do
    cat  > "$plotfile" <<HEAD
set boxwidth $width
set style fill solid
set style line 1 lc rgb "#ff9999"
set style line 2 lc rgb "#dd8080"
set yrange [0:]
unset key

plot "$temp" u :2:xtic(1) w boxes ls 2
HEAD

    # add position column to data
    awk '
    BEGIN { OFS="\t" }
    { 
        avg = 0
        for (i=2; i <= NF; ++i) {
            avg += $i
        }
        avg /= NF - 2
        gsub(/_/," ",$1)
        printf("\"%s\"\t%g\n", $1, avg)
    }
    ' $file > $temp

    gnuplot -p $plotfile
done
