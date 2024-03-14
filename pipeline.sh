#1 user configuration################################################
targets=(RBD)

## requiered files ##do not add "/" at the end
datestamp=$(date +"%Y-%m-%d") 

conf=vina.conf                                   ###vina conf file 
target=target/${targets}/${targets}.pdb          ##pdb file
targetqt=target/${targets}/${targets}.pdbqt      ##pdbqt file
ligs=ligands                                     ##folder with ligands
out_folder=results                               ##folder within pdbqt out files
log_folder=logs_$datestamp                       ##folder within logs needed for making csv
num_cycles=100                                   ##number of cycles to run [if restart, extra cycles to run]
###check carefully the next cycle number to run
###hint: you might check at the last pdbqt file save it in results
restart_cycles=1                                 ##next cycle number to run


####switch on or off depending of processing
##prepare ligands 
#bash pipeline/mol2pdbqt.sh ${ligs} ${ligs} 

##prepare target
#bash pipeline/pdb2pdbqt.sh ${target} ${target}qt 

##do docking
#nohup bash pipeline/dock.sh "${conf}" "${targetqt}" "${ligs}" "${out_folder}" "${log_folder}" "${num_cycles}" "${restart_cycles}" &

##convert output to mol2
# obabel -i pdbqt results/*.pdbqt -o mol2 -O results/*.mol2
# rm results/*pdbqt

##analysis
bash pipeline/logs2csv.sh "$log_folder" "scores.csv" "$num_cycles" "$restart_cycles"
#################################################################################

