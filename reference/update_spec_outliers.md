# Update x13 spec with outliers

Update an `x13_spec` output object with outliers from an `x13` output
object.

## Usage

``` r
update_spec_outliers(
  sa,
  spec = NULL,
  day = "01",
  verbose = FALSE,
  input_output = is.null(spec)
)

update_outliers(sa, spec, day = "01", null_when_no_new = TRUE, verbose = FALSE)
```

## Arguments

- sa:

  An [`x13`](https://rjdverse.github.io/rjd3x13/reference/x13.html)
  output object

- spec:

  An
  [`x13_spec`](https://rjdverse.github.io/rjd3x13/reference/x13_spec.html)
  output object

- day:

  Day of month as character to be used in outlier coding

- verbose:

  Printing information to console when `TRUE`.

- input_output:

  When `TRUE` output is a list of `x13_spec` parameters instead of an
  updated spec.

- null_when_no_new:

  Whether to return `NULL` when no new outliers found.

## Value

`update_spec_outliers` returns an updated `x13_spec` output object with
new outliers and updated `outlier.from`. `update_outliers` returns a
data frame with outlier variables used to update.

## Note

For special use, parameter `sa` to `update_outliers` can be a data frame
of outliers (as created by
[`corona_outliers`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/corona_outliers.md)).

## Examples

``` r
myseries <- pickmdl_data("myseries")

spec_1 <- rjd3x13::x13_spec("rsa3")
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
spec_1 <- rjd3toolkit::set_transform(spec_1, fun = "Log")
#> Error: object 'spec_1' not found
spec_1 <- rjd3toolkit::set_outlier(spec_1, critical.value =3)
#> Error: object 'spec_1' not found
spec_1 <- rjd3toolkit::add_outlier(spec_1, type="AO",date="2008-09-01")
#> Error: object 'spec_1' not found


spec_2 <- rjd3toolkit::set_basic(spec_1, type="To", d1 = "2020-02-01")
#> Error: object 'spec_1' not found

a <- rjd3x13::x13(myseries, spec_2)
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0

update_outliers(a, spec_1)
#> Error: object 'spec_1' not found

spec_3 <- update_spec_outliers(a, spec_1)
#> Error: object 'a' not found

update_spec_outliers(a)
#> Error: object 'a' not found
```
