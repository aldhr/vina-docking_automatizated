#!/usr/bin/bash

# prepare targets script
prepare_ligand="/home/ahr/Desktop/docking/utils/ADT_scripts/prepare_ligand4.py"

if (( $# != 2 )); then
        echo "Usage: ./mol2pdbqt.sh mol2_folder pdbqt_folder"
        exit 1
fi

# Check if MGLPY is defined
if [ -z "$MGLPY" ] || ! command_exists "$MGLPY"; then
    echo "Error: MGLPY variable is not defined or MGLPY is not installed."
    exit 1
fi

# Check if mol2_folder exists
if [ ! -d "$mol2_folder" ]; then
    echo "Error: Mol2 folder '$mol2_folder' not found."
    exit 1
fi

# Check if pdbqt_folder exists, create if not
if [ ! -d "$pdbqt_folder" ]; then
    echo "Creating pdbqt_folder: $pdbqt_folder"
    mkdir -p "$pdbqt_folder"
fi

mol2_folder=$1
pdbqt_folder=$2

for f in `ls $mol2_folder/*.mol2`
do
        ligname=`basename $f | cut -d'.' -f1`
        ligname=$ligname".pdbqt"
        $MGLPY "${prepare_ligand}" -l "$f" -o "$pdbqt_folder/$ligname"
        echo $f " converted to " $pdbqt_folder/$ligname
done