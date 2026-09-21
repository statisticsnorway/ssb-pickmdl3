# x13_text_frame()

``` r

library(pickmdl3)
#> Loading required package: rjd3toolkit
#> 
#> Attaching package: 'rjd3toolkit'
#> The following objects are masked from 'package:stats':
#> 
#>     aggregate, mad
#> Loading required package: rjd3x13
#> 
#> Attaching package: 'rjd3x13'
#> The following object is masked from 'package:grDevices':
#> 
#>     x11
```

The pickmdl3 package includes functionality to support an orderly
production process when using the seasonal adjustment methods of
`rjd3x13`. The function `x13_text_frame` is a wrapper function that
seasonally adjusts a multivariate time series object with the
`x13_pickmdl`function based on a data frame with model specification
settings.

The object `rti_mts` contains three time series:

``` r


rti_mts <- do.call(cbind,pickmdl3::pickmdl_data("norwegian_rti"))

head(rti_mts)
#>          rti_472 rti_476 rti_4751
#> Jan 2014    61.1    71.9     64.5
#> Feb 2014    62.8    62.9     60.8
#> Mar 2014    68.6    69.8     68.9
#> Apr 2014    76.5    72.2     65.2
#> May 2014    78.4    71.9     69.1
#> Jun 2014    79.3    79.9     71.5
```

We can use the function `make_param_file`to define a data frame with
specifications. The first input to this function is the multivariate
time series object that is to be adjusted. Further input are the
specification settings that are used to define the specification with
which to adjust the series in question. With this we mean all
specification settings that are available in `rjd3toolkit`, `rjd3x13` or
the parameter settings in `x13_pickmdl`. With the exception of the
initial specification setting, the reference to settings in
`rjd3tookit`and `rjd3x13` need to be given on the format
`function__setting` as illustrated below.

``` r

spec_file <- make_paramfile(rti_mts, spec = "rsa3",
              set_outlier__outliers.type = c("LS","AO"),
              set_transform__fun = "Log",
              automdl.enabled = TRUE)

spec_file 
#>       name   spec set_outlier__outliers.type set_transform__fun automdl.enabled
#> 1  rti_472 "rsa3"              c("LS", "AO")              "Log"            TRUE
#> 2  rti_476 "rsa3"              c("LS", "AO")              "Log"            TRUE
#> 3 rti_4751 "rsa3"              c("LS", "AO")              "Log"            TRUE
#>                                                                                                                                                                                                                                                                                                      userdefined
#> 1 c("decomposition.a1", "decomposition.a6", "decomposition.a7", "decomposition.a8", "decomposition.b1", "decomposition.d10", "decomposition.d11", "decomposition.d12", "decomposition.d13", "decomposition.d18", "diagnostics.seas-si-combined", "diagnostics.seas-sa-friedman", "residuals.independence.value")
#> 2 c("decomposition.a1", "decomposition.a6", "decomposition.a7", "decomposition.a8", "decomposition.b1", "decomposition.d10", "decomposition.d11", "decomposition.d12", "decomposition.d13", "decomposition.d18", "diagnostics.seas-si-combined", "diagnostics.seas-sa-friedman", "residuals.independence.value")
#> 3 c("decomposition.a1", "decomposition.a6", "decomposition.a7", "decomposition.a8", "decomposition.b1", "decomposition.d10", "decomposition.d11", "decomposition.d12", "decomposition.d13", "decomposition.d18", "diagnostics.seas-si-combined", "diagnostics.seas-sa-friedman", "residuals.independence.value")
```

The `make_paramfile` function constructs the same specifications for all
series as defined in the input. To adjust for individual series, use the
function `edit_constraints` and adjust the individual settings in the
shiny application that pops up.

``` r


#spec_file <- edit_constraints(spec_file)
```

``` r


spec_file$set_outlier__outliers.type[2] <- NA
spec_file$spec[3] <- "\"rsa5c\""
spec_file$automdl.enabled[1] <- "FALSE"
```

Resulting in a frame with individual settings for each series. For
example:

