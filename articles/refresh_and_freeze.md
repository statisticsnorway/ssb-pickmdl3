# Partial concurrent adjustment

In accordance with the best practice defined in ESS Guideluines on
seasonal adjustment, model identification should be done once a year and
the sARIMA model order should be kept in line with the chosen
refreshment policy. With the pickmdl package, it is easy to implement
this best practice in a production process. A date for model selection
can be set in the `x13_pickdml`function by the options
`identification_end` or `identification_estimate.to`. The `x13_pickmdl`
function will then do the model selection based on data only up to and
including this date.

For the sake of illustration, let us say that model selection is to be
done each January, based on data until the preceding December. We use
the Norwegian rti of nace 47.6 and the standard specification rsa5c,
with outliers turned off to illustrate this option.

``` r


library(pickmdl3)

rti_476 <- pickmdl3::pickmdl_data("norwegian_rti")$rti_476

spec_now <- x13_spec("rsa5c") |>
  set_outlier(outliers.type= NULL) 

last_year <- stats::end(rti_476)[1] - 1 

model_now <- x13_pickmdl(rti_476,spec=spec_now,identification_end = c(last_year,12),output="all")

# or equivalently 

model_now <- x13_pickmdl(rti_476,spec=spec_now,identification_estimate.to = paste0(last_year,"-12-01")) 

ok(model_now)
#> $ok
#> [1] TRUE
#> 
#> $ok_final
#> [1] FALSE
#> 
#> $mdl_nr
#> [1] 2
```

Based on the model identification set at the preceding December, the
second model on the pickmdl list is chosen by the pickmdl procedure.
Compare this to what would have happened if model selection was done
with all available data up toJuly 2026. In this case the chosen model is
the fifth model, of order $`(2,1,2)(0,1,1)_s`$. Model change is thus
prevented in the middle of the year when we specify identification date
for model selection.

``` r

model_now_b <- x13_pickmdl(rti_476,spec=spec_now)

model_now_b
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: yes 
#> SARIMA model: (2,1,2) (0,1,1)
#> 
#> SARIMA coefficients:
#>    phi(1)    phi(2)  theta(1)  theta(2) btheta(1) 
#>   -0.1296   -0.4386   -0.6958   -0.3040   -0.4697 
#> 
#> Regression model:
#>      mon      tue      wed      thu      fri      sat 
#> -0.01104  0.00689  0.01277 -0.01275  0.01792  0.01595 
#> 
#>  Seasonal filter: FILTER_S3X5;  Trend filter: H-13 terms
#>  M-Statistics: q Good (0.501); q-m2 Good (0.547)
#>  QS test on SA: Good (1.000);  F-test on SA: Good (0.972)
#> 
#> For a more detailed output, use the 'summary()' function.
```

Notice that there now is a difference between `$ok` and `ok_final` in
the output above. Now `$ok` tells us that the selected model satisfied
the pickmdl criteria at the identification date, i.e. December 2025. The
`ok_final` gives information about whether the selected model still
passes the criteria when the new data is taken into account. That is,
whether the model selected based on data until December 2025 still fits
the data in July 2026. We see that that is no longer the case, which is
an indication that model change should be expected when the model is to
be re-identified in January 2027.

## Outliers

In the example above, we didn’t consider outliers. The default option in
`x13_pickmdl` is that outliers are identified by the shortened series.
That is, the outliers identified by the shortened series are kept
throughout the year, and only new ouliers after the identification date
are selected throughout the year.

In the example below, we manipulate the series to forace an outlier in
June 2026, after model selection is done based on data up to and
including December 2025.

