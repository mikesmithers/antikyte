#!/bin/sh
# Difference between files in two directories
orig_dir=$1
new_dir=$2

TMPFILE1=$(mktemp)
TMPFILE2=$(mktemp)

for file in $orig_dir/*
do 
    sort $file |sum >> $TMPFILE1
done

for file in $new_dir/*
do
    sort $file|sum >>$TMPFILE2
done 
diff -qs $TMPFILE1 $TMPFILE2

is_same=$?

if [ $is_same -eq 1 ] 
then
    echo 'Files do not match'
else 
    echo 'Files are identical'
fi 

#delete the temporary files before exiting, even if we hit an error
trap 'rm -f $TMPFILE1 $TMPFILE2' exit
