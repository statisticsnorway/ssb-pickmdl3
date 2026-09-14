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
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
spec_b <- rjd3toolkit::set_arima(spec_a,mean=0.2)
#> Error: object 'spec_a' not found

a <- rjd3x13::x13(myseries, spec = spec_a)
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
b <- rjd3x13::x13(myseries, spec = spec_b)
#> Error in .jcall("jdplus/toolkit/base/r/timeseries/TsUtility", "Ljdplus/toolkit/base/api/timeseries/TsData;",     "of", as.integer(freq), as.integer(start[1]), as.integer(start[2]),     as.double(s)): RcallMethod: cannot determine object class

arima_mu(a)
#> Error: object 'a' not found
arima_mu(b)
#> Error: object 'b' not found
```
