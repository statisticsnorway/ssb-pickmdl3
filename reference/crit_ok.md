# PICKMDL "first" check

Check whether
[`x13`](https://rjdverse.github.io/rjd3x13/reference/x13.html) output is
ok according to the PICKMDL "first" method

## Usage

``` r
crit_ok(sa)
```

## Arguments

- sa:

  A [`x13`](https://rjdverse.github.io/rjd3x13/reference/x13.html)
  output object

## Value

`TRUE` or `FALSE`

## Details

Unlike
[`ok`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/ok.md),
this function does the actual calculations.

## See also

[`crit_selection`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/crit_selection.md)

## Examples

``` r

myseries <- pickmdl_data("myseries")

spec_now <- rjd3x13::x13_spec("rsa3")
spec_a <- rjd3toolkit::set_transform(spec_now,fun="Log")
a <- x13_pickmdl(myseries, spec_a)
spec_b <- rjd3toolkit::set_transform(spec_now,fun="None")
b <- x13_pickmdl(myseries, spec_b)
#> Warning: No model is ok according to criteria

crit_ok(a)
#> [1] TRUE
crit_ok(b)
#> [1] FALSE
```
