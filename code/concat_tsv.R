library(tidyverse)

snakemake@input[['tsv']] %>%
    map_dfr(function(x) { read_tsv(x) %>% mutate(num_otus = as.double(num_otus))}) %>%
    write_tsv(snakemake@output[['tsv']])