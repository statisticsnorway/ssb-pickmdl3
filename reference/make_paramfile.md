# Create an initial parameter file for x13_text_frame(). All values in the column are the same

Create an initial parameter file for x13_text_frame(). All values in the
column are the same

## Usage

``` r
make_paramfile(indat, ...)
```

## Arguments

- indat:

  Either i) a multiple time series object or ii) a data frame with time
  variable in the first column. In both cases columns must be named.

- ...:

  Additional arguments passed to x13_spec or x13_both

## Value

A data frame.

## Details

The '...' parameter can include any combination of arguments and their
values that are valid for the functions 'x13_spec' and 'x13_both'.

## Examples

``` r

set.seed(123)

years <- 2000:2024
ts1 <- runif(length(years), min = 50, max = 150)
ts2 <- runif(length(years), min = 50, max = 150)
ts3 <- runif(length(years), min = 50, max = 150)

inndata <- data.frame(
 year = years,
 tidsserie_1 = ts1,
 tidsserie_2 = ts2,
 tidsserie_3 = ts3
)

tf_test1 <- make_paramfile(indat = inndata, spec="rsa3")
```
