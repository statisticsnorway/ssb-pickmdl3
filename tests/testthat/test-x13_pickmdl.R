

test_that("x13_pickmdl works ok", {
  myseries <- pickmdl_data("myseries")
  
  spec_c <- rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa5c"))
  
  q <- c(2, 3, 11, 45, 29, 11, 6, 4, 4, 2, 3, 9, 8, 3, 1, 2, 25, 19,
         11, 125, 6, 7, 10, 7, 31, 49, 28, 4, 5, 4, 3, 7, 18, 17, 33,
         1, 5, 3, 10, 43, 35, 21, 1, 0, 3, 2, 8, 15, 11, 4, 1, 3, 1, 1,
         4, 3, 6, 21, 20, 18, 58, 23, 18, 1, 2, 2, 2, 14, 18, 48, 10,
         1, 1, 9, 254, 319, 201, 14, 7, 3, 8, 3, 4, 2, 4, 11, 17, 9, 6,
         1, 2, 1, 3, 46, 90, 197, 160, 21, 11, 1, 5, 4, 24, 3, 15, 7,
         38, 24, 9, 11, 8, 5, 3, 52, 14, 25, 11, 3, 1, 1, 1, 1, 7, 13,
         135, 101, 163, 52, 35, 20, 8, 17, 13, 35, 9, 22, 10, 4, 1, 10,
         25, 29, 38, 17, 3, 0, 1, 3, 4, 13, 11, 25, 62, 16, 4, 4, 24,
         4, 3, 2, 6, 116, 46, 16, 1, 1, 4, 5, 8, 7, 8, 43, 99, 319, 10,
         3, 7, 7, 16, 8, 1, 1, 14, 18, 146, 122, 65, 84, 4, 2, 2, 2, 4,
         1, 1, 5, 13, 77, 30, 10, 4)
  
  d1 <- x13_pickmdl(myseries+ 0*q, spec_c, pickmdl_method = "first_automdl", when_finalnotok = warning, output = "all")
  d1b <- x13_pickmdl(myseries+ 0*q, spec_c, pickmdl_method = "first_automdl", when_finalnotok = warning, output = "all", fastfirst = FALSE)
  d2 <- x13_pickmdl(myseries*(1+ 0.35*q), spec_c, pickmdl_method = "first_automdl", when_finalnotok = warning)
  d3 <- x13_pickmdl(myseries*(1+ 0.25*q), spec_c, pickmdl_method = "first_automdl", when_finalnotok = warning, output = "all")
  d4 <- x13_pickmdl(myseries*(1+ 0.32*q), spec_c, pickmdl_method = "first_automdl", when_finalnotok = warning)
  expect_warning({d4b <-x13_pickmdl(myseries*(1+ 0.2*q), spec_c, pickmdl_method = "first_automdl", identify_arima_mu = FALSE)})
  expect_warning({d6 <- x13_pickmdl(myseries+(q)^3, spec_c, pickmdl_method = "first_tryautomdl", when_finalnotok = message)})
  
  
  expect_equal(gsub("SARIMA model: ","",capture.output(d1$sa$result$preprocessing$description$arima)[1]), "(0,1,2) (0,1,1)", ignore_attr = TRUE)
  expect_equal(gsub("SARIMA model: ","",capture.output(d2$result$preprocessing$description$arima)[1]), "(2,1,2) (0,1,1)", ignore_attr = TRUE)
  expect_equal(gsub("SARIMA model: ","",capture.output(d4$result$preprocessing$description$arima)[1]), "(2,1,2) (0,1,1)", ignore_attr = TRUE)
  expect_equal(gsub("SARIMA model: ","",capture.output(d6$result$preprocessing$description$arima)[1]), "(0,1,1) (0,1,1)", ignore_attr = TRUE)
  
  expect_equal(d1$mdl_nr, d1b$mdl_nr)
  expect_equal(nrow(d1b$crit_tab), 6)
  expect_equal(nrow(d1$crit_tab), 2)
  expect_equal(d1$crit_tab, d1b$crit_tab[1:2, ])
  expect_equal(d3$mdl_nr, 6)
  
})


test_that("x13_both and x13_text_frame", {
  fnames <- names(formals(x13_pickmdl))[!(names(formals(x13_pickmdl)) %in% c("spec", "..."))]
  expect_equal(formals(x13_pickmdl)[fnames], formals(x13_both)[fnames])
})

test_that("x13_both and x13_text_frame", {
  
  myseries <- pickmdl_data("myseries")
  seriesABC <- cbind(A = myseries, B = myseries + 10, C = myseries + 20)
  
  tf <- data.frame(name = c("A", "B", "C"), automdl.enabled = c("TRUE", "FALSE", "FALSE"),
                   add_outlier__date = c('c("2009-01-01", "2016-01-01")', 'c("2009-01-01")', NA),
                   add_outlier__type = c('rep("LS", 2)', '"AO"', NA))
  
  x13_both_old_method <- FALSE
  
  outABC <- x13_text_frame(tf, ts = "seriesABC", spec = "RSA3", set_transform__fun = "Log")
  outB   <- x13_text_frame(tf, ts = "seriesABC", spec = "RSA3", set_transform__fun = "Log",
                           id = "B")
  
  bothB <- x13_both(myseries + 10,
                    spec = "RSA3",
                    set_transform__fun = "Log",
                    add_outlier__date  = "2009-01-01",
                    add_outlier__type  = "AO")
  
  
  x13B <- x13_pickmdl(myseries + 10,
                      x13_spec("rsa3") |>
                        set_transform(fun = "Log") |>
                        add_outlier(date= "2009-01-01",type="AO"))
  
  x13_both_old_method <- TRUE
  
  
  outABC_old <- x13_text_frame(tf, ts = "seriesABC", spec = "rsa3", set_transform__fun = "Log")
  outB_old   <- x13_text_frame(tf, ts = "seriesABC", spec = "rsa3", set_transform__fun = "Log",
                               id = "B")
  
  expect_identical(x13B, outB)
  expect_identical(bothB, outB)
  expect_identical(outABC[[2]], outB)
  expect_identical(outABC_old, outABC)
  expect_identical(outB_old, outB)
  
})
