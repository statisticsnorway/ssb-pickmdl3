# R package pickmdl3

| [Not yet on CRAN](https://cran.r-project.org/) |  | [pkgdown website](https://statisticsnorway.github.io/ssb-pickmdl3/) |  | [GitHub Repository](https://github.com/statisticsnorway/ssb-pickmdl3) |
|----|----|----|----|----|

------------------------------------------------------------------------

## R package implementing the X-12-ARIMA pickmdl procedure within rjd3

This package makes the pickdml model selection procedure in X-12-ARIMA
available for seasonal adjustment with rjd3. The package relies on
[rjd3toolkit](https://CRAN.R-project.org/package=rjd3toolkit) and
[rjd3x13](https://CRAN.R-project.org/package=rjd3x13), and enables the
x13 function in rjd3x13 to be run with the pickmdl specification as an
alternative to the default automodel specification. The pickmdl
selection procedure differs from the default automodel procedure, in
that the choiche of seasonal RegARIMA model is restricted to an ordered
set of five parsimonius models. In the case when none of these are
adeaquate, the package provides the option to fall back on the
automdodel procedure. The package further includes functionality for
seasonal adjustment of multiple series based on a data frame with model
specifications.

------------------------------------------------------------------------

📌 See the [broader list of available
functions](https://statisticsnorway.github.io/ssb-pickmdl3/reference/index.html).

------------------------------------------------------------------------

See the package vignettes:

[What is
pickmdl?](https://statisticsnorway.github.io/ssb-pickmdl3/articles/introduction.html),
[Basic
functionality](https://statisticsnorway.github.io/ssb-pickmdl3/articles/basic_funcitons.html),
[Alternatives when no model is
acceptable](https://statisticsnorway.github.io/ssb-pickmdl3/articles/pickmdl_method.html),
[Partial concurrent
adjustment](https://statisticsnorway.github.io/ssb-pickmdl3/articles/refresh_and_freeze.html),
[Multivariate time
series](https://statisticsnorway.github.io/ssb-pickmdl3/articles/multiple_series.html).

------------------------------------------------------------------------

## Installation

Since *pickmdl3* depends on *rjd3toolkit* and *rjd3x13*, refer to the
installation instruction found on the  
[rjdverse](https://github.com/rjdverse) GitHub page. See also the
chapter on R packages in the [Jdemetra+
documentation](https://doc.jdemetra.org/t-r-packages).

Usual installation from GitHub:

``` r

# install.packages("devtools")
devtools::install_github("statisticsnorway/ssb-pickmdl3")
```

If you know that the dependencies listed under *Imports* and *Depends*
in the [DESCRIPTION
file](https://github.com/statisticsnorway/ssb-pickmdl/blob/main/DESCRIPTION)
are already installed, an alternative is:

``` r

devtools::install_github("statisticsnorway/pickmdl3", dependencies = FALSE)
```

- 

  ------------------------------------------------------------------------
