# Multiple x13 runs from multiple specifications

[`x13`](https://rjdverse.github.io/rjd3x13/reference/x13.html) is run
multiple times

## Usage

``` r
x13_multi(..., spec)
```

## Arguments

- ...:

  `x13` parameters

- spec:

  List of several `x13_spec` output objects. That is, `spec` can be
  output from
  [`x13_spec_pickmdl`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/x13_spec_pickmdl.md).

## Value

List of several `x13` output objects

## Details

This function behaves like `x13` except that parameter `spec` is a list
of multiple specifications.

## Examples

``` r

 myseries <- pickmdl_data("myseries")

 spec <- rjd3x13::x13_spec("rsa3")
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
 spec5 <- x13_spec_pickmdl(spec)
#> Error: object 'spec' not found

 sa5 <- x13_multi(myseries, spec = spec5)
#> Error: object 'spec5' not found
```
