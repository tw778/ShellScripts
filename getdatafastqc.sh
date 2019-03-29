# Travis White BMMB852, Modification of a Recipe
# 
# This recipe downloads sequencing data from an NCBI project and performs fastqc on the files.
#

#
# The script limits the number of runs and the number of reads that it unpacks from each run.

# ****This script has been modified to accept command line arguments when it is ran intead of using
# default settings within the script. This way users can enter whichever bioproject they would like,
# and they can also view any number of reads and runs that they desire without having to edit the file.****

# Stop on any error. Print the commands as they execute.
set -uex

# NCBI BioProject ID. Enter the desired 'PRJ' bioproject ID after the name of the script-- follow it with a space.
PRJN=$1

# How many sequencing runs to get for the project. Enter the number of runs you would like to examine after the PRJ number. Follow it with a space.
RUNS=$2

# How many reads to download from each run. Enter the number of reads to download after the number of runs.
READS=$3

# An example: bash thisscriptname.sh PRJ000 2 1000

# Obtain the run information.
esearch -db sra -query $PRJN | efetch -format runinfo > runinfo.csv

# Obtain the first few SRR numbers.
cat runinfo.csv | cut -f 1 -d , | grep SRR | head -$RUNS > runids.txt

# Create a directory for the sequencing data.
mkdir -p reads

# Download the FASTQ data for each SRR number.
cat runids.txt | parallel fastq-dump --split-files -X $READS -outdir reads {}

# Save quality control plots into a separate directory.
mkdir -p fastqc

# Run fastqc on each file. Generate the output into the fastqc directory.
fastqc -o fastqc reads/*.fastq



# Remove zip files created by fastqc
rm -f fastqc/*.zip
