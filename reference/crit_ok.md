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
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
spec_a <- rjd3toolkit::set_transform(spec_now,fun="Log")
#> Error: object 'spec_now' not found
a <- x13_pickmdl(myseries, spec_a)
#> Error: object 'spec_a' not found
spec_b <- rjd3toolkit::set_transform(spec_now,fun="None")
#> Error: object 'spec_now' not found
b <- x13_pickmdl(myseries, spec_b)
#> Error: object 'spec_b' not found

crit_ok(a)
#> Error: object 'a' not found
crit_ok(b)
#> Error: object 'b' not found
```
