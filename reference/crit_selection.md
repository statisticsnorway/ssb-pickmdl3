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
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
spec_a <- rjd3toolkit::set_transform(spec_a,fun="Log")
#> Error: object 'spec_a' not found

spec5 <- x13_spec_pickmdl(spec_a)
#> Error: object 'spec_a' not found

sa5 <- x13_multi(myseries, spec = spec5)
#> Error: object 'spec5' not found

tab <- crit_table(sa5)
#> Error: object 'sa5' not found

crit_selection(tab)
#> Error: object 'tab' not found
crit_selection(tab[2:5, ])
#> Error: object 'tab' not found
crit_selection(tab[1:2, ]) # Warning
#> Error: object 'tab' not found
crit_selection(tab[1:2, ], star = 2, when_star = message)
#> Error: object 'tab' not found
crit_selection(tab[5:1, ])
#> Error: object 'tab' not found
crit_selection(tab[5:1, ], pickmdl_method = "aic")
#> Error: object 'tab' not found
```
