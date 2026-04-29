#' PICKMDL information as a list
#'
#' Extract `ok`, `ok_final` and `mdl_nr`
#'
#' @param sa Output from \code{\link{x13_pickmdl}}
#'
#' @return List constructed from comment attribute
#' @export
#'
#' @seealso \code{\link{crit_ok}}
#'
#' @examples
#' myseries <- pickmdl_data("myseries")
#'
#' spec_now <- rjd3x13::x13_spec("rsa3")
#' spec_a <- rjd3toolkit::set_transform(spec_now, fun = "Log")
#' a <- x13_pickmdl(myseries, spec_a)
#' spec_b <- rjd3toolkit::set_transform(spec_now, fun = "None")
#' b <- x13_pickmdl(myseries, spec_b)
#'
#' comment(a)
#' comment(b)
#' ok(a)
#' ok(b)
#'
ok <- function(sa) {
  if(is.null(comment(sa))){
    warning("comment attribute missing")
    return(list(ok = NA, ok_final = NA, mdl_nr = NA_integer_))
  }
  a <- as.list(comment(sa))
  a$ok <- as.logical(a$ok)
  a$ok_final  <- as.logical(a$ok_final)
  a$mdl_nr <- as.integer(a$mdl_nr)
  a
}
