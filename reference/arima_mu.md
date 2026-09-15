# Capture whether there is a mean coefficient from x13 output

Capture whether there is a mean coefficient from x13 output

## Usage

``` r
arima_mu(sa)
```

## Arguments

- sa:

  A [`x13`](https://rjdverse.github.io/rjd3x13/reference/x13.html)
  output object

## Value

`TRUE` or `FALSE`

## Examples

``` r
myseries <- pickmdl_data("myseries")

spec_a <- rjd3x13::x13_spec("rsa1")
spec_b <- rjd3toolkit::set_arima(spec_a,mean=0.2)

a <- rjd3x13::x13(myseries, spec = spec_a)
b <- rjd3x13::x13(myseries, spec = spec_b)

arima_mu(a)
#> [1] FALSE
arima_mu(b)
#> [1] TRUE
```
