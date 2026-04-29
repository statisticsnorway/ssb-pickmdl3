#' PICKMDL "first" check
#'
#' Check whether \code{\link[rjd3x13]{x13}} output is ok according to
#' the  PICKMDL "first" method
#'
#' Unlike \code{\link{ok}}, this function does the actual calculations.
#'
#' @param sa A \code{\link[rjd3x13]{x13}} output object
#'
#' @return `TRUE` or `FALSE`
#' @export
#'
#' @seealso \code{\link{crit_selection}}
#'
#' @examples
#'
#' myseries <- pickmdl_data("myseries")
#'
#' spec_now <- rjd3x13::x13_spec("rsa3")
#' spec_a <- rjd3toolkit::set_transform(spec_now,fun="Log")
#' a <- x13_pickmdl(myseries, spec_a)
#' spec_b <- rjd3toolkit::set_transform(spec_now,fun="None")
#' b <- x13_pickmdl(myseries, spec_b)
#'
#' crit_ok(a)
#' crit_ok(b)
#'
crit_ok <- function(sa) {
  as.logical(crit_selection(crit_table(list(sa)), star = 0, when_star = NULL))
}
