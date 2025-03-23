#!/bin/bash
flag=${1:-0}

case "$flag" in
    0)
        make 
        gdb bin -x ../gdb_script.txt
        make clean
        ;;
    1)
        make SORT=1
        gdb bin -x ../gdb_script.txt
        make clean
        ;;
esac
