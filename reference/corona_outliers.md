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
spec_a <- rjd3toolkit::set_transform(spec_a, fun = "Log")
spec_a2 <- update_spec_corona_outliers(spec_a)
as.data.frame(t(sapply(spec_a$regarima$regression$outliers,"[")))
#> data frame with 0 columns and 1 row
as.data.frame(t(sapply(spec_a2$regarima$regression$outliers,"[")))
#>               name        pos code coef
#> 1  LS (2020-03-01) 2020-03-01   LS NULL
#> 2  LS (2020-04-01) 2020-04-01   LS NULL
#> 3  LS (2020-05-01) 2020-05-01   LS NULL
#> 4  LS (2020-06-01) 2020-06-01   LS NULL
#> 5  LS (2020-07-01) 2020-07-01   LS NULL
#> 6  LS (2020-08-01) 2020-08-01   LS NULL
#> 7  LS (2020-09-01) 2020-09-01   LS NULL
#> 8  LS (2020-10-01) 2020-10-01   LS NULL
#> 9  LS (2020-11-01) 2020-11-01   LS NULL
#> 10 LS (2020-12-01) 2020-12-01   LS NULL
#> 11 LS (2021-01-01) 2021-01-01   LS NULL
#> 12 LS (2021-02-01) 2021-02-01   LS NULL
#> 13 LS (2021-03-01) 2021-03-01   LS NULL
#> 14 LS (2021-04-01) 2021-04-01   LS NULL
#> 15 LS (2021-05-01) 2021-05-01   LS NULL
#> 16 LS (2021-06-01) 2021-06-01   LS NULL
#> 17 LS (2021-07-01) 2021-07-01   LS NULL
#> 18 LS (2021-08-01) 2021-08-01   LS NULL
#> 19 LS (2021-09-01) 2021-09-01   LS NULL
#> 20 LS (2021-10-01) 2021-10-01   LS NULL
#> 21 LS (2021-11-01) 2021-11-01   LS NULL
#> 22 LS (2021-12-01) 2021-12-01   LS NULL
#> 23 LS (2022-01-01) 2022-01-01   LS NULL
#> 24 LS (2022-02-01) 2022-02-01   LS NULL
#> 25 LS (2022-03-01) 2022-03-01   LS NULL

spec_b <- rjd3x13::x13_spec(name = "rsa3")
spec_b <- rjd3toolkit::set_transform(spec_b, fun = "Log")
spec_b <- rjd3toolkit::add_outlier(spec_b,type=rep("AO",3),
                                date=c("2009-01-01", "2016-01-01", "2020-05-01"))
spec_b2 <- update_spec_corona_outliers(spec_b, outlier_date_limit = "2021-11-01")
as.data.frame(t(sapply(spec_b$regarima$regression$outliers,"[")))
#>              name        pos code coef
#> 1 AO (2009-01-01) 2009-01-01   AO NULL
#> 2 AO (2016-01-01) 2016-01-01   AO NULL
#> 3 AO (2020-05-01) 2020-05-01   AO NULL
as.data.frame(t(sapply(spec_b2$regarima$regression$outliers,"[")))
#>               name        pos code coef
#> 1  AO (2009-01-01) 2009-01-01   AO NULL
#> 2  AO (2016-01-01) 2016-01-01   AO NULL
#> 3  AO (2020-05-01) 2020-05-01   AO NULL
#> 4  LS (2020-03-01) 2020-03-01   LS NULL
#> 5  LS (2020-04-01) 2020-04-01   LS NULL
#> 6  LS (2020-06-01) 2020-06-01   LS NULL
#> 7  LS (2020-07-01) 2020-07-01   LS NULL
#> 8  LS (2020-08-01) 2020-08-01   LS NULL
#> 9  LS (2020-09-01) 2020-09-01   LS NULL
#> 10 LS (2020-10-01) 2020-10-01   LS NULL
#> 11 LS (2020-11-01) 2020-11-01   LS NULL
#> 12 LS (2020-12-01) 2020-12-01   LS NULL
#> 13 LS (2021-01-01) 2021-01-01   LS NULL
#> 14 LS (2021-02-01) 2021-02-01   LS NULL
#> 15 LS (2021-03-01) 2021-03-01   LS NULL
#> 16 LS (2021-04-01) 2021-04-01   LS NULL
#> 17 LS (2021-05-01) 2021-05-01   LS NULL
#> 18 LS (2021-06-01) 2021-06-01   LS NULL
#> 19 LS (2021-07-01) 2021-07-01   LS NULL
#> 20 LS (2021-08-01) 2021-08-01   LS NULL
#> 21 LS (2021-09-01) 2021-09-01   LS NULL
#> 22 LS (2021-10-01) 2021-10-01   LS NULL
```
