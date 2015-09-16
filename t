#!/usr/bin/awk -f

BEGIN { FS = OFS = "\t"; RS="\n" }
{
    if (max < NF) max = NF
    for (i = 1; i <= NF; ++i) {
        values[NR","i] = $i
    }
}
END {
    for (j=1; j <= max; ++j) {
        for (i=1; i <= NR; ++i) {
            printf "%s", values[i","j]
            if (i != NR) printf OFS
        }
        printf RS
    }
}
