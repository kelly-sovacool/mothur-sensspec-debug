mothur sens.spec()
================

``` r
library(here)
library(tidyverse)
```

``` r
dat <- read_tsv(here('results', 'sensspec_concat.tsv'))
```

    ## New names:
    ## * label...20 -> label...22

    ## Rows: 6 Columns: 22

    ## ── Column specification ──────────────────────────────────────────────────────────────────
    ## Delimiter: "\t"
    ## chr  (7): label...1, mothur_version, dataset, filetype, cluster_method, labe...
    ## dbl (15): cutoff, tp, tn, fp, fn, sensitivity, specificity, ppv, npv, fdr, a...

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
dat %>% 
  mutate(num_otus = sobs) %>% 
  select(dataset, cluster_method, mothur_version, filetype, mcc, num_otus) %>%
  knitr::kable()
```

| dataset      | cluster_method | mothur_version | filetype    |    mcc | num_otus |
|:-------------|:---------------|:---------------|:------------|-------:|---------:|
| miseq_1.0_01 | vdgc           | 1.37.0         | names       | 0.7857 |     2114 |
| miseq_1.0_01 | cvsearch       | 1.37.0         | names       | 0.7178 |      862 |
| mouse        | vdgc           | 1.37.0         | names       | 0.7762 |     2113 |
| mouse        | cvsearch       | 1.37.0         | names       | 0.4991 |      870 |
| mouse        | vdgc           | 1.46.1         | count_table | 0.7762 |     2113 |
| mouse        | cvsearch       | 1.46.1         | count_table | 0.4991 |      870 |

``` r
dat %>% ggplot(aes(x=mothur_version, y=mcc, color=cluster_method, shape=dataset)) +
  geom_point(position = position_jitter(width=0.1, height = 0),
             size = 5, alpha=0.7) +
  ylim(0,1) +
  theme_bw()
```

![](figures/plot_mcc-1.png)<!-- -->
