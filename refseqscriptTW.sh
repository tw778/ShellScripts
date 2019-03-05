#Travis White
#3/4/2019
#RefseqID to geneID script
#
#Documentation: First this script will take a file of RNA-seq differentially expressed genes and
#will place only the known RefseqID's (NM_) into a new file. "MSTRG" IDs are omitted as these
#are novel transcripts. Once the RefseqID's are saved into "refseqids.txt", this script will
#go line by line and retrieve the geneIDs for each RefseqID and write them into the file "geneids.txt."
#
#To run this script, either save this script into your working directory, along with the txt or tab file
#containing your list of RNA-seq DEgenes, or copy and paste the text from this file into an in-terminal
#text editor such as nano and write out the file (ctrl+O) as scriptname.sh. Hit Ctrl+X to exit. Now you can
#run the script with: bash scriptname.sh "DEgenesfilename.txt". The script will do the rest, and the output will
#be in your working directory as "geneids.txt"

# Stop and errors and print error messages.
set -uex

# Command line argument for your DEgene file.
filename=$1

# Retrieve only NM_ Refseq IDs; omit MSTRG novel transcripts.
cat $1 | grep 'NM_' | awk '{print $1}' > refseqids.txt

# This will be the length of your NM_ IDs file.
length=$(wc -w < refseqids.txt)

# Loop that goes line by line through the Refseq IDs and retrieves Gene IDs, then writes them to a file.
for ((i=1;i <=$length;i++))
do
ref=`awk -v awk_i=$i 'FNR==awk_i {print}' refseqids.txt`
geneid=`efetch -db nucleotide -id ${ref} -format fasta | head -1`
echo $geneid >> geneids.txt 
done
