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
 spec5 <- x13_spec_pickmdl(spec)

 sa5 <- x13_multi(myseries, spec = spec5)
```
