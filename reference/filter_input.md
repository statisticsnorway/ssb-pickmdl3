# x13 output filters to x13 input filters

Elements `t_filter` and `s_filter` are transformed to input parameters
`henderson.filter` and `seasonal.filter` in
[`set_x11`](https://rjdverse.github.io/rjd3x13/reference/x11_spec.html)

## Usage

``` r
filter_input(sa)
```

## Arguments

- sa:

  A [`x13`](https://rjdverse.github.io/rjd3x13/reference/x13.html)
  output object

## Value

list of `henderson.filter` (numeric) and `seasonal.filter` (character)

## Examples

``` r
myseries <- pickmdl_data("myseries")

a <- rjd3x13::x13(myseries, spec = "rsa3")

a$result$decomposition$final_henderson
#> [1] 23
a$result$decomposition$final_seasonal
#> [1] "FILTER_S3X9"
filter_input(a)
#> $henderson.filter
#> [1] 23
#> 
#> $seasonal.filter
#> [1] "S3X9"
#> 

spec_b <- rjd3x13::x13_spec("rsa3")
spec_b <- rjd3x13::set_x11(spec_b,seasonal.filter="Stable",henderson.filter=13)
b <- rjd3x13::x13(myseries, spec = spec_b)

b$result$decomposition$final_henderson
#> [1] 13
b$result$decomposition$final_seasonal
#> [1] "FILTER_STABLE"
filter_input(b)
#> $henderson.filter
#> [1] 13
#> 
#> $seasonal.filter
#> [1] "STABLE"
#> 
```
