# Multiple X-13ARIMA model specifications

[`x13_spec`](https://rjdverse.github.io/rjd3x13/reference/x13_spec.html)
is run multiple times with input for multiple arima models.

## Usage

``` r
x13_spec_pickmdl(
  ...,
  arima.p = c(0, 0, 2, 0, 2),
  arima.d = c(1, 1, 1, 2, 1),
  arima.q = c(1, 2, 0, 2, 2),
  arima.bp = 0,
  arima.bd = 1,
  arima.bq = 1,
  automdl.enabled = FALSE
)
```

## Arguments

- ...:

  A "JD3_X13_SPEC" class object generated with
  [`x13_spec`](https://rjdverse.github.io/rjd3x13/reference/x13_spec.html)

- arima.p:

  'set_arima' parameters as vector.

- arima.d:

  'set_arima' parameters as vector.

- arima.q:

  'set_arima' parameters as vector.

- arima.bp:

  'set_arima' parameters as vector.

- arima.bd:

  'set_arima' parameters as vector.

- arima.bq:

  'set_arima' parameters as vector.

- automdl.enabled:

  'set_automodel' parameter

## Value

List of several "JD3_X13_SPEC" class objects

## Details

This function behaves like `x13_spec` except that some of the parameters
may be vectors. These vectors must be the same length.

## Examples

``` r

spec <- rjd3x13::x13_spec("rsa3")
spec_list <- x13_spec_pickmdl(spec)
```
