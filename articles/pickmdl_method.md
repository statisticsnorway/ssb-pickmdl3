# Alternatives when no model is acceptable

When using the `pickdml`selection procedure, it may be happen that none
of the five models on the pickmdl list fulfills the three predefined
criteria. In such cases, the default choiche is to choose the first
model on the list, that is the AIRLINE model. It may however be that
other models fits the data well. In such cases the pickmodel procedure
selects a poorly fitted model, even though an acceptable model would
have been available to the automodel procedure. To mitigate this risk
the pickmdl3 package provides the alternative of falling back on the
automodel approach when none of the five listed models proves adequate.
This is done by setting the option `pickmdl_method` in `x13_pickmdl`.

## pickmdl_method = first

Let us first show that the pickmdl procedure by default falls back on
the AIRLINE model when none of the models on the list passes the
pre-defined criteria. This is the default option
`pickmdl_method = "first"`. We select the standard specification
`rsa3`and the Norwegian retail index for nace 47.2 to illustrate the
case.

``` r



rti_472 <- pickmdl3::pickmdl_data("norwegian_rti")$rti_472
spec_now <- x13_spec("rsa3")

model_now <- pickmdl3::x13_pickmdl(rti_472,spec_now, pickmdl_method="first")
#> Warning in crit_selection(crit_tab_i, star = 0, when_star = when_star_here): No
#> model is ok according to criteria
```

We see that a warning is given that tells us that none of the models on
the pickmdl list are acceptable. The `ok` function tells us further that
the first model is selected, i.e. the AIRLINE model, but that this model
is not acceptable according to the criteria.

``` r

pickmdl3::ok(model_now)
#> $ok
#> [1] FALSE
#> 
#> $ok_final
#> [1] FALSE
#> 
#> $mdl_nr
#> [1] 1
```

If the user wants to change the default model, this may be done by
setting the `star` parameter. In the example below, the procedure now
falls back on the third model on the list.

``` r


model_now <- pickmdl3::x13_pickmdl(rti_472,spec_now, pickmdl_method="first", star=3)
#> Warning in crit_selection(crit_tab_i, star = 0, when_star = when_star_here): No
#> model is ok according to criteria
pickmdl3::ok(model_now)
#> $ok
#> [1] FALSE
#> 
#> $ok_final
#> [1] FALSE
#> 
#> $mdl_nr
#> [1] 3
```

## pickmdl_method = first_automdl

To let the `x13_pickdml` fall back on the automodel procedure when none
of the models on the pickmdl list are acceptable, set the
`pickmdl_method = try_automdl`. Below this is illustrated with the
norwegian retail index for nace 47.51. A warning tells the user that the
procedure has switched to the automdl procedure, which means that none
of the models on the list passed the criteria. From the output of `ok`
we now see that the selected model fulfills the criteria, however. The
model number is 6, which means that this is a model selected by the
automodel procedure. The model output shows that the model in question
is of order $`(1,0,2)(1,1,1)_s`$.

``` r

rti_4751 <- pickmdl3::pickmdl_data("norwegian_rti")$rti_4751
spec_now <- x13_spec("rsa4")|>
  set_outlier(outliers.type=NULL) 
model_now <-pickmdl3::x13_pickmdl(rti_4751, spec=spec_now,
                                  pickmdl_method = "first_automdl")
#> automdl since no pickmdl model ok

pickmdl3::ok(model_now)
#> $ok
#> [1] TRUE
#> 
#> $ok_final
#> [1] TRUE
#> 
#> $mdl_nr
#> [1] 6

model_now
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: yes 
#> SARIMA model: (1,0,2) (1,1,1)
#> 
#> SARIMA coefficients:
#>    phi(1)  theta(1)  theta(2)   bphi(1) btheta(1) 
#>   -0.8092   -0.4119   -0.1584   -0.4275   -1.0000 
#> 
#> Regression model:
#>    const   easter 
#>  0.03745 -0.06408 
#> 
#>  Seasonal filter: FILTER_S3X5;  Trend filter: H-23 terms
#>  M-Statistics: q Good (0.590); q-m2 Good (0.627)
#>  QS test on SA: Good (0.444);  F-test on SA: Good (0.995)
#> 
#> For a more detailed output, use the 'summary()' function.
```

## pickmdl_method = first_tryautomdl

There are cases where neither the pickmdl procedure nor the automdl
procedure will be able to identify a model that passes the criteria. In
such cases one should consider falling back on a parsimonious default
model, e.g. the AIRLINE model, although this model too provides seasonal
adjustment of poor quality. This may still be considered a better
strategy than selecting the optimally fitted model with the automodel
procedure, as this approach now introduces the risk of model change in
addition to the poor quality of an ill fitted model.

When the option `pickmdl_method` is set to `first_tryautomdl`, the
`x13_pickmdl` function first checks the models on the pickmdl list. If
none of these five models fulfills the criteria, a model is selected
with the automodel procedure. If this model too does not fulfill the
thre criteria, the default model defined by star is selected.

``` r

spec_now <- x13_spec("rsa3")

model_now <- pickmdl3::x13_pickmdl(rti_472,spec_now, pickmdl_method="first_tryautomdl")
#> Warning in crit_selection(crit_tab_i, star = 0, when_star = when_star_here): No
#> model is ok according to criteria
pickmdl3::ok(model_now)
#> $ok
#> [1] FALSE
#> 
#> $ok_final
#> [1] FALSE
#> 
#> $mdl_nr
#> [1] 1
```
