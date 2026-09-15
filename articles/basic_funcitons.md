# basic_funcitons

## Introduction

The pickdml3 package contains functionality for running the pickdml
selection procedure when using the x13 methodology in rjd3. In this
vignette we explore the basic functionality within the package.

We begin by loading a time series to be seasonally adjusted. This is
Norwegian retail indices. 47.6.

``` r

#rti_476 <- pickmdl3::pickmdl_data("norwegian_rti")$rti_476
rti_476 <- pickmdl3::pickmdl_data("myseries")

rti_476
```

    ##        Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov   Dec
    ## 2005  78.5  68.2  76.6  80.0  73.4  91.9  45.5  78.1  88.8  79.3  94.1  76.4
    ## 2006  90.5  73.1  84.0  76.7  86.3  80.9  49.3  86.8  88.8  90.3  91.4  68.7
    ## 2007  94.0  72.2  92.6  77.9  83.5  97.7  56.0  93.2  98.0 103.8 103.6  73.4
    ## 2008 101.6  85.6  72.5  94.1  85.1  91.7  53.3  92.8 107.6  95.9  89.7  78.0
    ## 2009  90.7  74.8  85.8  75.4  76.7  91.0  52.9  83.6  88.5  88.4  86.6  76.8
    ## 2010  80.7  69.3  83.1  72.9  69.8  92.8  51.5  82.4  98.9  91.0  89.1  71.6
    ## 2011  89.3  70.3  83.9  77.0  86.3  78.1  46.8  87.3  96.7  90.8  96.7  85.2
    ## 2012  95.8  84.9  93.8  81.1  89.2  99.9  59.4  98.5  97.3 101.1 109.0  70.6
    ## 2013 112.3  90.9  80.7  95.8  88.6  97.5  62.9  95.8 103.6 112.4 104.4  77.7
    ## 2014 107.1  92.5  93.1  96.1  94.3 100.6  69.5  98.3 119.1 112.5 101.3  87.5
    ## 2015 105.0  85.8  99.2  94.4  99.2 110.8  69.0  98.3 116.0 110.2 116.3  99.1
    ## 2016  99.1  96.0  86.3 109.5  92.1 118.0  73.5 102.6 125.6 112.1 117.6 100.9
    ## 2017 106.6  96.5 112.8  89.5 115.0 110.7  69.6 118.0 125.6 120.4 130.4 100.9
    ## 2018 120.8 101.9 107.5 108.1 111.1 116.4  69.6 133.0 122.6 136.0 139.2  99.0
    ## 2019 126.7 110.8 119.4 106.6 117.1 123.2  80.7 114.9 134.3 140.2 136.1 106.1
    ## 2020 120.6 112.4 123.6  98.7 109.9 121.1  85.2 109.8 139.5 128.5 133.0 116.2
    ## 2021 116.0 105.2 120.4 116.2 106.4 123.8  71.1 110.9 147.1

To seasonally adjust the series with the pickdml selection algorithm, we
use the x13_pickmdl() function. This function seasonally adjust the
series in accordance with the x13 function, but instead of using the
default automodel procedure, the choiche of models is restricted to a
list of five robust models.

We select the versatile rsa5c standard specification, where there is a
test to check if each trading day should have its own effect. In
accordance with recomondations at Statistics Norway, we only allow for
Level Shift an additive outliers, however. The x13_pickmdl takes the
series and the specification as input and gives a list of model results
as output, just as the x13 function.

``` r

library(pickmdl3)
```

    ## Loading required package: rjd3toolkit

    ## 
    ## Attaching package: 'rjd3toolkit'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     aggregate, mad

    ## Loading required package: rjd3x13

    ## 
    ## Attaching package: 'rjd3x13'

    ## The following object is masked from 'package:grDevices':
    ## 
    ##     x11

``` r

spec_now <- x13_spec("rsa5c") |>
  set_transform(fun="Log")|>
  set_outlier(outliers.type=c("AO","LS")) 


model_476 <- pickmdl3::x13_pickmdl(ts = rti_476,spec=spec_now)

model_476
```

    ## Serie span: All 
    ## 
    ## Model: X-13
    ## Log-transformation: yes 
    ## SARIMA model: (2,1,2) (0,1,1)
    ## 
    ## SARIMA coefficients:
    ##    phi(1)    phi(2)  theta(1)  theta(2) btheta(1) 
    ##    1.0094    0.1968    0.2142   -0.6712   -0.8581 
    ## 
    ## Regression model:
    ##       mon       tue       wed       thu       fri       sat    easter 
    ## -0.002391  0.016866  0.013407  0.005757  0.019463 -0.021588 -0.127922 
    ## 
    ##  Seasonal filter: FILTER_S3X9;  Trend filter: H-23 terms
    ##  M-Statistics: q Good (0.809); q-m2 Good (0.875)
    ##  QS test on SA: Good (1.000);  F-test on SA: Good (0.520)
    ## 
    ## For a more detailed output, use the 'summary()' function.

To get information on the model choiche. Use the function ok(). We see
that the selected model is deemed ok, that is it fulfills the tree
criteria. The model number is three.

``` r

pickmdl3::ok(model_476)  
```

    ## $ok
    ## [1] TRUE
    ## 
    ## $ok_final
    ## [1] TRUE
    ## 
    ## $mdl_nr
    ## [1] 5
