# Basic functionality

## Introduction

The `pickdml3` package contains functionality for running the
X12-ARIMA-SEATS pickdml selection procedure when using the x13
methodology in rjd3. In this vignette we explore the basic function
`x13_pickmdl`, which is, as its name indicates, a function that runs the
x13() algorithm from rjd3x13, but with pickdml as model selection
procedure instead of the default automdl procedure.

We begin by loading a time series to be seasonally adjusted. The series
in question is the Norwegian retail index for NACE 47.6, Retail sale of
cultural and recreation goods, between January 2014 and July 2026. We
also define a specification, using the default specification ‘rsa5c’,
only allowing level shift and additive outliers, however.

The function `x13_pickmdl`takes the series and the specification as
inputs, and gives the fitted model results as output in a list, just as
is the case with the `x13` function.

``` r


library(rjd3toolkit)
#> 
#> Attaching package: 'rjd3toolkit'
#> The following objects are masked from 'package:stats':
#> 
#>     aggregate, mad
library(rjd3x13)
#> 
#> Attaching package: 'rjd3x13'
#> The following object is masked from 'package:grDevices':
#> 
#>     x11

rti_476 <- pickmdl3::pickmdl_data("norwegian_rti")$rti_476
#rti_476 <- pickmdl3::pickmdl_data("myseries")

spec_now <- x13_spec("rsa5c") |>
#  set_transform(fun="Log")|>
  set_outlier(outliers.type=c("AO","LS")) 

model_476 <- pickmdl3::x13_pickmdl(ts = rti_476,spec=spec_now)

model_476
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: yes 
#> SARIMA model: (2,1,0) (0,1,1)
#> 
#> SARIMA coefficients:
#>    phi(1)    phi(2) btheta(1) 
#>    0.5141    0.1056   -0.4443 
#> 
#> Regression model:
#>             mon             tue             wed             thu             fri 
#>      -0.0107469       0.0062918       0.0099814      -0.0068710       0.0190396 
#>             sat AO (2020-01-01) AO (2020-03-01) LS (2020-05-01) LS (2020-08-01) 
#>       0.0007883      -0.1749130      -0.2249022       0.2078185      -0.1806520 
#> LS (2021-05-01) LS (2021-08-01) 
#>       0.2242468      -0.1430262 
#> 
#>  Seasonal filter: FILTER_S3X5;  Trend filter: H-13 terms
#>  M-Statistics: q Good (0.393); q-m2 Good (0.433)
#>  QS test on SA: Good (0.975);  F-test on SA: Good (0.547)
#> 
#> For a more detailed output, use the 'summary()' function.
```

From the output list, we can read that the selected sARIMA model is
(2,1,0)(0,1,1). Information about the model choiche can also be
retrieved with the function `ok`.

``` r

pickmdl3::ok(model_476)  
#> $ok
#> [1] TRUE
#> 
#> $ok_final
#> [1] TRUE
#> 
#> $mdl_nr
#> [1] 3
```

The first object in this list tells us that the selected model fulfills
the criteria. The object mdl_nr tells us that the third model on the
list was selected, which of course is the (2,1,0)(0,1,1) model.

The user can get more information about the pickmdl procedure by setting
the parameter `output` to “all”. Now the calculated criteria are
provided for each model in the output object `crit_tab`. Using this, we
can now see that the first two models were rejected because they failed
on the second criterium, that is the they failed the test to check
wheter residuals are independent. One can now also access all calculated
models, for example if one needs to compare results in detail.

``` r

model_476 <- pickmdl3::x13_pickmdl(ts = rti_476,spec=spec_now,output = "all")  

model_476$mdl_nr 
#> [1] 3

model_476$crit_tab
#>           crit1      crit2      crit3    m_aic
#> [1,] 0.03655921 0.02228086 -0.7916005 860.9283
#> [2,] 0.03546483 0.02464104 -0.7901148 831.0459
#> [3,] 0.03107798 0.64725040  0.0000000 788.2761

all_models <- model_476$sa
```

We can see that the list of models only contains the three first models
on the list of five models. This is because the algorithm stops by
default when it has found a model on the list that fulfills the
criteria. If the user wants to fit all five models, the parameter
`fastfirst`needs to be set to `FALSE`.

``` r


model_now <- pickmdl3::x13_pickmdl(ts = rti_476,spec=spec_now,output = "all",fastfirst = FALSE)

model_now$crit_tab
#>           crit1       crit2      crit3    m_aic
#> [1,] 0.03655921 0.022280863 -0.7916005 860.9283
#> [2,] 0.03546483 0.024641045 -0.7901148 831.0459
#> [3,] 0.03107798 0.647250400  0.0000000 788.2761
#> [4,] 0.03154734 0.177456254 -0.9999757 852.7246
#> [5,] 0.03483096 0.008379515 -0.7677882 838.9111
```

One can also use the automdl procedure within the x13_pickmdl function
by setting the parameter `automdl.enabled = TRUE`. This will override
the pickdml procedure.

``` r


model_now <- pickmdl3::x13_pickmdl(ts = rti_476, spec = spec_now, automdl.enabled = TRUE)

model_now 
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: yes 
#> SARIMA model: (1,0,1) (0,1,1)
#> 
#> SARIMA coefficients:
#>    phi(1)  theta(1) btheta(1) 
#>   -0.7505   -0.2654   -0.3421 
#> 
#> Regression model:
#>             mon             tue             wed             thu             fri 
#>       -0.012691        0.012751        0.005173       -0.011958        0.023985 
#>             sat LS (2020-02-01) AO (2020-03-01) 
#>        0.001713        0.164992       -0.270125 
#> 
#>  Seasonal filter: FILTER_S3X3;  Trend filter: H-13 terms
#>  M-Statistics: q Good (0.502); q-m2 Good (0.559)
#>  QS test on SA: Good (1.000);  F-test on SA: Good (0.687)
#> 
#> For a more detailed output, use the 'summary()' function.
```
