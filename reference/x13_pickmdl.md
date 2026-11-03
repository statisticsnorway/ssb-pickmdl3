# x13 with PICKMDL and partial concurrent possibilities

[`x13`](https://rjdverse.github.io/rjd3x13/reference/x13.html) can be
run as usual (automdl) or with a PICKMDL specification. The ARIMA model,
outliers and filters can be identified at a certain date and then held
fixed (with a new outlier-span).

## Usage

``` r
x13_pickmdl(
  ts,
  spec,
  corona = FALSE,
  ...,
  pickmdl_method = "first",
  star = 1,
  when_star = warning,
  when_automdl = message,
  when_finalnotok = NULL,
  identification_end = NULL,
  identification_estimate.to = NULL,
  policy = "Outliers",
  identify_t_filter = FALSE,
  identify_s_filter = FALSE,
  identify_outliers = TRUE,
  identify_arima_mu = TRUE,
  automdl.enabled = FALSE,
  fastfirst = TRUE,
  verbose = FALSE,
  output = "sa",
  add_comment = TRUE
)

x13_automdl(..., automdl.enabled = TRUE)
```

## Arguments

- ts:

  `x13` parameter

- spec:

  A "JD3_X13_SPEC" class object as generated with
  [`x13_spec`](https://rjdverse.github.io/rjd3x13/reference/x13_spec.html)
  or a list of several such objects as outputted from
  [`x13_spec_pickmdl`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/x13_spec_pickmdl.md).
  In the case of a single object and when `automdl.enabled` is `FALSE`,
  `spec` will be converted internally by `x13_spec_pickmdl` with default
  five arima model specifications.

- corona:

  Whether to update `spec` by outliers according to
  [`corona_outliers`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/corona_outliers.md).
  `FALSE` or `NULL` means no update. `TRUE` or `"ssb"` means update.

- ...:

  Further `x13` parameters (currently only parameter `userdefined` is
  additional parameter to `x13`).

- pickmdl_method:

  [`crit_selection`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/crit_selection.md)
  parameter or one of the two extra possibilities, `"first_automdl"` or
  `"first_tryautomdl"`. In both cases the `crit_selection` parameter is
  `"first"` and the automdl model is added as the last pickmdl model.

  - **`"first_automdl"`:** The automdl model is chosen whenever no
    pickmdl model is ok. In other words, the `star` parameter changes.

  - **`"first_tryautomdl"`:** When no pickmdl model is ok: The automdl
    model is chosen if this model is ok, otherwise the `star` model is
    chosen.

- star:

  [`crit_selection`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/crit_selection.md)
  parameter

- when_star:

  [`crit_selection`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/crit_selection.md)
  parameter

- when_automdl:

  Function to be called when automdl since no pickmdl model ok. Supply
  NULL to do nothing.

- when_finalnotok:

  Function to be called, e.g.
  [`warning`](https://rdrr.io/r/base/warning.html), when final run with
  final model is not ok. Supply NULL to do nothing. See
  [`crit_ok`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/crit_ok.md).

- identification_end:

  To shorten the series before runs used to identify (arima) parameters.
  That is, the series is shortened by `window(ts,`
  `end = identification_end)`.

- identification_estimate.to:

  To set
  [`set_estimate`](https://rjdverse.github.io/rjd3toolkit/reference/set_estimate.html)
  parameter `d1` before runs used to identify (arima) parameters. This
  is an alternative to `identification_end`.

- policy:

  Which refresh policy when model identification by shortened series.
  See
  [`x13_refresh`](https://rjdverse.github.io/rjd3x13/reference/refresh.html).

- identify_t_filter:

  When `TRUE`, Henderson trend filter is identified by the shortened
  (see above) series.

- identify_s_filter:

  When `TRUE`, Seasonal moving average filter is identified by the
  shortened series.

- identify_outliers:

  When `TRUE`, Outliers are identified by the shortened series.

- identify_arima_mu:

  When `TRUE`, `arima.mu` is identified by the shortened series (see
  [`arima_mu`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/arima_mu.md)).

- automdl.enabled:

  Logical value or any other value.

  - When set to `FALSE` (the default), the pickmdl routine is applied.

  - When set to `TRUE`, the automdl routine is performed.

  - For any value other than `TRUE` or `FALSE`, the ARIMA model is
    chosen as specified by `spec`.

  Note that when `automdl.enabled` is not `FALSE`, if `spec` is a list
  containing several objects outputted from `x13_spec_pickmdl`, only the
  first object is used.

- fastfirst:

  When `TRUE` and when pickmdl with `crit_selection` parameter
  `"first"`, only as many models as needed are run. This affects the
  output when `output = "all"`.

- verbose:

  Printing information to console when `TRUE`.

- output:

  One of `"sa"` (default), `"spec"` (final spec), `"sa_spec"` (both) and
  `"all"`. See examples.

- add_comment:

  When `TRUE`, a comment attribute (character vector with `ok`,
  `ok_final` and `mdl_nr`) will be added to the
  [`x13`](https://rjdverse.github.io/rjd3x13/reference/x13.html) output
  object. Use [`comment`](https://rdrr.io/r/base/comment.html) to get
  the attribute or
  [`ok`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/ok.md)
  to get the attribute converted to a list.

## Value

By default an `x13` output object, or otherwise a list as specified by
parameter `output`.

## Examples

``` r
myseries <- pickmdl_data("myseries")

spec_a  <- rjd3x13::x13_spec(name = "rsa3")
spec_a <- rjd3toolkit::set_transform(spec_a, fun = "Log")

a <- x13_pickmdl(myseries, spec_a, verbose = TRUE)
#> [1] "SARIMA model: (2,1,0) (0,1,1)"
comment(a)
#>       ok ok_final   mdl_nr 
#>   "TRUE"   "TRUE"      "3" 
ok(a)
#> $ok
#> [1] TRUE
#> 
#> $ok_final
#> [1] TRUE
#> 
#> $mdl_nr
#> [1] 3
#> 
unlist(ok(a))
#>       ok ok_final   mdl_nr 
#>        1        1        3 
summary(a$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (2,1,0) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error  T-stat Pr(>|t|)    
#> phi(1)     0.98483    0.06035  16.318   <2e-16 ***
#> phi(2)     0.57655    0.06041   9.544   <2e-16 ***
#> btheta(1) -0.89213    0.07920 -11.264   <2e-16 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Regression model:
#>                 Estimate Std. Error T-stat Pr(>|t|)    
#> TC (2011-06-01) -0.19046    0.04705 -4.048 7.61e-05 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> Number of observations: 201, Number of effective observations: 188, Number of parameters: 5
#> Loglikelihood: 230.554, Adjusted loglikelihood: -624.9538
#> Standard error of the regression (ML estimate): 0.06727615 
#> AIC: 1259.908, AICc: 1260.237, BIC: 1276.09

a2 <- x13_pickmdl(myseries, spec_a, identification_end = c(2014, 2))
summary(a2$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (0,1,2) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error  T-stat Pr(>|t|)    
#> theta(1)  -1.12616    0.06430 -17.515  < 2e-16 ***
#> theta(2)   0.34892    0.06677   5.226 4.65e-07 ***
#> btheta(1) -0.96565    0.21022  -4.593 8.05e-06 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> No regression variables
#> Number of observations: 201, Number of effective observations: 188, Number of parameters: 4
#> Loglikelihood: 227.209, Adjusted loglikelihood: -628.2988
#> Standard error of the regression (ML estimate): 0.06684178 
#> AIC: 1264.598, AICc: 1264.816, BIC: 1277.543

# As above, another way
a3 <- x13_pickmdl(myseries, spec_a, identification_estimate.to = "2014-03-01")
summary(a3$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (0,1,2) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error  T-stat Pr(>|t|)    
#> theta(1)  -1.12616    0.06430 -17.515  < 2e-16 ***
#> theta(2)   0.34892    0.06677   5.226 4.65e-07 ***
#> btheta(1) -0.96565    0.21022  -4.593 8.05e-06 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> No regression variables
#> Number of observations: 201, Number of effective observations: 188, Number of parameters: 4
#> Loglikelihood: 227.209, Adjusted loglikelihood: -628.2988
#> Standard error of the regression (ML estimate): 0.06684178 
#> AIC: 1264.598, AICc: 1264.816, BIC: 1277.543

a4 <- x13_automdl(myseries, spec_a, identification_end = c(2014, 2))
summary(a4$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (1,0,2) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error  T-stat Pr(>|t|)    
#> phi(1)    -0.95221    0.03452 -27.581  < 2e-16 ***
#> theta(1)  -1.10920    0.06928 -16.011  < 2e-16 ***
#> theta(2)   0.36254    0.07172   5.055 1.03e-06 ***
#> btheta(1) -0.99999    1.07677  -0.929    0.354    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Regression model:
#>       Estimate Std. Error T-stat Pr(>|t|)    
#> const 0.026745   0.003966  6.744 1.95e-10 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> Number of observations: 201, Number of effective observations: 189, Number of parameters: 6
#> Loglikelihood: 232.0136, Adjusted loglikelihood: -627.9996
#> Standard error of the regression (ML estimate): 0.06488971 
#> AIC: 1267.999, AICc: 1268.461, BIC: 1287.45

# As above, another way
a5 <- x13_automdl(myseries, spec_a, identification_estimate.to = "2014-03-01")
summary(a5$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (1,0,2) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error  T-stat Pr(>|t|)    
#> phi(1)    -0.95221    0.03452 -27.581  < 2e-16 ***
#> theta(1)  -1.10920    0.06928 -16.011  < 2e-16 ***
#> theta(2)   0.36254    0.07172   5.055 1.03e-06 ***
#> btheta(1) -0.99999    1.07677  -0.929    0.354    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Regression model:
#>       Estimate Std. Error T-stat Pr(>|t|)    
#> const 0.026745   0.003966  6.744 1.95e-10 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> Number of observations: 201, Number of effective observations: 189, Number of parameters: 6
#> Loglikelihood: 232.0136, Adjusted loglikelihood: -627.9996
#> Standard error of the regression (ML estimate): 0.06488971 
#> AIC: 1267.999, AICc: 1268.461, BIC: 1287.45


allvar <- pickmdl_data("allvar")
allvar <- list(arb_dag=allvar[,1],skuddar=allvar[,2])
my_context <- modelling_context(variables=allvar)
spec_b <- rjd3x13::x13_spec(name= "rsa3")
spec_b <- rjd3toolkit::set_transform(spec_b,fun="Log")
spec_b <- rjd3toolkit::set_tradingdays(spec_b,
                       option="Userdefined",uservariable=c("r.arb_dag","r.skuddar"))
spec_b <- rjd3toolkit::set_outlier(spec_b,outliers.type=NULL)
spec_b <- rjd3toolkit::add_outlier(spec_b,type=rep("LS",20),
                           date = c("2009-01-01", "2016-01-01", "2020-03-01",
                                    "2020-04-01", "2020-05-01", "2020-06-01",
                                    "2020-07-01", "2020-08-01", "2020-09-01",
                                    "2020-10-01", "2020-11-01", "2020-12-01",
                                    "2021-01-01", "2021-02-01", "2021-03-01",
                                    "2021-04-01", "2021-05-01", "2021-06-01",
                                    "2021-07-01", "2021-08-01"))
b <- x13_pickmdl(myseries,spec_b, identification_end = c(2020, 2),context=my_context)
summary(b$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error T-stat Pr(>|t|)    
#> theta(1)  -0.82140    0.04367 -18.81   <2e-16 ***
#> btheta(1) -0.85625    0.06857 -12.49   <2e-16 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Regression model:
#>                   Estimate Std. Error T-stat Pr(>|t|)    
#> r.arb_dag        0.0109384  0.0008939 12.237   <2e-16 ***
#> r.skuddar        0.0550904  0.0275650  1.999   0.0473 *  
#> LS (2009-01-01) -0.0903091  0.0299686 -3.013   0.0030 ** 
#> LS (2016-01-01) -0.0398352  0.0300034 -1.328   0.1861    
#> LS (2020-03-01) -0.0045544  0.0532111 -0.086   0.9319    
#> LS (2020-04-01) -0.1263244  0.0686000 -1.841   0.0674 .  
#> LS (2020-05-01)  0.0672858  0.0683746  0.984   0.3265    
#> LS (2020-06-01) -0.0132324  0.0684061 -0.193   0.8469    
#> LS (2020-07-01)  0.1088670  0.0684040  1.592   0.1134    
#> LS (2020-08-01) -0.1185788  0.0685184 -1.731   0.0854 .  
#> LS (2020-09-01)  0.0434945  0.0679224  0.640   0.5228    
#> LS (2020-10-01) -0.0217233  0.0682748 -0.318   0.7508    
#> LS (2020-11-01)  0.0273831  0.0683750  0.400   0.6893    
#> LS (2020-12-01)  0.0317430  0.0686204  0.463   0.6443    
#> LS (2021-01-01) -0.0716395  0.0690694 -1.037   0.3012    
#> LS (2021-02-01) -0.0044989  0.0690584 -0.065   0.9481    
#> LS (2021-03-01)  0.0098894  0.0693131  0.143   0.8867    
#> LS (2021-04-01)  0.0248501  0.0691176  0.360   0.7197    
#> LS (2021-05-01) -0.0517386  0.0693224 -0.746   0.4565    
#> LS (2021-06-01) -0.0353851  0.0695798 -0.509   0.6118    
#> LS (2021-07-01) -0.0175290  0.0692027 -0.253   0.8004    
#> LS (2021-08-01)  0.0569751  0.0602051  0.946   0.3454    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> Number of observations: 201, Number of effective observations: 188, Number of parameters: 25
#> Loglikelihood: 290.6109, Adjusted loglikelihood: -564.8969
#> Standard error of the regression (ML estimate): 0.04928409 
#> AIC: 1179.794, AICc: 1187.819, BIC: 1260.705

# automdl instead
b1 <- x13_automdl(myseries, spec_b, identification_end = c(2020, 2),context=my_context)
summary(b1$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error T-stat Pr(>|t|)    
#> theta(1)  -0.82140    0.04367 -18.81   <2e-16 ***
#> btheta(1) -0.85625    0.06857 -12.49   <2e-16 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Regression model:
#>                   Estimate Std. Error T-stat Pr(>|t|)    
#> r.arb_dag        0.0109384  0.0008939 12.237   <2e-16 ***
#> r.skuddar        0.0550904  0.0275650  1.999   0.0473 *  
#> LS (2009-01-01) -0.0903091  0.0299686 -3.013   0.0030 ** 
#> LS (2016-01-01) -0.0398352  0.0300034 -1.328   0.1861    
#> LS (2020-03-01) -0.0045544  0.0532111 -0.086   0.9319    
#> LS (2020-04-01) -0.1263244  0.0686000 -1.841   0.0674 .  
#> LS (2020-05-01)  0.0672858  0.0683746  0.984   0.3265    
#> LS (2020-06-01) -0.0132324  0.0684061 -0.193   0.8469    
#> LS (2020-07-01)  0.1088670  0.0684040  1.592   0.1134    
#> LS (2020-08-01) -0.1185788  0.0685184 -1.731   0.0854 .  
#> LS (2020-09-01)  0.0434945  0.0679224  0.640   0.5228    
#> LS (2020-10-01) -0.0217233  0.0682748 -0.318   0.7508    
#> LS (2020-11-01)  0.0273831  0.0683750  0.400   0.6893    
#> LS (2020-12-01)  0.0317430  0.0686204  0.463   0.6443    
#> LS (2021-01-01) -0.0716395  0.0690694 -1.037   0.3012    
#> LS (2021-02-01) -0.0044989  0.0690584 -0.065   0.9481    
#> LS (2021-03-01)  0.0098894  0.0693131  0.143   0.8867    
#> LS (2021-04-01)  0.0248501  0.0691176  0.360   0.7197    
#> LS (2021-05-01) -0.0517386  0.0693224 -0.746   0.4565    
#> LS (2021-06-01) -0.0353851  0.0695798 -0.509   0.6118    
#> LS (2021-07-01) -0.0175290  0.0692027 -0.253   0.8004    
#> LS (2021-08-01)  0.0569751  0.0602051  0.946   0.3454    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> Number of observations: 201, Number of effective observations: 188, Number of parameters: 25
#> Loglikelihood: 290.6109, Adjusted loglikelihood: -564.8969
#> Standard error of the regression (ML estimate): 0.04928409 
#> AIC: 1179.794, AICc: 1187.819, BIC: 1260.705

# effect of identify_t_filter and identify_s_filter
set.seed(1)
rndseries <- ts(rep(1:12, 20) + (1 + (1:240)/20) * runif(240) + 0.5 * c(rep(1, 120), (1:120)^2),
                frequency = 12, start = c(2000, 1))
spec_c <- rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"),outliers.type=NULL)
c1 <- x13_automdl(rndseries, spec_c, identification_end = c(2009, 12))
c1
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: no 
#> SARIMA model: (0,0,0) (1,1,0)
#> 
#> SARIMA coefficients:
#> bphi(1) 
#> -0.9871 
#> 
#> Regression model:
#> const 
#> 617.6 
#> 
#>  Seasonal filter: FILTER_S3X5;  Trend filter: H-9 terms
#>  M-Statistics: q Good (0.533); q-m2 Good (0.598)
#>  QS test on SA: NA (0.000);  F-test on SA: Good (0.989)
#> 
#> For a more detailed output, use the 'summary()' function.
c2 <- x13_automdl(rndseries, spec_c, identification_end = c(2009, 12), identify_t_filter = TRUE)
c2
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: no 
#> SARIMA model: (0,0,0) (1,1,0)
#> 
#> SARIMA coefficients:
#> bphi(1) 
#> -0.9871 
#> 
#> Regression model:
#> const 
#> 617.6 
#> 
#>  Seasonal filter: FILTER_S3X5;  Trend filter: H-23 terms
#>  M-Statistics: q Good (0.538); q-m2 Good (0.604)
#>  QS test on SA: NA (0.000);  F-test on SA: Good (0.982)
#> 
#> For a more detailed output, use the 'summary()' function.
c3 <- x13_automdl(rndseries, spec_c, identification_end = c(2009, 12), identify_t_filter = TRUE,
                  identify_s_filter = TRUE)
c3
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: no 
#> SARIMA model: (0,0,0) (1,1,0)
#> 
#> SARIMA coefficients:
#> bphi(1) 
#> -0.9871 
#> 
#> Regression model:
#> const 
#> 617.6 
#> 
#>  Seasonal filter: FILTER_S3X5;  Trend filter: H-23 terms
#>  M-Statistics: q Good (0.526); q-m2 Good (0.599)
#>  QS test on SA: NA (0.000);  F-test on SA: Good (0.990)
#> 
#> For a more detailed output, use the 'summary()' function.


# Warning when transform.function = "None"
spec_d  <- rjd3toolkit::set_transform(rjd3x13::x13_spec("rsa3"), fun = "None")
d <- x13_pickmdl(myseries, spec_d, verbose = TRUE)
#> Warning: No model is ok according to criteria
#> [1] "SARIMA model: (0,1,1) (0,1,1)"

# Warning avoided (when_star) and 2nd (star) model selected
d2 <- x13_pickmdl(myseries, spec_d, star = 2, when_star = NULL, verbose = TRUE)
#> [1] "SARIMA model: (0,1,2) (0,1,1)"

# automdl since no pickmdl model ok, but still not ok
d3 <- x13_pickmdl(myseries, spec_d, pickmdl_method = "first_automdl", verbose = TRUE)
#> Warning: No model is ok according to criteria
#> [1] "SARIMA model: (2,1,1) (0,1,1)"
#> automdl since no pickmdl model ok

# airline model (star) since automdl also not ok
d4 <- x13_pickmdl(myseries, spec_d, pickmdl_method = "first_tryautomdl", verbose = TRUE,
                  when_finalnotok = warning) # also finalnotok warning
#> Warning: No model is ok according to criteria
#> [1] "SARIMA model: (0,1,1) (0,1,1)"
#> Warning: FINAL RUN NOT OK

# As b, with output = "all"
k <- x13_pickmdl(myseries, spec_b, identification_end = c(2014, 2), context = my_context,
                 output = "all", fastfirst = FALSE) # With TRUE only one model in this case
summary(k$sa$result$preprocessing)  # As summary(b$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error T-stat Pr(>|t|)    
#> theta(1)  -0.82140    0.04367 -18.81   <2e-16 ***
#> btheta(1) -0.85625    0.06857 -12.49   <2e-16 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Regression model:
#>                   Estimate Std. Error T-stat Pr(>|t|)    
#> r.arb_dag        0.0109384  0.0008939 12.237   <2e-16 ***
#> r.skuddar        0.0550904  0.0275650  1.999   0.0473 *  
#> LS (2009-01-01) -0.0903091  0.0299686 -3.013   0.0030 ** 
#> LS (2016-01-01) -0.0398352  0.0300034 -1.328   0.1861    
#> LS (2020-03-01) -0.0045544  0.0532111 -0.086   0.9319    
#> LS (2020-04-01) -0.1263244  0.0686000 -1.841   0.0674 .  
#> LS (2020-05-01)  0.0672858  0.0683746  0.984   0.3265    
#> LS (2020-06-01) -0.0132324  0.0684061 -0.193   0.8469    
#> LS (2020-07-01)  0.1088670  0.0684040  1.592   0.1134    
#> LS (2020-08-01) -0.1185788  0.0685184 -1.731   0.0854 .  
#> LS (2020-09-01)  0.0434945  0.0679224  0.640   0.5228    
#> LS (2020-10-01) -0.0217233  0.0682748 -0.318   0.7508    
#> LS (2020-11-01)  0.0273831  0.0683750  0.400   0.6893    
#> LS (2020-12-01)  0.0317430  0.0686204  0.463   0.6443    
#> LS (2021-01-01) -0.0716395  0.0690694 -1.037   0.3012    
#> LS (2021-02-01) -0.0044989  0.0690584 -0.065   0.9481    
#> LS (2021-03-01)  0.0098894  0.0693131  0.143   0.8867    
#> LS (2021-04-01)  0.0248501  0.0691176  0.360   0.7197    
#> LS (2021-05-01) -0.0517386  0.0693224 -0.746   0.4565    
#> LS (2021-06-01) -0.0353851  0.0695798 -0.509   0.6118    
#> LS (2021-07-01) -0.0175290  0.0692027 -0.253   0.8004    
#> LS (2021-08-01)  0.0569751  0.0602051  0.946   0.3454    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> Number of observations: 201, Number of effective observations: 188, Number of parameters: 25
#> Loglikelihood: 290.6109, Adjusted loglikelihood: -564.8969
#> Standard error of the regression (ML estimate): 0.04928409 
#> AIC: 1179.794, AICc: 1187.819, BIC: 1260.705

k$mdl_nr            # index of selected model used to identify parameters
#> [1] 1
k$sa_mult[[k$mdl_nr]] # model to identify
#> Serie span: All 
#> 
#> Model: X-13
#> Log-transformation: yes 
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> SARIMA coefficients:
#>  theta(1) btheta(1) 
#>   -0.7411   -0.9998 
#> 
#> Regression model:
#>       r.arb_dag       r.skuddar LS (2009-01-01) LS (2016-01-01) LS (2020-03-01) 
#>         0.01097         0.05701        -0.08219         0.00000         0.00000 
#> LS (2020-04-01) LS (2020-05-01) LS (2020-06-01) LS (2020-07-01) LS (2020-08-01) 
#>         0.00000         0.00000         0.00000         0.00000         0.00000 
#> LS (2020-09-01) LS (2020-10-01) LS (2020-11-01) LS (2020-12-01) LS (2021-01-01) 
#>         0.00000         0.00000         0.00000         0.00000         0.00000 
#> LS (2021-02-01) LS (2021-03-01) LS (2021-04-01) LS (2021-05-01) LS (2021-06-01) 
#>         0.00000         0.00000         0.00000         0.00000         0.00000 
#> LS (2021-07-01) LS (2021-08-01) 
#>         0.00000         0.00000 
#> 
#>  Seasonal filter: FILTER_S3X9;  Trend filter: H-23 terms
#>  M-Statistics: q Good (0.675); q-m2 Good (0.728)
#>  QS test on SA: Good (1.000);  F-test on SA: Good (0.772)
#> 
#> For a more detailed output, use the 'summary()' function.
k$crit_tab          # Table of criteria
#>           crit1     crit2      crit3    m_aic
#> [1,] 0.04606964 0.2276114 -0.7410599 587.0624
#> [2,] 0.04408752 0.2001792 -0.7808637 587.6074
#> [3,] 0.04476747 0.5715118  0.0000000 585.6321
#> [4,] 0.04799657 0.1376824 -0.9814978 593.2904
#> [5,] 0.04284097 0.7464168 -0.4903478 585.3944


# Effect of identify_outliers (TRUE is default)
m1 <- x13_pickmdl(myseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
                  identification_end = c(2010, 2), identify_outliers = FALSE)
m2 <- x13_pickmdl(myseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
                  identification_end = c(2010, 2), identify_outliers = TRUE,
                  verbose = TRUE)
#> [1] "SARIMA model: (0,1,1) (0,1,1)"
m3 <- x13_pickmdl(myseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
                  identification_end = c(2018, 2), identify_outliers = TRUE,
                  verbose = TRUE)
#> Warning: No model is ok according to criteria
#> [1] "SARIMA model: (0,1,1) (0,1,1)"



# With corona outliers (even possible when series is not long enough)
m4 <- x13_pickmdl(myseries, spec_a, verbose = TRUE, corona = TRUE)
#> [1] "SARIMA model: (2,1,0) (0,1,1)"
summary(m4$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (2,1,0) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error T-stat Pr(>|t|)    
#> phi(1)     1.00349    0.06178 16.244  < 2e-16 ***
#> phi(2)     0.59143    0.06162  9.598  < 2e-16 ***
#> btheta(1) -0.99978    0.15924 -6.278 2.91e-09 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Regression model:
#>                 Estimate Std. Error T-stat Pr(>|t|)    
#> LS (2020-03-01)  0.07527    0.06491  1.160   0.2479    
#> LS (2020-04-01) -0.19815    0.09193 -2.155   0.0326 *  
#> LS (2020-05-01)  0.05206    0.09577  0.544   0.5875    
#> LS (2020-06-01)  0.02157    0.09648  0.224   0.8234    
#> LS (2020-07-01)  0.14629    0.10027  1.459   0.1465    
#> LS (2020-08-01) -0.22966    0.10240 -2.243   0.0263 *  
#> LS (2020-09-01)  0.15744    0.10248  1.536   0.1264    
#> LS (2020-10-01) -0.07074    0.10275 -0.689   0.4921    
#> LS (2020-11-01)  0.02439    0.10328  0.236   0.8136    
#> LS (2020-12-01)  0.09929    0.10344  0.960   0.3385    
#> LS (2021-01-01) -0.19862    0.10335 -1.922   0.0564 .  
#> LS (2021-02-01)  0.06578    0.10335  0.636   0.5254    
#> LS (2021-03-01)  0.06252    0.10335  0.605   0.5461    
#> LS (2021-04-01) -0.01084    0.10338 -0.105   0.9166    
#> LS (2021-05-01) -0.11020    0.10341 -1.066   0.2882    
#> LS (2021-06-01)  0.04380    0.10346  0.423   0.6726    
#> LS (2021-07-01) -0.04410    0.10342 -0.426   0.6704    
#> LS (2021-08-01) -0.03237    0.10342 -0.313   0.7547    
#> LS (2021-09-01)  0.18665    0.10341  1.805   0.0729 .  
#> TC (2011-06-01) -0.19161    0.04522 -4.237 3.76e-05 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> Number of observations: 201, Number of effective observations: 188, Number of parameters: 24
#> Loglikelihood: 248.2395, Adjusted loglikelihood: -607.2683
#> Standard error of the regression (ML estimate): 0.05883998 
#> AIC: 1262.537, AICc: 1269.899, BIC: 1340.211
m5 <- x13_pickmdl(myseries , rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
                  identification_end = c(2010, 2), identify_outliers = TRUE,
                  verbose = TRUE, corona = TRUE)
#> [1] "SARIMA model: (0,1,1) (0,1,1)"
summary(m5$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error  T-stat Pr(>|t|)    
#> theta(1)  -0.82011    0.03608 -22.732  < 2e-16 ***
#> btheta(1) -0.99957    0.15375  -6.501 9.17e-10 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Regression model:
#>                  Estimate Std. Error T-stat Pr(>|t|)   
#> AO (2008-03-01) -0.206843   0.063927 -3.236  0.00147 **
#> LS (2020-03-01)  0.019613   0.067053  0.293  0.77028   
#> LS (2020-04-01) -0.171621   0.086539 -1.983  0.04903 * 
#> LS (2020-05-01)  0.085242   0.086314  0.988  0.32483   
#> LS (2020-06-01) -0.009981   0.086388 -0.116  0.90816   
#> LS (2020-07-01)  0.159593   0.086321  1.849  0.06629 . 
#> LS (2020-08-01) -0.224664   0.086318 -2.603  0.01010 * 
#> LS (2020-09-01)  0.144138   0.086316  1.670  0.09686 . 
#> LS (2020-10-01) -0.061034   0.086315 -0.707  0.48051   
#> LS (2020-11-01)  0.021406   0.086315  0.248  0.80444   
#> LS (2020-12-01)  0.097483   0.086315  1.129  0.26039   
#> LS (2021-01-01) -0.193458   0.086247 -2.243  0.02624 * 
#> LS (2021-02-01)  0.062555   0.086146  0.726  0.46879   
#> LS (2021-03-01)  0.033979   0.086472  0.393  0.69487   
#> LS (2021-04-01)  0.017838   0.086539  0.206  0.83695   
#> LS (2021-05-01) -0.110351   0.086314 -1.278  0.20290   
#> LS (2021-06-01)  0.044435   0.086388  0.514  0.60769   
#> LS (2021-07-01) -0.043371   0.086321 -0.502  0.61604   
#> LS (2021-08-01) -0.033781   0.086318 -0.391  0.69604   
#> LS (2021-09-01)  0.187218   0.086316  2.169  0.03153 * 
#> TC (2011-06-01) -0.167211   0.053928 -3.101  0.00228 **
#> AO (2016-03-01) -0.192752   0.063927 -3.015  0.00298 **
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> Number of observations: 201, Number of effective observations: 188, Number of parameters: 25
#> Loglikelihood: 243.5223, Adjusted loglikelihood: -611.9856
#> Standard error of the regression (ML estimate): 0.06036874 
#> AIC: 1273.971, AICc: 1281.996, BIC: 1354.882


###########  quarterly series  #############

qseries <- pickmdl_data("qseries")

# Effect of identify_outliers (TRUE is default)
q1 <- x13_pickmdl(qseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value = 3),
                  identification_end = c(2010, 2), identify_outliers = FALSE)
q2 <- x13_pickmdl(qseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value = 3),
                  identification_end = c(2010, 2), identify_outliers = TRUE,
                  verbose = TRUE, output = "all")
#> [1] "SARIMA model: (0,1,1) (0,1,1)"
q3 <- x13_pickmdl(qseries, q2$spec, identification_end = c(2018, 2), identify_outliers = TRUE,
                  verbose = TRUE)
#> [1] "SARIMA model: (0,1,1) (0,1,1)"

# With corona outliers (even possible when series is not long enough)
q4 <- x13_pickmdl(qseries, spec_a, verbose = TRUE, corona = TRUE)
#> [1] "SARIMA model: (2,1,0) (0,1,1)"
summary(q4$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (2,1,0) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error T-stat Pr(>|t|)    
#> phi(1)      0.4350     0.1295  3.360  0.00148 ** 
#> phi(2)      0.3402     0.1337  2.544  0.01403 *  
#> btheta(1)  -1.0000     0.1973 -5.069 5.63e-06 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Regression model:
#>                 Estimate Std. Error T-stat Pr(>|t|)    
#> LS (2020-01-01) -0.03985    0.03822 -1.043 0.302139    
#> LS (2020-04-01) -0.02878    0.04161 -0.692 0.492397    
#> LS (2020-07-01) -0.07456    0.04206 -1.773 0.082343 .  
#> LS (2020-10-01)  0.08506    0.04278  1.988 0.052290 .  
#> LS (2021-01-01) -0.00062    0.04277 -0.014 0.988492    
#> LS (2021-04-01) -0.11516    0.04283 -2.689 0.009710 ** 
#> LS (2021-07-01)  0.04422    0.04289  1.031 0.307501    
#> LS (2008-07-01) -0.12536    0.03349 -3.744 0.000469 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> Number of observations: 67, Number of effective observations: 62, Number of parameters: 12
#> Loglikelihood: 116.804, Adjusted loglikelihood: -167.071
#> Standard error of the regression (ML estimate): 0.0334999 
#> AIC: 358.142, AICc: 364.5093, BIC: 383.6676

q5 <- x13_pickmdl(qseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value = 3),
                  identification_end = c(2010, 2), identify_outliers = TRUE,
                  verbose = TRUE, corona = TRUE)
#> [1] "SARIMA model: (0,1,1) (0,1,1)"
summary(q5$result$preprocessing)
#> Log-transformation: yes 
#> SARIMA model: (0,1,1) (0,1,1)
#> 
#> Coefficients
#>           Estimate Std. Error T-stat Pr(>|t|)    
#> theta(1)   -0.4089     0.1161 -3.523  0.00091 ***
#> btheta(1)  -0.8712     0.1331 -6.545 2.85e-08 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Regression model:
#>                   Estimate Std. Error T-stat Pr(>|t|)    
#> LS (2008-07-01) -0.1365364  0.0333403 -4.095 0.000154 ***
#> LS (2020-01-01) -0.0336395  0.0370763 -0.907 0.368598    
#> LS (2020-04-01) -0.0273303  0.0400882 -0.682 0.498541    
#> LS (2020-07-01) -0.0788231  0.0401121 -1.965 0.054974 .  
#> LS (2020-10-01)  0.0803140  0.0400311  2.006 0.050250 .  
#> LS (2021-01-01)  0.0005791  0.0403317  0.014 0.988601    
#> LS (2021-04-01) -0.1045488  0.0404172 -2.587 0.012646 *  
#> LS (2021-07-01)  0.0387242  0.0404409  0.958 0.342897    
#> AO (2014-04-01)  0.0874622  0.0303509  2.882 0.005814 ** 
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> Number of observations: 67, Number of effective observations: 62, Number of parameters: 12
#> Loglikelihood: 119.5754, Adjusted loglikelihood: -164.2996
#> Standard error of the regression (ML estimate): 0.03354065 
#> AIC: 352.5992, AICc: 358.9665, BIC: 378.1248

```
