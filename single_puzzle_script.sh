#!/bin/bash

python sud2sat2.py < puzzle.txt > puzzle.cnf
minisat puzzle.cnf assign.txt > stat.txt
python sat2sud.py < assign.txt > solution.txt
