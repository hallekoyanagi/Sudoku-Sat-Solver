#!/bin/bash

: '
run "bash project_euler_script.sh" to use
finds solutions to all puzzles of the form used in the given 
project euler file
gives total CPU time, avg CPU time and number of unsatisfiable
puzzles
DO NOT HAND IN
'

project_euler=`cat project_euler.txt`
filelen=${#project_euler}

curlen=0
unsatisfiable=0
CPUtime=0
totpuzzles=0

touch solution.txt

while [ $curlen -le $filelen ]
do
  puzzle=${project_euler:curlen+7:90}
  curlen=$((curlen + 98))

  echo "$puzzle" > curpuzzle.txt
  python sud2sat.py < curpuzzle.txt > puzzle.cnf
  minisat puzzle.cnf assign.txt > stat.txt
  python sat2sud.py < assign.txt > cursol.txt
  cat solution.txt cursol.txt > temp.txt
  cat temp.txt > solution.txt

  # isolate the current iterations CPU time from stat.txt
  stat=`cat stat.txt`

  cat stat.txt | grep -E 'CPU time' > temp.txt
  temp=`cat temp.txt`
  cut -d ":" -f 2 <<< $temp > temp.txt
  temp=`cat temp.txt`
  cut -d "s" -f 1 <<< $temp > temp.txt
  temp=`cat temp.txt`
  CPUtime=$(echo "$CPUtime + $temp"|bc)

  # find if unsatisfiable
  cat stat.txt | grep -E 'SATISFIABLE' > temp.txt
  temp=`cat temp.txt`
  if [ $temp = "UNSATISFIABLE" ]
  then
    unsatisfiable=$((unsatisfiable + 1))
  fi

  totpuzzles=$((totpuzzles+1))
done

# calculate avg cpu time
CPUavg=$(echo "$CPUtime/$totpuzzles"|bc)
bc <<< 'scale=6' $CPUtime/$totpuzzles > temp.txt

echo "Total Puzzles Evaluated: $totpuzzles"
echo "Total Unsatisfiable Puzzles: $unsatisfiable"
echo "Total CPU Time: $CPUtime s"
echo "Average CPU Time: $CPUavg s"

rm temp.txt
rm cursol.txt
rm curpuzzle.txt
