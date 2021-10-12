library(tidyverse)

read_tsv(snakemake@input[['tsv']]) %>%
    mutate(mothur_version = snakemake@wildcards[['version']],
           filetype = snakemake@wildcards[['filetype']],
           cluster_method = snakemake@wildcards[['method']]) %>%
    write_tsv(snakemake@output[['tsv']])
