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
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
spec_a <- rjd3toolkit::set_transform(spec_a, fun = "Log")
#> Error: object 'spec_a' not found

a <- x13_pickmdl(myseries, spec_a, verbose = TRUE)
#> Error: object 'spec_a' not found
comment(a)
#> Error: object 'a' not found
ok(a)
#> Error: object 'a' not found
unlist(ok(a))
#> Error: object 'a' not found
summary(a$result$preprocessing)
#> Error: object 'a' not found

a2 <- x13_pickmdl(myseries, spec_a, identification_end = c(2014, 2))
#> Error: object 'spec_a' not found
summary(a2$result$preprocessing)
#> Error: object 'a2' not found

# As above, another way
a3 <- x13_pickmdl(myseries, spec_a, identification_estimate.to = "2014-03-01")
#> Error: object 'spec_a' not found
summary(a3$result$preprocessing)
#> Error: object 'a3' not found

a4 <- x13_automdl(myseries, spec_a, identification_end = c(2014, 2))
#> Error: object 'spec_a' not found
summary(a4$result$preprocessing)
#> Error: object 'a4' not found

# As above, another way
a5 <- x13_automdl(myseries, spec_a, identification_estimate.to = "2014-03-01")
#> Error: object 'spec_a' not found
summary(a5$result$preprocessing)
#> Error: object 'a5' not found


allvar <- pickmdl_data("allvar")
allvar <- list(arb_dag=allvar[,1],skuddar=allvar[,2])
my_context <- modelling_context(variables=allvar)
spec_b <- rjd3x13::x13_spec(name= "rsa3")
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
spec_b <- rjd3toolkit::set_transform(spec_b,fun="Log")
#> Error: object 'spec_b' not found
spec_b <- rjd3toolkit::set_tradingdays(spec_b,
                       option="Userdefined",uservariable=c("r.arb_dag","r.skuddar"))
#> Error: object 'spec_b' not found
spec_b <- rjd3toolkit::set_outlier(spec_b,outliers.type=NULL)
#> Error: object 'spec_b' not found
spec_b <- rjd3toolkit::add_outlier(spec_b,type=rep("LS",20),
                           date = c("2009-01-01", "2016-01-01", "2020-03-01",
                                    "2020-04-01", "2020-05-01", "2020-06-01",
                                    "2020-07-01", "2020-08-01", "2020-09-01",
                                    "2020-10-01", "2020-11-01", "2020-12-01",
                                    "2021-01-01", "2021-02-01", "2021-03-01",
                                    "2021-04-01", "2021-05-01", "2021-06-01",
                                    "2021-07-01", "2021-08-01"))
#> Error: object 'spec_b' not found
b <- x13_pickmdl(myseries,spec_b, identification_end = c(2020, 2),context=my_context)
#> Error: object 'spec_b' not found
summary(b$result$preprocessing)
#> Error: object 'b' not found

# automdl instead
b1 <- x13_automdl(myseries, spec_b, identification_end = c(2020, 2),context=my_context)
#> Error: object 'spec_b' not found
summary(b1$result$preprocessing)
#> Error: object 'b1' not found

# effect of identify_t_filter and identify_s_filter
set.seed(1)
rndseries <- ts(rep(1:12, 20) + (1 + (1:240)/20) * runif(240) + 0.5 * c(rep(1, 120), (1:120)^2),
                frequency = 12, start = c(2000, 1))
spec_c <- rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"),outliers.type=NULL)
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
c1 <- x13_automdl(rndseries, spec_c, identification_end = c(2009, 12))
#> Error: object 'spec_c' not found
c1
#> Error: object 'c1' not found
c2 <- x13_automdl(rndseries, spec_c, identification_end = c(2009, 12), identify_t_filter = TRUE)
#> Error: object 'spec_c' not found
c2
#> Error: object 'c2' not found
c3 <- x13_automdl(rndseries, spec_c, identification_end = c(2009, 12), identify_t_filter = TRUE,
                  identify_s_filter = TRUE)
