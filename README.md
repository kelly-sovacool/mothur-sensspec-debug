mothur sens.spec()
================

``` r
library(here)
library(tidyverse)
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
head(dat)
```

    ## # A tibble: 6 x 22
    ##   label...1 cutoff     tp     tn     fp     fn sensitivity specificity   ppv
    ##   <chr>      <dbl>  <dbl>  <dbl>  <dbl>  <dbl>       <dbl>       <dbl> <dbl>
    ## 1 userLabel   0.03 6.38e6 6.32e8 3.07e6 5.54e5       0.920       0.995 0.675
    ## 2 userLabel   0.03 5.47e6 4.96e8 2.81e6 1.47e6       0.789       0.994 0.661
    ## 3 userLabel   0.03 6.28e6 6.33e8 3.23e6 5.53e5       0.919       0.995 0.660
    ## 4 userLabel   0.03 5.37e6 6.26e8 1.11e7 1.46e6       0.786       0.983 0.326
    ## 5 userLabel   0.03 6.28e6 6.33e8 3.23e6 5.53e5       0.919       0.995 0.660
    ## 6 userLabel   0.03 5.37e6 6.26e8 1.11e7 1.46e6       0.786       0.983 0.326
    ## # … with 13 more variables: npv <dbl>, fdr <dbl>, accuracy <dbl>, mcc <dbl>,
    ## #   f1score <dbl>, mothur_version <chr>, dataset <chr>, filetype <chr>,
    ## #   cluster_method <chr>, label...19 <chr>, sobs <dbl>, numotus <dbl>,
    ## #   label...20 <chr>

``` r
dat %>% ggplot(aes(x=mothur_version, y=mcc, color=cluster_method, shape=dataset)) +
  geom_point(position = position_jitter(width=0.1, height = 0),
             size = 5, alpha=0.7) +
  ylim(0,1) +
  theme_bw()
```

![](figures/plot_mcc-1.png)<!-- -->
