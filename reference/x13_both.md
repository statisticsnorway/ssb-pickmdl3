# [`x13_spec`](https://rjdverse.github.io/rjd3x13/reference/x13_spec.html) and [`x13_pickmdl`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/x13_pickmdl.md) wrapped as a single function

Output is determined by the parameter `both_output`.

## Usage

``` r
x13_both(
  ts,
  spec = NULL,
  ...,
  context = NULL,
  userdefined = NULL,
  both_output = "main",
  corona = FALSE,
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

- ...:

  Specification setting on the form function\_\_parameter. See examples.

- context:

  Parameter to
  [`x13`](https://rjdverse.github.io/rjd3x13/reference/x13.html). List
  of external regressors (calendar or other) to be used for estimation.

- userdefined:

  Parameter to
  [`x13`](https://rjdverse.github.io/rjd3x13/reference/x13.html) (via
  `...` to `x13_pickmdl`).

- both_output:

  One of `"main"` (default, x13_pickmdl output), `"spec"` (spec output)
  or `"both"`.

- corona:

  Whether to update `spec` by outliers according to
  [`corona_outliers`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/corona_outliers.md).
  `FALSE` or `NULL` means no update. `TRUE` or `"ssb"` means update.

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
parameter `output` and `both_output`.

## Details

All parameters except `both_output` and `...` are parameters to
[`x13_pickmdl`](https://statisticsnorway.github.io/ssb-pickmdl3/reference/x13_pickmdl.md).

## Examples

``` r

myseries <- pickmdl_data("myseries")

a <- x13_both(myseries, spec = "rsa3", set_transform__fun = "Log", verbose = TRUE)
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class
summary(a)
#> Error: object 'a' not found

# is equivalent to

spec_a <- x13_spec("rsa3")
#> Error in .jcheck(): java.lang.UnsupportedClassVersionError: jdplus/x13/base/api/x13/X13Spec has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
spec_a <- rjd3toolkit::set_transform(spec_a, fun = "Log")
#> Error: object 'spec_a' not found
a2 <- x13_both(myseries,spec_a,verbose=TRUE)
#> Error: object 'spec_a' not found
a2
#> Error: object 'a2' not found

# several specification settings:

b <- x13_both(myseries, spec="rsa3",
  set_transform__fun = "None",
  set_easter__enable = TRUE,
  set_easter__duration = 3,
  set_easter__test = "None",
  set_outlier__outliers.type = c("LS","AO"),
  set_outlier__critical.value = 3
)
#> Error in .jcall("jdplus/x13/base/api/x13/X13Spec", "Ljdplus/x13/base/api/x13/X13Spec;",     "fromString", name): RcallMethod: cannot determine object class

# user defined regressors and modelling context



```
