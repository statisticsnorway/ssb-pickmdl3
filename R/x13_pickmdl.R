
#' x13 with PICKMDL and partial concurrent possibilities
#'
#' \code{\link[rjd3x13]{x13}} can be run as usual (automdl) or with a PICKMDL specification.
#' The ARIMA model, outliers and filters can be identified at a certain date and then held fixed (with a new outlier-span).
#'
#' @param ts `x13` parameter
#' @param spec A "JD3_X13_SPEC" class object as generated with \code{\link[rjd3x13]{x13_spec}} or a list of several such objects as outputted from \code{\link{x13_spec_pickmdl}}.
#'             In the case of a single object and when `automdl.enabled` is `FALSE`, `spec` will be converted internally
#'             by `x13_spec_pickmdl` with default five arima model specifications.
#' @param corona Whether to update `spec` by outliers according to \code{\link{corona_outliers}}.
#'               `FALSE` or `NULL` means no update. `TRUE` or `"ssb"` means update.
#' @param ... Further `x13` parameters (currently only parameter `userdefined` is additional parameter to `x13`).
#' @param pickmdl_method \code{\link{crit_selection}} parameter
#'         or one of the two extra possibilities, `"first_automdl"` or `"first_tryautomdl"`.
#'         In both cases the `crit_selection` parameter is `"first"` and the automdl model is added as the last pickmdl model.
#' * **`"first_automdl"`:** The automdl model is chosen whenever no pickmdl model is ok.
#'                          In other words, the `star` parameter changes.
#' * **`"first_tryautomdl"`:** When no pickmdl model is ok:  The automdl model is chosen if this model is ok,
#'                          otherwise the `star` model is chosen.
#' @param star           \code{\link{crit_selection}} parameter
#' @param when_star      \code{\link{crit_selection}} parameter
#' @param when_automdl Function to be called when automdl since no pickmdl model ok. Supply NULL to do nothing.
#' @param when_finalnotok Function to be called, e.g. \code{\link{warning}}, when final run with final model is not ok. Supply NULL to do nothing.
#'                        See \code{\link{crit_ok}}.
#' @param identification_end To shorten the series before runs used to identify (arima) parameters.
#'            That is, the series is shortened by `window(ts,` `end = identification_end)`.
#' @param identification_estimate.to   To set \code{\link[rjd3toolkit]{set_estimate}} parameter `d1` before runs used to identify (arima) parameters.
#'            This is an alternative to  `identification_end`.
#' @param identify_t_filter When `TRUE`, Henderson trend filter is identified by the shortened (see above) series.
#' @param identify_s_filter When `TRUE`, Seasonal moving average filter is identified by the shortened series.
#' @param identify_outliers When `TRUE`, Outliers are identified by the shortened series.
#' @param identify_arima_mu When `TRUE`, `arima.mu` is identified by the shortened series (see \code{\link{arima_mu}}).
#' @param automdl.enabled Logical value or any other value.
#'   - When set to `FALSE` (the default), the pickmdl routine is applied.
#'   - When set to `TRUE`, the automdl routine is performed.
#'   - For any value other than `TRUE` or `FALSE`, the ARIMA model is chosen as specified by `spec`.
#'
#' Note that when `automdl.enabled` is not `FALSE`, if `spec` is a list containing several objects outputted from `x13_spec_pickmdl`, only the first object is used.
#' @param fastfirst When `TRUE` and when pickmdl with `crit_selection` parameter `"first"`,
#'                  only as many models as needed are run.
#'                  This affects the output when `output = "all"`.
#' @param verbose Printing information to console when `TRUE`.
#' @param output One of `"sa"` (default), `"spec"` (final spec), `"sa_spec"` (both) and `"all"`. See examples.
#' @param add_comment When `TRUE`, a  comment attribute
#'      (character vector with `ok`, `ok_final` and `mdl_nr`) will
#'      be added to the \code{\link[rjd3x13]{x13}} output object. Use \code{\link{comment}}
#'      to get the attribute or \code{\link{ok}} to get the attribute converted to a list.
#'
#' @return By default an `x13` output object, or otherwise a list as specified by parameter `output`.
#' @export
#' @importFrom stats window
#' @importFrom rjd3toolkit set_transform add_outlier set_outlier
#'
#' @examples
#' myseries <- pickmdl_data("myseries")
#'
#' spec_a  <- rjd3x13::x13_spec(name = "rsa3")
#' spec_a <- rjd3toolkit::set_transform(spec_a, fun = "Log")
#'
#' a <- x13_pickmdl(myseries, spec_a, verbose = TRUE)
#' comment(a)
#' ok(a)
#' unlist(ok(a))
#' summary(a$result$preprocessing)
#'
#' a2 <- x13_pickmdl(myseries, spec_a, identification_end = c(2014, 2))
#' summary(a2$result$preprocessing)
#'
#' # As above, another way
#' a3 <- x13_pickmdl(myseries, spec_a, identification_estimate.to = "2014-03-01")
#' summary(a3$result$preprocessing)
#'
#' a4 <- x13_automdl(myseries, spec_a, identification_end = c(2014, 2))
#' summary(a4$result$preprocessing)
#'
#' # As above, another way
#' a5 <- x13_automdl(myseries, spec_a, identification_estimate.to = "2014-03-01")
#' summary(a5$result$preprocessing)
#'
#'
#' allvar <- pickmdl_data("allvar")
#' allvar <- list(arb_dag=allvar[,1],skuddar=allvar[,2])
#' my_context <- modelling_context(variables=allvar)
#' spec_b <- rjd3x13::x13_spec(name= "rsa3")
#' spec_b <- rjd3toolkit::set_transform(spec_b,fun="Log")
#' spec_b <- rjd3toolkit::set_tradingdays(spec_b,
#'                        option="Userdefined",uservariable=c("r.arb_dag","r.skuddar"))
#' spec_b <- rjd3toolkit::set_outlier(spec_b,outliers.type=NULL)
#' spec_b <- rjd3toolkit::add_outlier(spec_b,type=rep("LS",20),
#'                            date = c("2009-01-01", "2016-01-01", "2020-03-01",
#'                                     "2020-04-01", "2020-05-01", "2020-06-01",
#'                                     "2020-07-01", "2020-08-01", "2020-09-01",
#'                                     "2020-10-01", "2020-11-01", "2020-12-01",
#'                                     "2021-01-01", "2021-02-01", "2021-03-01",
#'                                     "2021-04-01", "2021-05-01", "2021-06-01",
#'                                     "2021-07-01", "2021-08-01"))
#' b <- x13_pickmdl(myseries,spec_b, identification_end = c(2020, 2),context=my_context)
#' summary(b$result$preprocessing)
#'
#' # automdl instead
#' b1 <- x13_automdl(myseries, spec_b, identification_end = c(2020, 2),context=my_context)
#' summary(b1$result$preprocessing)
#'
#' # effect of identify_t_filter and identify_s_filter
#' set.seed(1)
#' rndseries <- ts(rep(1:12, 20) + (1 + (1:240)/20) * runif(240) + 0.5 * c(rep(1, 120), (1:120)^2),
#'                 frequency = 12, start = c(2000, 1))
#' spec_c <- rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"),outliers.type=NULL)
#' c1 <- x13_automdl(rndseries, spec_c, identification_end = c(2009, 12))
#' c1
#' c2 <- x13_automdl(rndseries, spec_c, identification_end = c(2009, 12), identify_t_filter = TRUE)
#' c2
#' c3 <- x13_automdl(rndseries, spec_c, identification_end = c(2009, 12), identify_t_filter = TRUE,
#'                   identify_s_filter = TRUE)
#' c3
#'
#'
#' # Warning when transform.function = "None"
#' spec_d  <- rjd3toolkit::set_transform(rjd3x13::x13_spec("rsa3"), fun = "None")
#' d <- x13_pickmdl(myseries, spec_d, verbose = TRUE)
#'
#' # Warning avoided (when_star) and 2nd (star) model selected
#' d2 <- x13_pickmdl(myseries, spec_d, star = 2, when_star = NULL, verbose = TRUE)
#'
#' # automdl since no pickmdl model ok, but still not ok
#' d3 <- x13_pickmdl(myseries, spec_d, pickmdl_method = "first_automdl", verbose = TRUE)
#'
#' # airline model (star) since automdl also not ok
#' d4 <- x13_pickmdl(myseries, spec_d, pickmdl_method = "first_tryautomdl", verbose = TRUE,
#'                   when_finalnotok = warning) # also finalnotok warning
#'
#' # As b, with output = "all"
#' k <- x13_pickmdl(myseries, spec_b, identification_end = c(2014, 2), context = my_context,
#'                  output = "all", fastfirst = FALSE) # With TRUE only one model in this case
#' summary(k$sa$result$preprocessing)  # As summary(b$result$preprocessing)
#'
#' k$mdl_nr            # index of selected model used to identify parameters
#' k$sa_mult[[k$mdl_nr]] # model to identify
#' k$crit_tab          # Table of criteria
#'
#'
#' # Effect of identify_outliers (TRUE is default)
#' m1 <- x13_pickmdl(myseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
#'                   identification_end = c(2010, 2), identify_outliers = FALSE)
#' m2 <- x13_pickmdl(myseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
#'                   identification_end = c(2010, 2), identify_outliers = TRUE,
#'                   verbose = TRUE)
#' m3 <- x13_pickmdl(myseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
#'                   identification_end = c(2018, 2), identify_outliers = TRUE,
#'                   verbose = TRUE)
#'
#'
#'
#' # With corona outliers (even possible when series is not long enough)
#' m4 <- x13_pickmdl(myseries, spec_a, verbose = TRUE, corona = TRUE)
#' summary(m4$result$preprocessing)
#' m5 <- x13_pickmdl(myseries , rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value= 3),
#'                   identification_end = c(2010, 2), identify_outliers = TRUE,
#'                   verbose = TRUE, corona = TRUE)
#' summary(m5$result$preprocessing)
#'
#'
#' ###########  quarterly series  #############
#'
#' qseries <- pickmdl_data("qseries")
#'
#' # Effect of identify_outliers (TRUE is default)
#' q1 <- x13_pickmdl(qseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value = 3),
#'                   identification_end = c(2010, 2), identify_outliers = FALSE)
#' q2 <- x13_pickmdl(qseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value = 3),
#'                   identification_end = c(2010, 2), identify_outliers = TRUE,
#'                   verbose = TRUE, output = "all")
#' q3 <- x13_pickmdl(qseries, q2$spec, identification_end = c(2018, 2), identify_outliers = TRUE,
#'                   verbose = TRUE)
#'
#' # With corona outliers (even possible when series is not long enough)
#' q4 <- x13_pickmdl(qseries, spec_a, verbose = TRUE, corona = TRUE)
#' summary(q4$result$preprocessing)
#'
#' q5 <- x13_pickmdl(qseries, rjd3toolkit::set_outlier(rjd3x13::x13_spec("rsa3"), critical.value = 3),
#'                   identification_end = c(2010, 2), identify_outliers = TRUE,
#'                   verbose = TRUE, corona = TRUE)
#' summary(q5$result$preprocessing)
#'
#'

