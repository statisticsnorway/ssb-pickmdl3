# PICKMDL information as a list

Extract `ok`, `ok_final` and `mdl_nr`

## Usage

``` r
ok(sa)
```

## Arguments

- sa:

  Output from
  [`x13_pickmdl`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/x13_pickmdl.md)

## Value

List constructed from comment attribute

## See also

[`crit_ok`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/crit_ok.md)

## Examples

``` r
myseries <- pickmdl_data("myseries")

spec_now <- rjd3x13::x13_spec("rsa3")
spec_a <- rjd3toolkit::set_transform(spec_now, fun = "Log")
a <- x13_pickmdl(myseries, spec_a)
spec_b <- rjd3toolkit::set_transform(spec_now, fun = "None")
b <- x13_pickmdl(myseries, spec_b)
#> Warning: No model is ok according to criteria

comment(a)
#>       ok ok_final   mdl_nr 
#>   "TRUE"   "TRUE"      "3" 
comment(b)
#>       ok ok_final   mdl_nr 
#>  "FALSE"  "FALSE"      "1" 
ok(a)
#> $ok
#> [1] TRUE
#> 
#> $ok_final
#> [1] TRUE
#> 
#> $mdl_nr
#> [1] 3
#> 
ok(b)
#> $ok
#> [1] FALSE
#> 
#> $ok_final
#> [1] FALSE
#> 
#> $mdl_nr
#> [1] 1
#> 
```
