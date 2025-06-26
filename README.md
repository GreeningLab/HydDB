# HydDB (Greening lab hydrogenase database)

This is a temporary repository for the hydrogenase data and HMM compiled by Greening lab (<http://www.greeninglab.com/>) used in the HydDB webserver, since the previous site hosted by Aarhus University (<http://services.birc.au.dk/hyddb>) is no longer being maintained.

To run the original HydDB webserver locally, please see our [HydDB-webserver](https://github.com/GreeningLab/HydDB-webserver) repository.

# Amino acid sequences

Sequences for \[NiFe\]-, \[FeFe\]-, and \[Fe\]-hydrogenases were previously complied in the two following papers:

1. Søndergaard D\*, Pedersen CNS, Greening C\* (2016) HydDB: a web tool for hydrogenase classification and analysis. Scientific Reports 6, 34212
2. Greening C\*, Biswas A, Carere CR, Jackson CJ, Taylor MC, Stott MB, Cook GM, Morales SE\* (2016). Genomic and metagenomic surveys of hydrogenase distribution indicate H2 is a widely-utilised energy source for microbial growth and survival. The ISME Journal 10, 761-777

# HMM (2022 version)

To identify highly divergent hydrogenases, the HMM profiles in this repo can be used with [HMMER](http://hmmer.org/):

```bash
# search profile against a database
hmmsearch \
    -o output.txt \
    -A output_alignment.aln \
    --tblout tblout.tsv \
    --domtblout domains-tblout.tsv \
    --pfamtblout pfamtblout.pfam \
    --acc \
    --domT <BIT_SCORE_CUTOFF> \
    HydDB_all_MM2022.hmm \
    your_query_sequences.fasta
```

Please keep in mind that while HMMER is a sensitive tool for finding remote homologs, it is also prone to return false positive hits.
To reduce false-positives, we recommend implementing the following steps:

1. Using bit score cutoffs in HMMER (see below)
2. Cross-comparing hits from sequence based searches like BLAST or MMseqs2
3. Checking the predicted structure of a HMMER hit with AlphaFold

We recommend using the following WIP bit score cutoffs for each class to use with the `--domT` flag:

* \[FeFe\]: 15.9
* \[NiFe\]: 34.5
* \[Fe\]: 54.4

If you want to reduce the frequency of false positive hits further, we recommend using these more conservative WIP bit score cutoff for each class to use with the `--domT` flag:

* \[FeFe\]: 50
* \[NiFe\]: 120
* \[Fe\]: n/a

# Simple hydrogenase classification with DIAMOND BLASTP

Use [DIAMOND](https://github.com/bbuchfink/diamond) for quick and convenient BLASTing of your query sequences against the HydDB sequences.

First, install the diamond binary tool:

```bash

# download DIAMOND
wget http://github.com/bbuchfink/diamond/releases/download/v2.1.11/diamond-linux64.tar.gz
# extract binary
tar xzf diamond-linux64.tar.gz
```

Second, download the HydDB sequences provided in this repository (the `HydDB_all_hydrogenases.faa` file), and create a diamond database (`.dmnd` file):

```bash

# create a DIAMOND formatted sequence database of the HydDB to search against
./diamond makedb --in HydDB_all_hydrogenases.faa -d hyddb
```

Now you can search your query sequences against the `hyddb.dmnd` database:

```bash

# search the HydDB DIAMOND database with your query protein seqeunces
./diamond blastp \
    -q query_sequences.fasta \
    -d hyddb.dmnd \
    -o output_hits.tsv \
    --max-target-seqs 1 \
    --header simple \
    --outfmt 6 qseqid sseqid pident evalue bitscore full_sseq

```

This produces a `.tsv` file of the diamond blastp results. To extract just your query ID's with their corresponding best predicted hydrogenase group:

```bash
awk 'NR>1{split($2,arr,/\|/); print $1, arr[3]}' output_hits.tsv | sed '1i query_id\tclosest_hydrogenase_group' > output_hyd_classification.tsv
```

This repository also provides a simple bash script to run diamond blastp and the subsequent awk step in one go. Make sure that 1) `diamond` has been installed and is 2) added to your `PATH`, and that 3) the `.dmnd` database of HydDB sequences has been is setup. Then run:

```bash
./hydclassify.sh [YOUR_QUERY.faa]
```

To reduce false positive hits, we suggest using the following sequence % identity score cutoffs for each class. These can be provided to `diamond blastp` using the `--id` flag:

* \[NiFe\] = >50% for group 4, >30% for all other groups
* \[FeFe\] = >45%
* \[Fe\] = >50%

## Citation

If you use the HydDB in your research, please cite the following:

```bibtex
@article{Søndergaard_2016,
    author={Søndergaard, Dan and Pedersen, Christian N. S. and Greening, Chris},
    title={HydDB: A web tool for hydrogenase classification and analysis},
    year={2016},
    journal={Scientific Reports},
    DOI={10.1038/srep34212},
    }

@article{Greening_2015,
    author={Greening, Chris and Biswas, Ambarish and Carere, Carlo R and Jackson, Colin J and Taylor, Matthew C and Stott, Matthew B and Cook, Gregory M and Morales, Sergio E},
    title={Genomic and metagenomic surveys of hydrogenase distribution indicate H2 is a widely utilised energy source for microbial growth and survival}, 
    year={2015},
    journal={The ISME Journal},
    DOI={10.1038/ismej.2015.153},
}

```
