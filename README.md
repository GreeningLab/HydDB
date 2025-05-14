# HydDB (Greening lab hydrogenase database)

This is a temporary repository for the hydrogenase data and HMM compiled by Greening lab (<http://www.greeninglab.com/>) used in the HydDB webserver, since the previous site hosted by Aarhus University (<http://services.birc.au.dk/hyddb>) is no longer being maintained.

To run the original HydDB webserver locally, please see our [HydDB-webserver](https://github.com/GreeningLab/HydDB-webserver) repository.

# Amino acid sequences

Sequences for [NiFe]-, [FeFe]-, and [Fe]-hydrogenases were previously complied in the two following papers:

1. Søndergaard D\*, Pedersen CNS, Greening C\* (2016) HydDB: a web tool for hydrogenase classification and analysis. Scientific Reports 6, 34212
2. Greening C\*, Biswas A, Carere CR, Jackson CJ, Taylor MC, Stott MB, Cook GM, Morales SE\* (2016). Genomic and metagenomic surveys of hydrogenase distribution indicate H2 is a widely-utilised energy source for microbial growth and survival. The ISME Journal 10, 761-777

# HMM (2022 version)

To identify highly divergent hydrogenases, the HMM profile in this repo can be used with [HMMer](http://hmmer.org/):

```bash
# search profile against a database
hmmsearch \
    -o output.txt \
    -A output_alignment.aln \
    --tblout tblout.tsv \
    --domtblout domains-tblout.tsv \
    --pfamtblout pfamtblout.pfam \
    --acc \
    --domT <SCORE_CUTOFF> \
    HydDB_MM2022.hmm \
    query_sequences.fasta
```

Suggested WIP bit score cutoff for each class to use with the `--domT` flag:

* FeFe: 15.9
* NiFe: 34.5
* Fe: 54.4

For more conservative WIP bit score cutoff for each class to use with the `--domT` flag:

* FeFe: 50
* NiFe: 120

Note: To reduce false-positives, we also recommend cross-compare hits from BLASTing the protein sequences.

# Simple hydrogenase classifier tool

```bash
wget http://github.com/bbuchfink/diamond/releases/download/v2.1.11/diamond-linux64.tar.gz
tar xzf diamond-linux64.tar.gz
# creating a diamond-formatted database file
./diamond makedb --in All_hydrogenases.faa -d hyddb
# running a search in blastp mode
./diamond blastp -d hyddb.dmnd -q query_sequences.fasta -o output_hits.tsv



./diamond blastp \
    -q ./input/FeFe_hyd.faa \
    -d $DBDIR/gtdb_r226_combined.dmnd \
    -o ./output/FeFe-gtdb_r226-${DATE}.tsv \
    --ultra-sensitive \
    --id 0.2 \
    --max-target-seqs 1 \
    --header verbose \
    --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore full_sseq

```
