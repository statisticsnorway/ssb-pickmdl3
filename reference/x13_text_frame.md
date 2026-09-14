# Multiple [`x13_both`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/x13_both.md) runs with code input from a data frame

Multiple
[`x13_both`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/x13_both.md)
runs with code input from a data frame

## Usage

``` r
x13_text_frame(
  text_frame,
  ts = NULL,
  id = NULL,
  ...,
  drop = TRUE,
  verbose = FALSE,
  dots2list = TRUE
)
```

## Arguments

- text_frame:

  Data frame where all variables are character. Column names are either
  parameter names or on the form function\_\_parameter. The latter only
  when setting pre-processing parameters with functions from rjd3toolkit
  og rjd3x13. See examples. Each cell contains text with R code written
  as source code in a call to
  [`x13_both`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/x13_both.md).
  The parameter will be omitted when the cell is missing (NA). The
  exception is the column name, `name`, which contains the time series
  names. Without such a column, the names are taken from the row names.

- ts:

  A named multiple time series object, given as a character string. When
  `NULL`, the ts parameter must be included in `text_frame`.

- id:

  To select specific time series to be processed (name or number).

- ...:

  Extra arguments that do not change.

- drop:

  Whether to omit list output when a single time series is specified by
  `id`.

- verbose:

  When `TRUE`, function calls will be printed.

- dots2list:

  A technical parameter. When `TRUE` and when possible (warning when
  not), the underlying function,
  [`text_frame_apply`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/text_frame_apply.md),
  will be called via `call_list` instead of `...`. The advantage is
  prettier (unevaluated) printing when `verbose = TRUE`.

## Value

A list of `x13_both` outputs or output from a single run of `x13_both`
(see `drop`).

## Examples

``` r
myseries <- pickmdl_data("myseries")
seriesABC <- cbind(A = myseries, B = myseries + 10, C = myseries + 20)

tf <- data.frame(name = c("A", "B", "C"),automdl.enabled = c("TRUE", "FALSE", "FALSE"),
                 add_outlier__date = c('c("2009-01-01", "2016-01-01")', 'c("2009-01-01")', NA),
                 add_outlier__type = c('rep("LS", 2)', '"AO"', NA),
                 set_outlier__outliers.type = c(rep('c("LS","AO")',3)))

outABC <- x13_text_frame(tf, ts = "seriesABC", spec = "RSA3", set_transform__fun  = "Log",
                         verbose = TRUE)
#>   ----   id =  A    ----
#> x13_both(automdl.enabled = TRUE, add_outlier__date = c("2009-01-01", 
#>     "2016-01-01"), add_outlier__type = rep("LS", 2), set_outlier__outliers.type = c("LS", 
#>     "AO"), ts = seriesABC[, "A"], spec = "RSA3", set_transform__fun = "Log")
#> 
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
outB   <- x13_text_frame(tf, ts = "seriesABC", spec = "RSA3", set_transform__fun  = "Log",
                         id = "B")
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
identical(outABC[[2]], outB)  # TRUE
#> Error: object 'outABC' not found


# Spec can also be given as variable in the data frame

tf2 <- data.frame(name = c("A", "B", "C"),spec = '\"rsa3\"',
                 automdl.enabled = c("TRUE", "FALSE", "FALSE"),
                 add_outlier__date = c('c("2009-01-01", "2016-01-01")', 'c("2009-01-01")', NA),
                 add_outlier__type = c('rep("LS", 2)', '"AO"', NA),
                 set_outlier__outliers.type = c(rep('c("LS","AO")',3)))

outABC2 <-  x13_text_frame(tf2, ts = "seriesABC",set_transform__fun  = "Log",
                         verbose = TRUE)
#>   ----   id =  A    ----
#> x13_both(spec = "rsa3", automdl.enabled = TRUE, add_outlier__date = c("2009-01-01", 
#>     "2016-01-01"), add_outlier__type = rep("LS", 2), set_outlier__outliers.type = c("LS", 
#>     "AO"), ts = seriesABC[, "A"], set_transform__fun = "Log")
#> 
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class

identical(outABC, outABC2)
#> Error: object 'outABC' not found


```
