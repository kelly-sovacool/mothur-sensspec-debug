library(tidyverse)

read_tsv(snakemake@input[['sensspec']]) %>%
    mutate(mothur_version = snakemake@wildcards[['version']],
           dataset = snakemake@wildcards[['dataset']],
           filetype = snakemake@wildcards[['filetype']],
           cluster_method = snakemake@wildcards[['method']]) %>%
    bind_cols(read_tsv(snakemake@input[['summary']])) %>%
    write_tsv(snakemake@output[['tsv']])
