library(tidyverse)

read_tsv(snakemake@input[['tsv']]) %>%
    mutate(mothur_version = snakemake@wildcards[['version']],
           list_header = snakemake@wildcards[['header']],
           filetype = snakemake@wildcards[['filetype']]) %>%
    write_tsv(snakemake@output[['tsv']])