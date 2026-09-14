# Corona outliers

Corona outliers as a type-date data frame. Also a function to update
spec with these outliers.

## Usage

``` r
corona_outliers(option = "ssb", freq = 12, day = "01", q_month = 1)

update_spec_corona_outliers(
  spec,
  option = "ssb",
  freq = 12,
  day = "01",
  q_month = 1,
  outlier_date_limit = "3000-01-01"
)
```

## Arguments

- option:

  Only `"ssb"` implemented

- freq:

  frequency, `4` or `12`

- day:

  day of month as character

- q_month:

  month of quarter as `1`, `2` or `3`

- spec:

  A specification object of class "JD3_X13_SPEC" to be updated.

- outlier_date_limit:

  Only outliers with `date < outlier_date_limit` will be included in
  updated spec.

## Value

data frame

## Details

Corona outliers with same date as outliers already in spec will be
omitted.

## Examples

``` r

corona_outliers()
#>    type       date
#> 1    LS 2020-03-01
#> 2    LS 2020-04-01
#> 3    LS 2020-05-01
#> 4    LS 2020-06-01
#> 5    LS 2020-07-01
#> 6    LS 2020-08-01
#> 7    LS 2020-09-01
#> 8    LS 2020-10-01
#> 9    LS 2020-11-01
#> 10   LS 2020-12-01
#> 11   LS 2021-01-01
#> 12   LS 2021-02-01
#> 13   LS 2021-03-01
#> 14   LS 2021-04-01
#> 15   LS 2021-05-01
#> 16   LS 2021-06-01
#> 17   LS 2021-07-01
#> 18   LS 2021-08-01
#> 19   LS 2021-09-01
#> 20   LS 2021-10-01
#> 21   LS 2021-11-01
#> 22   LS 2021-12-01
#> 23   LS 2022-01-01
#> 24   LS 2022-02-01
#> 25   LS 2022-03-01
corona_outliers(freq = 4)
#>   type       date
#> 1   LS 2020-01-01
#> 2   LS 2020-04-01
#> 3   LS 2020-07-01
#> 4   LS 2020-10-01
#> 5   LS 2021-01-01
#> 6   LS 2021-04-01
#> 7   LS 2021-07-01
#> 8   LS 2021-10-01
#> 9   LS 2022-01-01

spec_a <- rjd3x13::x13_spec(name = "rsa3")
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/toolkit/base/r/timeseries/TsUtility has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
spec_a <- rjd3toolkit::set_transform(spec_a, fun = "Log")
#> Error: object 'spec_a' not found
spec_a2 <- update_spec_corona_outliers(spec_a)
#> Error: object 'spec_a' not found
as.data.frame(t(sapply(spec_a$regarima$regression$outliers,"[")))
#> Error: object 'spec_a' not found
as.data.frame(t(sapply(spec_a2$regarima$regression$outliers,"[")))
#> Error: object 'spec_a2' not found

spec_b <- rjd3x13::x13_spec(name = "rsa3")
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
spec_b <- rjd3toolkit::set_transform(spec_b, fun = "Log")
#> Error: object 'spec_b' not found
spec_b <- rjd3toolkit::add_outlier(spec_b,type=rep("AO",3),
                                date=c("2009-01-01", "2016-01-01", "2020-05-01"))
#> Error: object 'spec_b' not found
spec_b2 <- update_spec_corona_outliers(spec_b, outlier_date_limit = "2021-11-01")
#> Error: object 'spec_b' not found
as.data.frame(t(sapply(spec_b$regarima$regression$outliers,"[")))
#> Error: object 'spec_b' not found
as.data.frame(t(sapply(spec_b2$regarima$regression$outliers,"[")))
#> Error: object 'spec_b2' not found
```