``` r

spec_file
#>       name    spec set_outlier__outliers.type set_transform__fun
#> 1  rti_472  "rsa3"              c("LS", "AO")              "Log"
#> 2  rti_476  "rsa3"                       <NA>              "Log"
#> 3 rti_4751 "rsa5c"              c("LS", "AO")              "Log"
#>   automdl.enabled
#> 1           FALSE
#> 2            TRUE
#> 3            TRUE
#>                                                                                                                                                                                                                                                                                                      userdefined
#> 1 c("decomposition.a1", "decomposition.a6", "decomposition.a7", "decomposition.a8", "decomposition.b1", "decomposition.d10", "decomposition.d11", "decomposition.d12", "decomposition.d13", "decomposition.d18", "diagnostics.seas-si-combined", "diagnostics.seas-sa-friedman", "residuals.independence.value")
#> 2 c("decomposition.a1", "decomposition.a6", "decomposition.a7", "decomposition.a8", "decomposition.b1", "decomposition.d10", "decomposition.d11", "decomposition.d12", "decomposition.d13", "decomposition.d18", "diagnostics.seas-si-combined", "diagnostics.seas-sa-friedman", "residuals.independence.value")
#> 3 c("decomposition.a1", "decomposition.a6", "decomposition.a7", "decomposition.a8", "decomposition.b1", "decomposition.d10", "decomposition.d11", "decomposition.d12", "decomposition.d13", "decomposition.d18", "diagnostics.seas-si-combined", "diagnostics.seas-sa-friedman", "residuals.independence.value")
```

Note that a blank field means that the setting is not used for the
series in question.

To add new specifications to an already existing specification frame,
use the function `add_constraint`:

Now, to adjust the multiple time series object based on the data frame,
on can use the function `x13_text_frame` Output of the function is a
list of sa output objects for each time series in the mts.

``` r


sa_mult <- pickmdl3::x13_text_frame(text_frame= spec_file,ts = "rti_mts")
#> Warning in crit_selection(crit_tab_i, star = 0, when_star = when_star_here): No
#> model is ok according to criteria
```

To evaluate indivudual series:

``` r


sa_mult$rti_472
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: yes 
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> SARIMA coefficients:
#>  theta(1) btheta(1) 
#>   -0.7788   -0.9998 
#> 
#> Regression model:
#> AO (2021-03-01) 
#>          0.2224 
#> 
#>  Seasonal filter: FILTER_S3X5;  Trend filter: H-23 terms
#>  M-Statistics: q Good (0.590); q-m2 Good (0.644)
#>  QS test on SA: Good (1.000);  F-test on SA: Good (1.000)
#> 
#> For a more detailed output, use the 'summary()' function.
sa_mult$rti_476
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: yes 
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> SARIMA coefficients:
#>  theta(1) btheta(1) 
#>   -0.8032   -0.3312 
#> 
#> Regression model:
#> LS (2020-02-01) AO (2020-03-01) 
#>          0.1854         -0.3411 
#> 
#>  Seasonal filter: FILTER_S3X5;  Trend filter: H-23 terms
#>  M-Statistics: q Good (0.671); q-m2 Good (0.724)
#>  QS test on SA: Good (0.534);  F-test on SA: Good (0.760)
#> 
#> For a more detailed output, use the 'summary()' function.
sa_mult$rti_4751
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: yes 
#> SARIMA model: (1,0,2) (0,1,1)
#> 
#> SARIMA coefficients:
#>    phi(1)  theta(1)  theta(2) btheta(1) 
#>   -0.8132   -0.3264   -0.1841   -0.4981 
#> 
#> Regression model:
#>     const       mon       tue       wed       thu       fri       sat    easter 
#>  0.036961 -0.012811  0.006242  0.009563 -0.008628  0.017098  0.010154 -0.070936 
#> 
#>  Seasonal filter: FILTER_S3X5;  Trend filter: H-23 terms
#>  M-Statistics: q Good (0.558); q-m2 Good (0.597)
#>  QS test on SA: Good (0.482);  F-test on SA: Good (0.993)
#> 
#> For a more detailed output, use the 'summary()' function.
```
