#' Capture whether there is a mean coefficient from x13 output
#'
#'
#' @param sa A \code{\link[rjd3x13]{x13}} output object
#'
#' @return `TRUE` or `FALSE`
#' @export
#'
#' @examples
#' myseries <- pickmdl_data("myseries")
#'
#' spec_a <- rjd3x13::x13_spec("rsa1")
#' spec_b <- rjd3toolkit::set_arima(spec_a,mean=0.2)
#'
#' a <- rjd3x13::x13(myseries, spec = spec_a)
#' b <- rjd3x13::x13(myseries, spec = spec_b)
#'
#' arima_mu(a)
#' arima_mu(b)
#'

arima_mu <- function(sa) {
  "MEAN" %in% sapply(sa$result$preprocessing$description$variables,"[[","type")
}
