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
#> Error in .jcall("jdplus/toolkit/base/r/timeseries/TsUtility", "Ljdplus/toolkit/base/api/timeseries/TsData;",     "of", as.integer(freq), as.integer(start[1]), as.integer(start[2]),     as.double(s)): RcallMethod: cannot determine object class

a$result$decomposition$final_henderson
#> Error: object 'a' not found
a$result$decomposition$final_seasonal
#> Error: object 'a' not found
filter_input(a)
#> Error: object 'a' not found

spec_b <- rjd3x13::x13_spec("rsa3")
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/toolkit/base/r/timeseries/TsUtility has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
spec_b <- rjd3x13::set_x11(spec_b,seasonal.filter="Stable",henderson.filter=13)
#> Error: object 'spec_b' not found
b <- rjd3x13::x13(myseries, spec = spec_b)
#> Error in .jcall("jdplus/toolkit/base/r/timeseries/TsUtility", "Ljdplus/toolkit/base/api/timeseries/TsData;",     "of", as.integer(freq), as.integer(start[1]), as.integer(start[2]),     as.double(s)): RcallMethod: cannot determine object class

b$result$decomposition$final_henderson
#> Error: object 'b' not found
b$result$decomposition$final_seasonal
#> Error: object 'b' not found
filter_input(b)
#> Error: object 'b' not found
```
