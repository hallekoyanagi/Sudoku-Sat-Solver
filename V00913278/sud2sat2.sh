#!/bin/bash

touch temp.txt
touch temp1.txt

cat - > temp1.txt
python sud2sat2.py < temp1.txt > temp.txt
cat temp.txt

rm temp.txt
rm temp1.txt