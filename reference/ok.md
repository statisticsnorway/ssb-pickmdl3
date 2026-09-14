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
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/toolkit/base/r/timeseries/TsUtility has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
spec_a <- rjd3toolkit::set_transform(spec_now, fun = "Log")
#> Error: object 'spec_now' not found
a <- x13_pickmdl(myseries, spec_a)
#> Error: object 'spec_a' not found
spec_b <- rjd3toolkit::set_transform(spec_now, fun = "None")
#> Error: object 'spec_now' not found
b <- x13_pickmdl(myseries, spec_b)
#> Error: object 'spec_b' not found

comment(a)
#> Error: object 'a' not found
comment(b)
#> Error: object 'b' not found
ok(a)
#> Error: object 'a' not found
ok(b)
#> Error: object 'b' not found
```
