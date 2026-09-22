# Basic functionality

In this vignette we explore the basic function `x13_pickmdl`. As its
name indicates, this function is a wrapper function that runs the `x13`
function, but with pickdml rather than automodel as the default model
selection procedure.

We first load a time series to be seasonally adjusted. The series in
question is the Norwegian retail index for nace 47.6, , between January
2014 and July 2026. We define a specification to be used in the example,
namely the default specification ‘rsa5c’, where we turn off transtive
outliers.

Just as in the `x13` function, `x13_pickmdl` takes the time series and
the specification as inputs. Output is a list with fitted model results,
where the most important information is shown in the console. We see
that the model of order $`(2,1,0)(0,1,1)_s`$ is selected.

``` r


library(rjd3toolkit)
library(rjd3x13)
library(pickmdl3)

rti_476 <- pickmdl3::pickmdl_data("norwegian_rti")$rti_476

spec_now <- x13_spec("rsa5c") |>
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

Further information about the model choiche can be retrieved with the
function `ok`, which gives the user a list with three objects. The first
object `$ok` tells the user whether the selected model fulfills the
three pickmdl criteria at the moment of model selection. The second
object `ok_final` says wheter the selected model fulfills the three
pickmdl criteria at the end of the time series. The third object
`mdl_nr` says which model on the pickmdl list that was selected. We see
that the third model was selected, which of course is the model of order
$`(2,1,0)(0,1,1)_s`$.

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

The calculated pickmodel criteria are included in the output if the
option `output` is set to “all”. Now we can see that the first two
models were rejected because they didn’t pass the second criterium,
which is indepedent residuals.

``` r

model_476 <- pickmdl3::x13_pickmdl(ts = rti_476,spec=spec_now,output = "all")  
model_476$crit_tab
#>           crit1      crit2      crit3    m_aic
#> [1,] 0.03655921 0.02228086 -0.7916005 860.9283
#> [2,] 0.03546483 0.02464104 -0.7901148 831.0459
#> [3,] 0.03107798 0.64725040  0.0000000 788.2761
```

Note that there are only three models on the list. This is because the
algorithm by default stops at the first model that passes the criteria.
To force calculation of all five models, set the option
`fastfirst = FALSE`:

``` r

model_476 <- pickmdl3::x13_pickmdl(ts = rti_476,spec=spec_now,output = "all",
                                   fastfirst = FALSE)
model_476$crit_tab
#>           crit1       crit2      crit3    m_aic
#> [1,] 0.03655921 0.022280863 -0.7916005 860.9283
#> [2,] 0.03546483 0.024641045 -0.7901148 831.0459
#> [3,] 0.03107798 0.647250400  0.0000000 788.2761
#> [4,] 0.03154734 0.177456254 -0.9999757 852.7246
#> [5,] 0.03483096 0.008379515 -0.7677882 838.9111
```

When the option `output = "all"`, the selected model is available in
`$sa`. A list of all the calculated models in the pickmdl list are given
in `$all`.

``` r

model_476$sa
model_476$sa_mult
```

Finally, the automodel procedure maybe used also with the `x13_pickmdl`
function. When `automdl.enabled = TRUE` the automodel procedure is
selected, which gives the exact same result as the `x13` function.

``` r

model_476_auto <- pickmdl3::x13_pickmdl(ts = rti_476, spec = spec_now, automdl.enabled = TRUE)
model_476_auto 
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
