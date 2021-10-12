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
    ##   filetype = col_character(),
    ##   cluster_method = col_character(),
    ##   numotus = col_double()
    ## )

``` r
head(dat)
```

    ## # A tibble: 4 x 18
    ##   label cutoff     tp       tn      fp     fn sensitivity specificity     ppv
    ##   <chr>  <dbl>  <dbl>    <dbl>   <dbl>  <dbl>       <dbl>       <dbl>   <dbl>
    ## 1 user…   0.03 6.38e6  6.32e 8 3.07e 6 5.54e5       0.920       0.995 6.75e-1
    ## 2 user…   0.03 5.47e6  4.96e 8 2.81e 6 1.47e6       0.789       0.994 6.61e-1
    ## 3 user…   0.03 6.38e6 -1.83e11 1.83e11 5.54e5       0.920    -288.    3.48e-5
    ## 4 user…   0.03 5.47e6 -1.80e11 1.81e11 1.47e6       0.789    -284.    3.02e-5
    ## # … with 9 more variables: npv <dbl>, fdr <dbl>, accuracy <dbl>, mcc <dbl>,
    ## #   f1score <dbl>, mothur_version <chr>, filetype <chr>, cluster_method <chr>,
    ## #   numotus <dbl>

``` r
dat %>% ggplot(aes(x=mothur_version, y=mcc, color=cluster_method)) +
  geom_point(position = position_jitter(width=0.1, height = 0),
             size = 5, alpha=0.7) +
  ylim(0,1) +
  theme_bw()
```

![](figures/plot_mcc-1.png)<!-- -->
