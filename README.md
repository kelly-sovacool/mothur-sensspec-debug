mothur sens.spec()
================

``` r
library(here)
library(tidyverse)
set.seed(20211014)
```

``` r
dat <- read_tsv(here('results', 'sensspec_concat.tsv'))
```

    ## 
    ## ── Column specification ──────────────────────────────────────────────────────────────────
    ## cols(
    ##   .default = col_double(),
    ##   label...1 = col_character(),
    ##   mothur_version = col_character(),
    ##   dataset = col_character(),
    ##   filetype = col_character(),
    ##   cluster_method = col_character(),
    ##   label...19 = col_character(),
    ##   label...20 = col_character()
    ## )
    ## ℹ Use `spec()` for the full column specifications.

``` r
dat %>% 
  mutate(num_otus = sobs) %>% 
  select(dataset, cluster_method, mothur_version, filetype, mcc, num_otus) %>%
  knitr::kable()
```

| dataset        | cluster\_method | mothur\_version | filetype     |    mcc | num\_otus |
| :------------- | :-------------- | :-------------- | :----------- | -----: | --------: |
| miseq\_1.0\_01 | vdgc            | 1.37.0          | names        | 0.7857 |      2114 |
| miseq\_1.0\_01 | cvsearch        | 1.37.0          | names        | 0.7178 |       862 |
| mouse          | vdgc            | 1.37.0          | names        | 0.7762 |      2113 |
| mouse          | cvsearch        | 1.37.0          | names        | 0.4991 |       870 |
| mouse          | vdgc            | 1.46.1          | count\_table | 0.7762 |      2113 |
| mouse          | cvsearch        | 1.46.1          | count\_table | 0.4991 |       870 |

``` r
dat %>% ggplot(aes(x=mothur_version, y=mcc, color=cluster_method, shape=dataset)) +
  geom_point(position = position_jitter(width=0.1, height = 0),
             size = 5, alpha=0.7) +
  ylim(0,1) +
  theme_bw()
```

![](figures/plot_mcc-1.png)<!-- -->