``` r


spec_now <- x13_spec("rsa5c") |>
   set_outlier(outliers.type= c("AO","LS"))
  

last_year <- stats::end(rti_476)[1] - 1 

rti_476_fix <- rti_476
rti_476_fix[length(rti_476)-1] <- 10

model_now <- x13_pickmdl(rti_476_fix,spec=spec_now,identification_end = c(last_year,12))

model_now
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: yes 
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> SARIMA coefficients:
#>  theta(1) btheta(1) 
#>   -0.6243   -0.4483 
#> 
#> Regression model:
#>             mon             tue             wed             thu             fri 
#>      -0.0124209       0.0047325       0.0119882      -0.0072352       0.0179482 
#>             sat AO (2020-01-01) AO (2020-03-01) LS (2020-05-01) LS (2020-08-01) 
#>       0.0004963      -0.1773416      -0.2213182       0.2261907      -0.1732089 
#> LS (2021-05-01) LS (2021-08-01) AO (2026-06-01) 
#>       0.1943734      -0.1435998      -2.4332986 
#> 
#>  Seasonal filter: FILTER_S3X5;  Trend filter: H-13 terms
#>  M-Statistics: q Good (0.768); q-m2 Good (0.492)
#>  QS test on SA: Good (0.909);  F-test on SA: Good (0.499)
#> 
#> For a more detailed output, use the 'summary()' function.
```

We see that seven outliers are identified in total. Six of these have a
date before the model selection date in December 2025 and was therefore
identified in the model selection step. If we take a closer look at the
estimation specification for the model in June 2026, we see that the six
outliers have been defined as pre-specfied outliers and that the
detection span for new outliers is now from January 2026:

``` r

model_now$estimation_spec
#> Specification
#> 
#> Series
#> Serie span: All 
#> Preliminary Check: Yes
#> 
#> Estimate
#> Model span: All 
#> 
#> Tolerance: 1e-07
#> 
#> Transformation
#> Function: LOG
#> AIC difference: -2
#> Adjust: LEAPYEAR
#> 
#> Regression
#> Calendar regressor: TradingDays
#> with Leap Year: No
#> AutoAdjust: FALSE
#> Test: NO
#> 
#> Easter: No
#> 
#> Pre-specified outliers: 6
#>  - AO (2020-01-01), coefficient: -0.177667511131776 (INITIAL)
#>  - AO (2020-03-01), coefficient: -0.220168845662991 (INITIAL)
#>  - LS (2020-05-01), coefficient: 0.224423169320979 (INITIAL)
#>  - LS (2020-08-01), coefficient: -0.174401233307672 (INITIAL)
#>  - LS (2021-05-01), coefficient: 0.195195660086895 (INITIAL)
#>  - LS (2021-08-01), coefficient: -0.143382952057627 (INITIAL)
#> Ramps: No
#> 
#> Outliers
#> Detection span: From 2026-01-01 
#> Outliers type: 
#>  - AO, critical value : 0 (Auto)
#>  - LS, critical value : 0 (Auto)
#> TC rate: 0.7 (Auto)
#> Method: ADDONE (Auto)
#> 
#> ARIMA
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> SARIMA coefficients:
#>  theta(1) btheta(1) 
#>         0         0 
#> 
#> Specification X11
#> Seasonal component: Yes
#> Length of the Henderson filter: 0
#> Seasonal filter: FILTER_MSR
#> Boundaries used for extreme values correction : 
#>   lower_sigma:  1.5 
#>   upper_sigma:  2.5
#> Nb of forecasts: -1
#> Nb of backcasts: 0
#> Calendar sigma: NONE
#> 
#> Benchmarking
#> Is enabled: No
```

It is possible to let the outlier span be the whole series, even though
the model order is identified at a specific date. This is done by
setting the option `identify_outliers = FALSE`. Comparing outliers with
the model above, we see that they are somewhat different, as they now
all were identified based on the whole available time series.

``` r


rar <- x13_pickmdl(rti_476_fix,spec=spec_now,identification_end = c(last_year,12),
                   identify_outliers = FALSE)
```

## Refreshment policy

The specification at the identification time is the reference
specification for the following year. Estimation specification is
refreshed according to refreshment policy, as defined in x13_refresh().
Default refreshment policy in the pickmdl package is `Outliers`, where
the model order is set, but parameters estimated anew. (Obs: only
Outliers available pro tempora) To be extended.
