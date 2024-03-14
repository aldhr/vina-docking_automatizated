#!/usr/bin/bash

# Vina location
vina=/usr/bin/vina

if (( $# != 7 )); then
    echo "Usage: ./dock.sh vina.conf receptor.pdbqt ligs_pdbqt_folder out_folder log_folder cycles restart_cycles"
    exit 1
fi

# Run docking
conf=$1       # Vina configuration file
rec=$2        # Receptor file
pdbqt_folder=$3   # Folder containing all ligands
out_folder=$4  # Folder for docking results
log_folder=$5  # Docking logs
num_cycles=$6
restart_cycles=$7

#date
datestamp=$(date +"%Y-%m-%d") 
start_time=$(date +%s) ##to measure time of computing


##run info to save at run file
echo "Molecular Docking begins..." >> "$log_folder/run_$datestamp.txt"
echo "Target: $rec" >> "$log_folder/run_$datestamp.txt"

for lig in $pdbqt_folder/*.pdbqt; do
    ligname=$(basename "$lig" .pdbqt)
    echo "ligand: $ligname" >> "$log_folder/run_$datestamp.txt"
done

echo "Run date: $datestamp" >> "$log_folder/run_$datestamp.txt"
echo "This might take a while because we are running $cycles docking cycles" >> "$log_folder/run_$datestamp.txt"
echo "$f" >> "$log_folder/run_$datestamp.txt"
echo "Find the pdbqt out files at $out_folder" >> "$log_folder/run_$datestamp.txt"
echo "Find the logs at $log_folder" >> "$log_folder/run_$datestamp.txt"
echo "$f" >> "$log_folder/run_$datestamp.txt"
echo "This is vina configuration file: " >> "$log_folder/run_$datestamp.txt"
cat pipeline/vina.conf >> "$log_folder/run_$datestamp.txt"


##run info to save at console
echo " - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - "
echo "$f"
echo "Now, Molecular Docking begins, this might take a while."
echo "We are running several cycles of docking."
echo "Please be patient, find all relevant information at: "
echo "$log_folder/run_$datestamp.txt"
echo "$f"
echo " - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - "

## run docking
end=$((restart_cycles + num_cycles))
for ((cycle=$restart_cycles; cycle<=$end; cycle++)); do
#for cycle in $(seq 1 "$num_cycles"); do
    for lig in $pdbqt_folder/*.pdbqt
    do
        ligname=`basename $lig | cut -d'.' -f1`
        mkdir -p "$out_folder"/
        out=$out_folder/$ligname"_c$cycle.pdbqt"
        mkdir -p "$log_folder"/
        log=$log_folder/$ligname".log"
        $vina --config "$conf" --receptor "$rec" --ligand "$lig" --out "$out" >> "$log" 
    done
done

echo " - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - "
echo "$f"
echo "$((cycle - 1)) clyces of Molecular Docking have concluded" 
echo "$f"
echo " - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - "

end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
elapsed_hours=$((elapsed_time / 3600))
elapsed_minutes=$(( (elapsed_time % 3600) / 60 ))

ligands=($pdbqt_folder/*.pdbqt)

echo "$f" >> "$log_folder/run_$datestamp.txt"
echo " - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - " >> "$log_folder/run_$datestamp.txt"
echo "$f" >> "$log_folder/run_$datestamp.txt"
echo "$num_cycles clycles of molecular docking (in total: $end cycles.)" >> "$log_folder/run_$datestamp.txt"
echo "The docking of: " >> "$log_folder/run_$datestamp.txt"
echo "$rec and "${#ligands[@]}" ligands have concluded" >> "$log_folder/run_$datestamp.txt"
echo "it took $elapsed_minutes minutes" >> "$log_folder/run_$datestamp.txt"
echo "$f" >> "$log_folder/run_$datestamp.txt"
echo " - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - " >> "$log_folder/run_$datestamp.txt"
