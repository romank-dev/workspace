#!/bin/bash

cd $(dirname "$0")

for i in src/*;
do
    echo "Status for: $i:"
    (cd $i ; git status)
    echo "------------------------------------"
done