x13_pickmdl <- function(ts, spec,
                        corona = FALSE, ...,
                        pickmdl_method = "first", star = 1,
                        when_star = warning,
                        when_automdl = message,
                        when_finalnotok = NULL,
                        identification_end = NULL, identification_estimate.to = NULL,
                        identify_t_filter = FALSE, identify_s_filter = FALSE,
                        identify_outliers = TRUE,
                        identify_arima_mu = TRUE,
                        automdl.enabled = FALSE,
                        fastfirst = TRUE,
                        verbose = FALSE,
                        output = "sa",
                        add_comment = TRUE) {
  
  if (is.logical(corona)) {
    if (corona) {
      corona <- "ssb"
    } else {
      corona <- NULL
    }
  }
  
  if(!(output %in% c("sa", "spec", "sa_spec", "all")))
    stop('Allowed values of parameter output are "sa", "spec", "sa_spec" and "all".')
  
  
  # specify_automdl.enabled is new functionality.
  # Note: After this, the parameter name automdl.enabled can be perceived as misleading
  specify_automdl.enabled <- isTRUE(automdl.enabled)
  automdl.enabled <- !isFALSE(automdl.enabled)
  
  auto_in_pickmdl <- FALSE
  
  ## lager liste med spec. Oversatt til rjd3.
  
  if (!all(sapply(spec, class) == "JD3_X13_SPEC")) {
    if (!all(class(spec) == "JD3_X13_SPEC")){
      stop("Wrong `spec` input")
    }
    if (automdl.enabled) {
      spec <- list(spec)
    } else {
      if(pickmdl_method %in% c("first_automdl", "first_tryautomdl")){
        spec <- c(x13_spec_pickmdl(spec), list(spec))
        spec[[length(spec)]] <- rjd3toolkit::set_automodel(spec[[length(spec)]],enabled = TRUE)
        if(pickmdl_method=="first_automdl"){
          star <- length(spec)
        }
        auto_in_pickmdl <- TRUE
        pickmdl_method <- "first"
      } else {
        spec <- x13_spec_pickmdl(spec)
      }
    }
  }
  
  if (!is.null(corona)) {
    end_ts <- stats::end(stats::ts(1:2, start = stats::end(stats::window(ts, end = identification_end)), frequency = stats::frequency(ts)))
    end_ts_final <- stats::end(stats::ts(1:2, start = stats::end(ts), frequency = stats::frequency(ts)))
    if (stats::frequency(ts) == 4) {
      end_ts[2] <- 1 + (end_ts[2] - 1) * 3
      end_ts_final[2] <- 1 + (end_ts_final[2] - 1) * 3
    }
    outlier_date_limit <- paste(end_ts[1], Number(end_ts[2], 2), "01", sep = "-")
    outlier_date_limit_final <- paste(end_ts_final[1], Number(end_ts_final[2], 2), "01", sep = "-")
    if (!is.null(identification_estimate.to)) {
      
      yr <- as.numeric(substr(identification_estimate.to, 1, 4))
      mnth <- as.numeric(substr(identification_estimate.to, 6, 7))  
      end_ts <- stats::end(stats::ts(1:2, start = c(yr,mnth), frequency = stats::frequency(ts)))
      outlier_date_limit <- paste(end_ts[1], Number(end_ts[2], 2), "01", sep = "-")
      
      #outlier_date_limit <- identification_estimate.to
      #DANGER! outlier_date_limit <- seq(as.Date(outlier_date_limit), by = "month", length = 2)[2] 
      #Derfor jeg har fikset det i traad med Oyvinds. 
    }
  }
  
  
  if (!is.null(corona)) {  # Because of possible error (bug) only include outliers within estimation span
    for (i in seq_along(spec)) {
      spec[[i]] <- update_spec_corona_outliers(spec[[i]], option = corona, outlier_date_limit = outlier_date_limit, freq = stats::frequency(ts))
    }
  }
  
  if (automdl.enabled) {
    spec <- spec[1]
    if (specify_automdl.enabled) {
      spec[[1]] <- rjd3toolkit::set_automodel(spec[[1]], enabled = TRUE)
    }
  }
  
  
  
  if (fastfirst) {
    fastfirst <- !automdl.enabled & pickmdl_method == "first"
  }
  
  if (fastfirst) {
    sa_mult <- NULL
    crit_tab <- NULL
    ok_loop <- FALSE
    ok <- TRUE
    i <- 0
    when_star_here <- NULL
    while (!ok_loop) {
      i <- i + 1
      
      # almost same code as below (spec -> spec[i])
      if (is.null(identification_estimate.to)) {
        sa_mult <- c(sa_mult, x13_multi(ts = stats::window(ts, end = identification_end), spec = spec[i], ...))
      } else {
        sa_mult <- c(sa_mult, x13_multi(ts = stats::window(ts, end = identification_end),
                                        #spec = lapply(spec[i], x13_spec, estimate.to = identification_estimate.to), ...))
                                        spec =  lapply(spec[i], rjd3toolkit::set_estimate, type="To",d1=identification_estimate.to), ...))
      }
      crit_tab_i <- crit_table(sa_mult[i])
      if (i == length(spec)) {
        when_star_here <- when_star
      }
      ok_loop <- as.logical(crit_selection(crit_tab_i, star = 0, when_star = when_star_here))
      crit_tab <- rbind(crit_tab, crit_tab_i)
      if (ok_loop) {
        mdl_nr <- i
      }
      if (!ok_loop & i == length(spec)) {
        mdl_nr <- star
        ok_loop <- TRUE
        ok <- FALSE
      }
    }
  } else {
    if (is.null(identification_estimate.to)) {
      sa_mult <- x13_multi(ts = stats::window(ts, end = identification_end), spec = spec, ...)
    } else {
      sa_mult <- x13_multi(ts = stats::window(ts, end = identification_end),
                           spec = lapply(spec, rjd3toolkit::set_estimate, type="To",d1=identification_estimate.to), ...)
      
    }
    
    if (automdl.enabled) {
      crit_tab <- NULL
      mdl_nr <- 1L
      ok <- crit_ok(sa_mult[[mdl_nr]])
    } else {
      crit_tab <- crit_table(sa_mult)
      mdl_nr <- crit_selection(crit_tab, pickmdl_method = pickmdl_method, star = star, when_star = when_star)
      if (!mdl_nr) {
        mdl_nr <- star
        ok <- FALSE
      } else {
        ok <- TRUE
      }
    }
  }
  
  
  
  if(verbose){
    print(utils::capture.output(sa_mult[[mdl_nr]]$result$preprocessing$description$arima)[1])
  }
  
  length_spec <- length(spec)
  #spec <- spec[[mdl_nr]]
  ref_spec <- spec[[mdl_nr]]
  #ref_spec <- sa_mult[[mdl_nr]]$estimation_spec
  spec_to_refresh <- sa_mult[[mdl_nr]]$result_spec
  if(!is.null(identification_estimate.to)){
    spec_to_refresh$regarima$estimate$span <- ref_spec$regarima$estimate$span
  }
  #### Her maa det faas inn at estimate_to i disse skal være lik inngangsspec. (foer sa_mult) Kan ikke bare sette all, da estimate.to kan være definert 
  ### paa ordinært vis. Saa maa ta utgangspunkt i spec-listen. # Done 
  
  if(automdl.enabled | (auto_in_pickmdl & mdl_nr == length_spec)){
    if(!automdl.enabled){
      if(!is.null(when_automdl)){
        when_automdl("automdl since no pickmdl model ok")
      }
    }
    #arma <- sa_mult[[mdl_nr]]$result$preprocessing$description$arima
    #spec <- rjd3toolkit::set_arima(rjd3toolkit::set_automodel(spec,enabled = automdl.enabled),
    #                               p = as.numeric(ifelse(is.matrix(arma$phi),ncol(arma$phi),0)),
    #                               d = as.numeric(arma$d),
    #                               q =  as.numeric(ifelse(is.matrix(arma$theta),ncol(arma$theta),0)),
    #                               bp = as.numeric(ifelse(is.matrix(arma$bphi),ncol(arma$bphi),0)),
    #                               bd = as.numeric(arma$bd),
    #                               bq = as.numeric(ifelse(is.matrix(arma$btheta),ncol(arma$btheta),0)))
  }
  
  #if (identify_arima_mu) {
  #  if(arima_mu(sa_mult[[mdl_nr]])){
  #    spec <- rjd3toolkit::set_arima(spec,mean=0,mean.type="Initial")
  #  }else{
  #    spec <- rjd3toolkit::set_arima(spec,mean=NA)
  #  }
  #}
  
  #if (identify_t_filter | identify_s_filter) {
  #  filters <- filter_input(sa_mult[[mdl_nr]])
  #  if (identify_t_filter) {
  #    spec <- rjd3x13::set_x11(spec,henderson.filter = filters[["henderson.filter"]])
  #  }
  #  if (identify_s_filter) {
  #    spec <- rjd3x13::set_x11(spec,seasonal.filter = filters[["seasonal.filter"]])
  #  }
  #  if (verbose) {
  #    print(unlist(filters)[c(identify_t_filter, identify_s_filter)], quote = FALSE)
  #  }
  #}
  
  
  if (!is.null(corona)) { # Because of new final limit possible extra outliers included
    ref_spec <- update_spec_corona_outliers(ref_spec, option = corona, outlier_date_limit = outlier_date_limit_final, freq = stats::frequency(ts))   # spec eller spec_refresh?
    spec_to_refresh <- update_spec_corona_outliers(spec_to_refresh, option = corona, outlier_date_limit = outlier_date_limit_final, freq = stats::frequency(ts))   # spec eller spec_refresh?
  }
  
  if(!is.null(identification_end) | !is.null(identification_estimate.to)){  ## Holder dette? Nei, hvis identify_outliers ikke er på skal hele identifiseres på nytt... 
    ### få inn noe med if policy = outliers og identify outliers e.l.
    if(isTRUE(identify_outliers) | policy == "Current"){
      spec <- rjd3x13::x13_refresh(spec=spec_to_refresh,refspec = ref_spec, policy = policy, period=stats::frequency(ts),start = outlier_date_limit, end = end(ts))  
    }else{
      spec <- rjd3x13::x13_refresh(spec=spec_to_refresh,refspec = ref_spec, policy = policy, period=stats::frequency(ts),start = start(ts), end = end(ts))  
    }
    
  }else {
    spec <- ref_spec
  }
  
  
  
  #if (identify_outliers) {
  #  spec <- update_spec_outliers(sa = sa_mult[[mdl_nr]], spec = spec, verbose = verbose)
  #}
  
  if(output == "spec"){
    return(spec)
    
  }
  
  sa <- rjd3x13::x13(ts = ts, spec = spec, ...)
  
  # Include possibility to check differences.
  # Seen that !isTRUE(all_equal) happen as result of specified outlier at end of series.
  # End outlier not included in first model, but included after outlier.from updated.
  if (is.null(identification_end) & is.null(identification_estimate.to)) {
    if (get0("check_all.equal", ifnotfound = FALSE)) {
      all_equal <- all.equal(sa$final$series, sa_mult[[mdl_nr]]$final$series)
      if (isTRUE(all_equal))
        message(all_equal) else warning(all_equal)
    }
  }   ### Denne maa fikses paa ! Hva er dette? 
  
  
  
  ok_final <- crit_ok(sa)
  
  if (!is.null(when_finalnotok)) {
    if (!ok_final) {
      when_finalnotok("FINAL RUN NOT OK")
    }
  }
  
  if (add_comment) {
    comment(sa) <- c(ok = as.character(ok),
                     ok_final = as.character(ok_final),
                     mdl_nr = as.character(mdl_nr * c(1, NA)[automdl.enabled + 1]))
  }
  
  if(output == "sa_spec"){                                       #### Trengs denne ? 
    return(list(sa = sa, spec = spec))
  }
  
  if(output == "all"){
    return(list(sa = sa, spec = spec, mdl_nr = mdl_nr, crit_tab = crit_tab, sa_mult = sa_mult))
  }
  
  sa
}

#' @rdname x13_pickmdl
#' @export
x13_automdl <- function(..., automdl.enabled = TRUE){
  x13_pickmdl(..., automdl.enabled = automdl.enabled)
}
