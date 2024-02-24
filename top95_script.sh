#!/bin/bash

: '
run "bash top95_script.sh" to use
finds solutions to all puzzles of the form used in the given 
top95 file
gives total CPU time, avg CPU time and number of unsatisfiable
puzzles
DO NOT HAND IN
'

top95=`cat top95.txt`
filelen=${#top95}

curlen=0
unsatisfiable=0
CPUtotal=0
CPUworst=0
totpuzzles=0

rm solution.txt
touch solution.txt

while [ $curlen -le $filelen ]
do
  puzzle=${top95:curlen:82}
  curlen=$((curlen + 82))
  
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
  CPUtotal=$(echo "$CPUtotal + $temp"|bc)

  # find if worst CPU time
  if (($(echo "$CPUworst < $temp"|bc -l)))
  then
    CPUworst=$temp
  fi

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
bc -l <<< "scale=6; $CPUtotal / $totpuzzles" > temp.txt
CPUavg=`cat temp.txt`

echo "Total Puzzles Evaluated: $totpuzzles"
echo "Total Unsatisfiable Puzzles: $unsatisfiable"
echo "Total CPU Time: $CPUtotal s"
echo "Worst CPU Time: $CPUworst s"
echo "Average CPU Time: 0$CPUavg s"

rm temp.txt
rm cursol.txt
rm curpuzzle.txt
