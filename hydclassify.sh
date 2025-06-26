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

if [[ $# -eq 0 ]]; then
    >&2 echo "Error: must provide path to query fasta file"
    >&2 echo "USAGE: $(basename $0) [QUERY_FASTA.faa]"
    >&2 echo ""
    >&2 echo "Requirements:"
    >&2 echo "1. Ensure DIAMOND has been downloaded and adding to your path"
    >&2 echo "2. Create a DIAMOND database of the HydDB fasta file"
    exit 1
fi

QUERYFILE=$1
OUTPUT=${QUERYFILE##*/}
OUTPUT=${OUTPUT%.*}

diamond blastp \
    -q "${QUERYFILE}" \
    -d hyddb.dmnd \
    -o ${OUTPUT}-diamond_hits.tsv \
    --ultra-sensitive \
    --max-target-seqs 1 \
    --header simple \
    --outfmt 6 qseqid sseqid pident evalue bitscore full_sseq

awk 'NR>1{split($2,arr,/\|/); print $1, arr[3]}' ${OUTPUT}-diamond_hits.tsv | sed '1i query_id\tclosest_hydrogenase_group' >${OUTPUT}-hyd_classification.tsv
