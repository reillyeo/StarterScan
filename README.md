<img width="756" height="774" alt="starterscan" src="https://github.com/user-attachments/assets/9c71c6d2-6ec6-49b9-a5ee-28821d5d0234" />

## Description

Starterscan is a tool developed for the analysis of metagenomic samples from dairy starter cultures. It combines open source softwares with custom-built databases of genes and bacterial species, to provide a fast overview of the content of a WGS sample, focusing on the detection and quantification of bacterial species and genes relevant for dairy starter cultures.

## Setup

Starterscan is designed to be run on a Linux machine and requires a conda installation. ~15 Gb of storage is also required to download the taxonomy database.
To set-up starterscan on your own machine, run the following commands:

  git clone https://github.com/reillyeo/StarterScan
  wget https://sid.erda.dk/share_redirect/cDCo25PoIl/starterscan_db.zip -O starterscan/data/starterscan_db.zip
  unzip starterscan/data/starterscan_db.zip -d starterscan/data/
  conda env create -f starterscan/config.yml 
  echo "export PATH\"=$(readlink -f ./starterscan)/:\$PATH\"" >> ~/.bashrc
  source ~/.bashrc

## Usage

  starterscan [options]

Required:
  -r  PATH    Raw reads (FASTQ)
  -o  PATH    Output directory (will be created if it does not exist)

Optional:
  -g  PATH    Target gene sequences in FASTA format [default: starterscan/data/genes_unique.fasta] 
  -t  INT     Threads                         [default: 8]
  -i  INT     Minimum % identity threshold    [default: 90]
  -c  INT     Minimum % gene coverage         [default: 80]
  -q  INT     Minimum MAPQ                    [default: 0]
  -l  INT     Minimum read length (bp)        [default: 1000]
  -p  STR     minimap2 preset                 [default: map-ont]
  -h          Show this help message

Examples:
  # Basic run
  bash starterscan -r sample.fastq -o results/

Notes:
  - Identity is calculated as: 100 * (matches / alignment_length)
    using the NM tag from minimap2 output.
  - Gene coverage is calculated per-reference using samtools coverage.
  - A gene is considered DETECTED if at least one read meets both the
    identity AND coverage thresholds.
  - Final output file (annotated_genecounts.csv) reports: (1) gene products, (2) reads per 2 megabases (RP2Mb).
