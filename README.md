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
    ## ── Column specification ────────────────────────────────────────────────────────
    ## cols(
    ##   label = col_character(),
    ##   cutoff = col_double(),
    ##   tp = col_double(),
    ##   tn = col_double(),
    ##   fp = col_double(),
    ##   fn = col_double(),
    ##   sensitivity = col_double(),
    ##   specificity = col_double(),
    ##   ppv = col_double(),
    ##   npv = col_double(),
    ##   fdr = col_double(),
    ##   accuracy = col_double(),
    ##   mcc = col_double(),
    ##   f1score = col_double(),
    ##   mothur_version = col_character(),
    ##   dataset = col_character(),
    ##   filetype = col_character(),
    ##   cluster_method = col_character(),
    ##   numotus = col_double()
    ## )

``` r
head(dat)
```

    ## # A tibble: 6 x 19
    ##   label cutoff     tp     tn     fp     fn sensitivity specificity   ppv   npv
    ##   <chr>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>       <dbl>       <dbl> <dbl> <dbl>
    ## 1 user…   0.03 6.38e6 6.32e8 3.07e6 5.54e5       0.920       0.995 0.675 0.999
    ## 2 user…   0.03 5.47e6 4.96e8 2.81e6 1.47e6       0.789       0.994 0.661 0.997
    ## 3 user…   0.03 6.28e6 6.33e8 3.23e6 5.53e5       0.919       0.995 0.660 0.999
    ## 4 user…   0.03 5.37e6 6.26e8 1.11e7 1.46e6       0.786       0.983 0.326 0.998
    ## 5 user…   0.03 6.28e6 6.33e8 3.23e6 5.53e5       0.919       0.995 0.660 0.999
    ## 6 user…   0.03 5.37e6 6.26e8 1.11e7 1.46e6       0.786       0.983 0.326 0.998
    ## # … with 9 more variables: fdr <dbl>, accuracy <dbl>, mcc <dbl>, f1score <dbl>,
    ## #   mothur_version <chr>, dataset <chr>, filetype <chr>, cluster_method <chr>,
    ## #   numotus <dbl>

``` r
dat %>% ggplot(aes(x=mothur_version, y=mcc, color=cluster_method, shape=dataset)) +
  geom_point(position = position_jitter(width=0.1, height = 0),
             size = 5, alpha=0.7) +
  ylim(0,1) +
  theme_bw()
```

![](figures/plot_mcc-1.png)<!-- -->
