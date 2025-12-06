#!/bin/bash

cd $(dirname "$0")

(git pull)
echo "------------------------------------"
    
for i in src/*;
do
    echo "Pull " $i
    (cd $i ; git pull)
    echo "------------------------------------"
done


