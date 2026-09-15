# Selection from table of PICKMDL criteria

Selection from table of PICKMDL criteria

## Usage

``` r
crit_selection(
  crit_tab,
  pickmdl_method = "first",
  star = 1,
  when_star = warning
)
```

## Arguments

- crit_tab:

  Output from
  [`crit_table`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/crit_table.md)

- pickmdl_method:

  A replacement for the original `PICKMDL` argument, `method`. Possible
  values are `"first"`(default) and `"aic"`. The latter is an
  alternative to the original method, `"best"` (not implemented).

- star:

  Index to be selected when no model is ok according to criteria.

- when_star:

  Function to be called when no model is ok according to criteria.
  Supply `stop` to invoke error. Supply `NULL` to do nothing.

## Value

Selected index

## Examples

``` r
myseries <- pickmdl_data("myseries")

spec_a <- rjd3x13::x13_spec("rsa3")
spec_a <- rjd3toolkit::set_transform(spec_a,fun="Log")

spec5 <- x13_spec_pickmdl(spec_a)

sa5 <- x13_multi(myseries, spec = spec5)

tab <- crit_table(sa5)

crit_selection(tab)
#> [1] 3
crit_selection(tab[2:5, ])
#> [1] 2
crit_selection(tab[1:2, ]) # Warning
#> Warning: No model is ok according to criteria
#> [1] 1
crit_selection(tab[1:2, ], star = 2, when_star = message)
#> No model is ok according to criteria
#> [1] 2
crit_selection(tab[5:1, ])
#> [1] 1
crit_selection(tab[5:1, ], pickmdl_method = "aic")
#> [1] 3
```
