#!/bin/bash

cd $(dirname "$0")

echo "Status for root workspace:"
(git status)
echo "------------------------------------"
    
for i in src/*;
do
    echo "Status for: $i:"
    (cd $i ; git status)
    echo "------------------------------------"
done


