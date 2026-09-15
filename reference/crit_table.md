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
spec_a <- rjd3toolkit::set_transform(spec_a,fun="Log")

spec5 <- x13_spec_pickmdl(spec_a)

sa5 <- x13_multi(myseries, spec=spec5)

crit_table(sa5)
#>           crit1        crit2      crit3    m_aic
#> [1,] 0.05061032 8.013497e-06 -0.8434345 1284.972
#> [2,] 0.04851923 1.270093e-02 -0.7772411 1264.598
#> [3,] 0.05733725 1.318480e-01  0.0000000 1259.908
#> [4,] 0.04757163 2.938136e-05 -0.9704629 1288.046
#> [5,] 0.05093402 2.889731e-01 -0.5057744 1261.431

crit123_m_aic(sa5[[4]])
#>         crit1         crit2         crit3         m_aic 
#>  4.757163e-02  2.938136e-05 -9.704629e-01  1.288046e+03 

crit1(sa5[[4]])
#> [1] 0.04757163
crit2(sa5[[4]])
#> [1] 2.938136e-05
crit3(sa5[[4]])
#> [1] -0.9704629
m_aic(sa5[[4]])
#> [1] 1288.046
```
