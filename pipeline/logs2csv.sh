#!/usr/bin/bash

if (( $# != 4 )); then
    echo "Usage: ./logs2csv.sh log_folder out.csv num_cycles restart_cycles"
    exit 1
fi

log_folder=$1 # folder containing docking logs of autodock vina
out=$2
num_cycles=$3
restart_cycles=$4

# create headers
end=$((restart_cycles + num_cycles))
echo -n "ligand" > $out
for ((c=1; c<=end; c++)); do
    echo -n ", cycle$c" >> $out
done
echo "" >> $out

temp=$(mktemp)
for log in "$log_folder"/*; do
    ligname=$(basename "$log" | cut -d'.' -f1)
    scores=$(grep '^   1' "$log" | awk '{print $2}')
    echo -n "$ligname" >> "$temp"
    
    for score in $scores; do
        echo -n ", $score" >> "$temp"
    done
    
    echo "" >> "$temp"
done

sort -t ',' -k1,1 -o "$temp" "$temp"
cat "$temp" >> "$out"

rm "$temp"

##run info to save at console
echo " - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - "
echo "$f"
echo "Now, a scores.csv per cycle exist in working folder"
echo "$f"
echo " - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - "

