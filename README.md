# HydDB (Greening lab hydrogenase database)
This is a temporary repository for the hydrogenase databases and HMM compiled by Greening lab (http://www.greeninglab.com/) since the previous site hosted by Aarhus University (http://services.birc.au.dk/hyddb) was no longer maintained. 

# Amino acid sequences
Sequences for [NiFe]-, [FeFe]-, and [Fe]-hydrogenases were previously complied in the two following papers:
1. Søndergaard D\*, Pedersen CNS, Greening C\* (2016) HydDB: a web tool for hydrogenase classification and analysis. Scientific Reports 6, 34212<br />
2. Greening C\*, Biswas A, Carere CR, Jackson CJ, Taylor MC, Stott MB, Cook GM, Morales SE\* (2016). Genomic and metagenomic surveys of hydrogenase distribution indicate H2 is a widely-utilised energy source for microbial growth and survival. The ISME Journal 10, 761-777<br />

# HMM (2022 version)
To identify highly divergent hydrogenases, the hmm can be used:<br />
hmmsearch --domT 0 -o match.txt --tblout hmmer_table.txt profile.hmm candidate.fasta

Suggested WIP bit score thresholds for each class were:<br />
FeFe: 15.9 <br />
NiFe: 34.5 <br />
Fe: 54.4<br />

Note: To reduce false-positives, we also recommend cross-compare hits from BLASTing the protein sequences.
