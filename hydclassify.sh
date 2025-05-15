#!/usr/bin/bash

# USEAGE
# ./hydclassify.sh [QUERY.faa]

# REQUIREMENTS
#
# # DOWNLOAD DIAMOND
#
# wget http://github.com/bbuchfink/diamond/releases/download/v2.1.11/diamond-linux64.tar.gz
# tar xzf diamond-linux64.tar.gz
#
# # CREATE A DIAMOND FORMATTED SEQUENCE DATABASE OF THE HYDDB TO SEARCH AGAINST
#
# ./diamond makedb --in All_hydrogenases.faa -d hyddb
#
# ADD DIAMOND TO YOUR PATH
#
# export PATH="$(pwd)/diamond:$PATH"

QUERYFILE=$1
OUTPUT=${QUERYFILE##*/}
OUTPUT=${OUTPUT%.*}

diamond blastp \
    -q ${QUERYFILE} \
    -d hyddb.dmnd \
    -o ${OUTPUT}-diamond_hits.tsv \
    --id 50 \
    --max-target-seqs 1 \
    --header simple \
    --outfmt 6 qseqid sseqid pident evalue bitscore full_sseq

awk 'NR>1{split($2,arr,/\|/); print $1, arr[3]}' ${OUTPUT}-diamond_hits.tsv | sed '1i query_id\tclosest_hydrogenase_group' >${OUTPUT}-hyd_classification.tsv