#> Error: object 'spec_c' not found
c3
#> Error: object 'c3' not found


# Warning when transform.function = "None"
spec_d  <- rjd3toolkit::set_transform(rjd3x13::x13_spec("rsa3"), fun = "None")
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
d <- x13_pickmdl(myseries, spec_d, verbose = TRUE)
#> Error: object 'spec_d' not found

# Warning avoided (when_star) and 2nd (star) model selected
d2 <- x13_pickmdl(myseries, spec_d, star = 2, when_star = NULL, verbose = TRUE)
#> Error: object 'spec_d' not found

# automdl since no pickmdl model ok, but still not ok
d3 <- x13_pickmdl(myseries, spec_d, pickmdl_method = "first_automdl", verbose = TRUE)
#> Error: object 'spec_d' not found

# airline model (star) since automdl also not ok
d4 <- x13_pickmdl(myseries, spec_d, pickmdl_method = "first_tryautomdl", verbose = TRUE,
                  when_finalnotok = warning) # also finalnotok warning
#> Error: object 'spec_d' not found

# As b, with output = "all"
k <- x13_pickmdl(myseries, spec_b, identification_end = c(2014, 2), context = my_context,
                 output = "all", fastfirst = FALSE) # With TRUE only one model in this case
#> Error: object 'spec_b' not found
summary(k$sa$result$preprocessing)  # As summary(b$result$preprocessing)
#> Error: object 'k' not found

k$mdl_nr            # index of selected model used to identify parameters
#> Error: object 'k' not found
k$sa_mult[[k$mdl_nr]] # model to identify
#> Error: object 'k' not found
k$crit_tab          # Table of criteria
#> Error: object 'k' not found


# Effect of identify_outliers (TRUE is default)
m1 <- x13_pickmdl(myseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
                  identification_end = c(2010, 2), identify_outliers = FALSE)
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
m2 <- x13_pickmdl(myseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
                  identification_end = c(2010, 2), identify_outliers = TRUE,
                  verbose = TRUE)
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
m3 <- x13_pickmdl(myseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
                  identification_end = c(2018, 2), identify_outliers = TRUE,
                  verbose = TRUE)
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class



# With corona outliers (even possible when series is not long enough)
m4 <- x13_pickmdl(myseries, spec_a, verbose = TRUE, corona = TRUE)
#> Error: object 'spec_a' not found
summary(m4$result$preprocessing)
#> Error: object 'm4' not found
m5 <- x13_pickmdl(myseries , rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
                  identification_end = c(2010, 2), identify_outliers = TRUE,
                  verbose = TRUE, corona = TRUE)
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
summary(m5$result$preprocessing)
#> Error: object 'm5' not found


###########  quarterly series  #############

qseries <- pickmdl_data("qseries")

# Effect of identify_outliers (TRUE is default)
q1 <- x13_pickmdl(qseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value = 3),
                  identification_end = c(2010, 2), identify_outliers = FALSE)
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
q2 <- x13_pickmdl(qseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value = 3),
                  identification_end = c(2010, 2), identify_outliers = TRUE,
                  verbose = TRUE, output = "all")
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
q3 <- x13_pickmdl(qseries, q2$spec, identification_end = c(2018, 2), identify_outliers = TRUE,
                  verbose = TRUE)
#> Error: object 'q2' not found

# With corona outliers (even possible when series is not long enough)
q4 <- x13_pickmdl(qseries, spec_a, verbose = TRUE, corona = TRUE)
#> Error: object 'spec_a' not found
summary(q4$result$preprocessing)
#> Error: object 'q4' not found

q5 <- x13_pickmdl(qseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value = 3),
                  identification_end = c(2010, 2), identify_outliers = TRUE,
                  verbose = TRUE, corona = TRUE)
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
summary(q5$result$preprocessing)
#> Error: object 'q5' not found

```
