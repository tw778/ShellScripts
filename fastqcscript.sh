
# Travis White BMMB852 Write a Unix Script that Performs Data Analysis
# Documentation: This script creates fastqc files and trims a user-defined SRR file to the user's specifications.
# To run, enter: bash fastqscript.sh (SRR ID) (Number of Reads) (Desired Quality Score Threshold) 
# Note: SLIDINGWINDOW default is set to 4, only the quality threshold can be changed.
# Note: this script is designed for PAIRED END datasets.
#
# Print errors.

set -uex

#
# Set SRR ID.
#
SRR=$1

#
# Set read limit.
#
LIMIT=$2

#
# Set QC threshold.
#
QC=$3

#
# Fastq data dump from user-defined SRR file.
# Read limit entered by user will be used.
#
fastq-dump --split-files -X ${LIMIT} ${SRR}

#
# Run the fastqc report on dumped files.
# These files should appear in your working directory, the html file contains the charts.
# These files represent the data before trimming.
#
fastqc ${SRR}_1.fastq ${SRR}_2.fastq

#
# Apply trimmomatic.
#
trimmomatic PE ${SRR}_1.fastq ${SRR}_2.fastq ${SRR}_1P.fq ${SRR}_1U.fq ${SRR}_2P.fq ${SRR}_2U.fq SLIDINGWINDOW:4:${QC}

#
# Produce fastqc reports of the trimmed data.
#
fastqc ${SRR}_1P.fq ${SRR}_2P.fq

