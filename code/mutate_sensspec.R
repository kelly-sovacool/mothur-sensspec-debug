library(tidyverse)

summary_dat <- read_tsv(snakemake@input[['summary']]) %>%
    rename(num_otus = sobs)

read_tsv(snakemake@input[['sensspec']]) %>%
    bind_cols(summary_dat) %>%
    mutate(mothur_version = snakemake@wildcards[['version']],
           dataset = snakemake@wildcards[['dataset']],
           filetype = snakemake@wildcards[['filetype']],
           cluster_method = snakemake@wildcards[['method']],
           num_otus = as.double(num_otus)) %>%
    write_tsv(snakemake@output[['tsv']])
