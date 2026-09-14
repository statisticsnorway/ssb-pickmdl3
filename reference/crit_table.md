# Table of PICKMDL criteria

Function `crit_table` takes several `x13` output objects as input and
produces a table of criteria (matrix class). The other functions are
underlying functions that take a single `x13` output object as input.

## Usage

``` r
crit_table(sa_list)

crit123_m_aic(sa)

crit1(sa)

crit2(sa)

crit3(sa)

m_aic(sa)
```

## Arguments

- sa_list:

  List of several `x13` output objects. That is, `spec` can be output
  from
  [`x13_multi`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/x13_multi.md).

- sa:

  A single `x13` output object.

## Value

A matrix, a vector or a single numerical value

## Examples

``` r
myseries <- pickmdl_data("myseries")

spec_a <- rjd3x13::x13_spec("rsa3")
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
spec_a <- rjd3toolkit::set_transform(spec_a,fun="Log")
#> Error: object 'spec_a' not found

spec5 <- x13_spec_pickmdl(spec_a)
#> Error: object 'spec_a' not found

sa5 <- x13_multi(myseries, spec=spec5)
#> Error: object 'spec5' not found

crit_table(sa5)
#> Error: object 'sa5' not found

crit123_m_aic(sa5[[4]])
#> Error: object 'sa5' not found

crit1(sa5[[4]])
#> Error: object 'sa5' not found
crit2(sa5[[4]])
#> Error: object 'sa5' not found
crit3(sa5[[4]])
#> Error: object 'sa5' not found
m_aic(sa5[[4]])
#> Error: object 'sa5' not found
```
