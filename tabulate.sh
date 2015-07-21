#!/bin/bash
# tabulate.sh: tabulate timing data from multiple epoch runs

corefile="core.dat"
timefile="time.dat"

mtos () {
    awk '{ print 60*$1 + $2 }'
}

data_dirs () {
    ls "$1" | grep -E "^[[:digit:]]+$"
}

process () {
    local dir=$1
    cat $dir/time.out \
        | sed -En 's/^real *(.*)m(.*)s$/\1 \2/p' \
        | mtos \
        >> "$timefile"

    cat $dir/out \
        | sed -En '/runtime/{ s/^.*= //;s/ *minutes,//;s/ *seconds//p }' \
        | mtos \
        >> "$corefile"

}

to_table () {
    sed -i '
    /^$/!{
        H
        d
    }
    /^$/{
        x
        s/\n/\t/g
        s/^\t//
    }' $1
}

if [ $# -eq 0 ]; then
    set - $(ls -d */)
    echo $@
fi

: > $corefile
: > $timefile

for build in "$@"; do
    title="${build%_*proc*}"
    title="${title%_sp}"
    echo $title >> $timefile
    echo $title >> $corefile
    if [ -d "${build}/1" ]; then
        for n in $(data_dirs "$build"); do
            dir="${build}/$n"
            process "$dir"
        done
    else
        process "$build"
    fi

    echo >> $corefile
    echo >> $timefile
done

to_table $corefile
to_table $timefile
