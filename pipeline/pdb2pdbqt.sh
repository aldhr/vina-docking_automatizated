#!/usr/bin/bash

# prepare targets script
prepare_receptor="/home/ahr/Desktop/docking/utils/ADT_scripts/prepare_receptor4.py"

if (( $# != 2 )); then
        echo "Usage: ./pdb2pdbqt.sh receptor.pdb receptor.pdbqt"
        exit 1
fi

pdb=$1
pdbqt=$2

echo "Converting target file: $pdb to $pdbqt"
$MGLPY "$prepare_receptor" -r "$pdb" -o "$pdbqt"
echo "Done! "
