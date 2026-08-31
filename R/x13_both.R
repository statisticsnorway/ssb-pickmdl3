
#' \code{\link[rjd3x13]{x13_spec}}  and \code{\link{x13_pickmdl}} wrapped as a single function
#'
#' Output is determined by the parameter `both_output`.
#'
#' All parameters except `both_output` and `...` are parameters to \code{\link{x13_pickmdl}}.
#'
#' @inheritParams x13_pickmdl
#' @param ...  Specification setting on the form function__parameter. See examples.
#' @param context Parameter to \code{\link[rjd3x13]{x13}}. List of external regressors (calendar or other) to be used for estimation.
#' @param userdefined  Parameter to \code{\link[rjd3x13]{x13}}  (via `...`  to `x13_pickmdl`).
#' @param both_output One of `"main"` (default, x13_pickmdl output), `"spec"` (spec output) or `"both"`.
#'
#' @return By default an `x13` output object, or otherwise a list as specified by parameter `output` and `both_output`.
#' @export
#'
#' @examples
#'
#' myseries <- pickmdl_data("myseries")
#'
#' a <- x13_both(myseries, spec = "rsa3", set_transform__fun = "Log", verbose = TRUE)
#' summary(a)
#'
#' # is equivalent to
#'
#' spec_a <- x13_spec("rsa3")
#' spec_a <- rjd3toolkit::set_transform(spec_a, fun = "Log")
#' a2 <- x13_both(myseries,spec_a,verbose=TRUE)
#' a2
#'
#' # several specification settings:
#'
#' b <- x13_both(myseries, spec="rsa3",
#'   set_transform__fun = "None",
#'   set_easter__enable = TRUE,
#'   set_easter__duration = 3,
#'   set_easter__test = "None",
#'   set_outlier__outliers.type = c("LS","AO"),
#'   set_outlier__critical.value = 3
#' )
#'
#' # user defined regressors and modelling context
#'
#'
#'
#'
x13_both <- function(ts,spec = NULL,  ..., context= NULL,userdefined = NULL, both_output = "main",
                     corona = FALSE,
                     pickmdl_method = "first", star = 1,
                     when_star = warning,
                     when_automdl = message,
                     when_finalnotok = NULL,
                     identification_end = NULL, identification_estimate.to = NULL,
                     policy = "Outliers",
                     identify_t_filter = FALSE, identify_s_filter = FALSE,
                     identify_outliers = TRUE,
                     identify_arima_mu = TRUE,
                     automdl.enabled = FALSE,
                     fastfirst = TRUE,
                     verbose = FALSE,
                     output = "sa",
                     add_comment = TRUE){
  if(!(both_output %in% c("main", "spec", "both")))
    stop('Allowed values of parameter both_output are "main", "spec" and "both".')
  
  #spec <- x13_spec(...)
  
  if(is.null(spec)) spec <- x13_spec("rsa5c")
  if(!inherits(spec,"JD3_X13_SPEC")){
    spec <- rjd3x13::x13_spec(spec)
  }
  dots <- list(...)

  
  
  if(length(dots) > 0){
    
    parts <- strsplit(names(dots),"__",fixed=TRUE)
    
    # Første del er funksjonsnavn
    fn_names <- vapply(parts, `[`, character(1), 1)
    
    # Andre del er argumentnavn
    arg_names <- vapply(parts, `[`, character(1), 2)
    
    by_fn <- split(seq_along(dots), fn_names)
    
    for (fn in names(by_fn)) {
      idx <- by_fn[[fn]]
      
      args <- dots[idx]
      names(args) <- arg_names[idx]
      args[["x"]] <- spec
      
      fn_obj <- get(fn, mode = "function")
      
      # Evaluer funksjonskallet og legg til bidraget
      spec <- do.call(fn_obj, args)
    }
  }
  
  if(both_output == "spec"){
    return(spec)
  }
  
  # The function definition of x13_both is, for most parameters, made to be
  # identical to  x13_pickmdl (same parameters and default values).
  # This is also tested in the package test.
  # Below:
  #   old method is more understandable
  #   new method is safer in terms of updates of x13_pickmdl
  
  # Trick to run old_method for testing:
  x13_both_old_method <- get0("x13_both_old_method", ifnotfound = FALSE)
  
  if(x13_both_old_method){
    message("x13_both_old_method = TRUE")
    main  <- x13_pickmdl(ts = ts, spec = spec, userdefined = userdefined, context = context,
                         corona = corona,
                         pickmdl_method = pickmdl_method, star = star, when_star = when_star,
                         when_automdl = when_automdl, when_finalnotok = when_finalnotok,
                         identification_end = identification_end, identification_estimate.to = identification_estimate.to,
                         policy = "Outliers",
                         identify_t_filter = identify_t_filter, identify_s_filter = identify_s_filter,
                         identify_outliers = identify_outliers, identify_arima_mu = identify_arima_mu,
                         automdl.enabled = automdl.enabled,
                         fastfirst = fastfirst, verbose = verbose,
                         output = output,  add_comment =  add_comment)
  } else {
    dot_names <- names(list(...))
    m_call <- match.call()
    m_call <- m_call[!(names(m_call) %in% c(dot_names, "both_output"))]
    if(!is.null(context)){
      m_call[["context"]] <- get(context)   ### for aa sette context.  
    }
    m_call[["spec"]] <- spec
    m_call[[1]] <- x13_pickmdl
    main <- eval(m_call, envir = parent.frame())
  }
  
  if(both_output == "both"){
    return(list(main = main, spec = spec))
  }
  
  main
}
