
#!/bin/bash

###################################################################################################################################
# This script has been used to search for ARM and VF genes on the polished assembly with the program abricate more info < --link-- >

# It is important to note that it has been designed for a specific working directory. Therefore, the reproduction of the results
# will require small modifications of the script or the adaptation of your working directory.

# Created on Wednesday January 28th 2022.

# @author: Julio Cesar Ortega Camabara - School of Environment, TSU.

# Version: 1
####################################################################################################################################

# ENV VARIABLES
source /home/julio92-c/anaconda3/etc/profile.d/conda.sh

# Create the following list:
# -DIR contains the dataset information. The structure of the information contained in DIR is: (Name). For example: (Escherichia_coli).
DIR=(Lens Lorraine LPE509 NY23 NY24 OLDA Paris Philadelphia_1
Pontiac Thunder_Bay)

DBs=(ncbi card argannot resfinder megares ecoh plasmidfinder ecoli_vf vfdb)

figlet Mass screnning of ARM and VFs genes|pv -qL 500

echo
echo "Features:"|pv -qL 10
echo "> It only supports contigs, not FASTQ reads"|pv -qL 10
echo "> It only detects acquired resistance genes, NOT point mutations"|pv -qL 10
echo "> It uses a DNA sequence database, not protein"|pv -qL 10
echo "> It needs BLAST+ >= 2.7 and any2fasta to be installed"|pv -qL 10
echo "> It's written in Perl"|pv -qL 10
echo "> URL: https://github.com/tseemann/abricate"|pv -qL 10

echo -e "\n\n"---------------------------STARTING----------------------------

# Activate the conda env
conda activate abricate
echo
abricate --version
echo "DBs: ncbi card argannot resfinder megares ecoh plasmidfinder ecoli_vf vfdb"

for ((i=0; i<=${#DIR[@]}-1; i++)); do


        # Check the existence of directory.
        FOLDER=${DIR[$i]}
        if [ -d $FOLDER ]; then
                echo -e "\n\n"DIR: $FOLDER
                echo
                cd $FOLDER
        else
                echo $FOLDER "doesn't exist"
        echo -e "\n\n"Creating dir $FOLDER ...
        echo $FOLDER was succefully created
        mkdir $FOLDER
                echo -------------------------------------------------------------------------------------------------------
                continue
        fi

        # Check the existence of dataset file.
	 # The dataset file name has always the same structure: dataset name like (dir_name).fasta
        #FILE=${DIR[$i]}_genomic_reference.gb
        FILE1=${DIR[$i]}.fasta

        for ((j=0; j<=${#DBs[@]}-1; j++)); do

        db=${DBs[$j]}


        if [ -s $FILE1 ]; then

                # Run stats on Genomic Dataset
                echo -e "\n\n"DB: $db
                echo -e "\n\n"FILE: $FILE1

                echo
                echo "Starting ARM and VFs annotation..."
                abricate $FILE1 --db $db --csv > ${DBs[$j]}.csv


        else

                 echo $FILE1 "doesn't exist"

         fi
        done
        echo -----------------------------------------------------------------
        cd ../
done

conda deactivate

echo -e "\n\n"---------------------------DONE---------------------------------

figlet "Thanks for watching!" |pv -qL 500
