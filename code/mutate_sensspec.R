library(tidyverse)

summary_dat <- read_tsv(snakemake@input[['summary']]) %>%
    mutate(sobs = double(sobs)) %>%
    rename(num_otus = sobs)

read_tsv(snakemake@input[['sensspec']]) %>%
    mutate(mothur_version = snakemake@wildcards[['version']],
           dataset = snakemake@wildcards[['dataset']],
           filetype = snakemake@wildcards[['filetype']],
           cluster_method = snakemake@wildcards[['method']]) %>%
    bind_cols(summary_dat) %>%
    write_tsv(snakemake@output[['tsv']])
