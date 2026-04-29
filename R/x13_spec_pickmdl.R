
#' Multiple X-13ARIMA model specifications
#' 
#' \code{\link[rjd3x13]{x13_spec}} is run multiple times with input for multiple arima models.
#' 
#' This function behaves like `x13_spec` except that some of the parameters may be vectors.
#' These vectors must be the same length.
#'
#' @param ...  A "JD3_X13_SPEC" class object generated with \code{\link[rjd3x13]{x13_spec}}
#' @param arima.p 'set_arima' parameters as vector.
#' @param arima.d 'set_arima' parameters as vector.
#' @param arima.q 'set_arima' parameters as vector.
#' @param arima.bp 'set_arima' parameters as vector.
#' @param arima.bd 'set_arima' parameters as vector.
#' @param arima.bq 'set_arima' parameters as vector.
#' @param automdl.enabled 'set_automodel' parameter
#'
#' @returns List of several "JD3_X13_SPEC" class objects
#' @export
#' @importFrom rjd3x13 x13_spec
#'
#' @examples
#'
#' spec <- rjd3x13::x13_spec("rsa3")
#' spec_list <- x13_spec_pickmdl(spec)
#'
x13_spec_pickmdl <- function(..., arima.p = c(0, 0, 2, 0, 2),
                             arima.d = c(1, 1, 1, 2, 1), arima.q = c(1, 2, 0, 2, 2),
                             arima.bp = 0, arima.bd = 1, arima.bq = 1,
                             automdl.enabled = FALSE ) {
  n <- length(arima.p)
  
  if(length(arima.bp) == 1) arima.bp <- rep(arima.bp, n)
  if(length(arima.bd) == 1) arima.bd <- rep(arima.bd, n)
  if(length(arima.bq) == 1) arima.bq <- rep(arima.bq, n)
  
  
  if (length(arima.d) != n | length(arima.q) != n) {
    stop("arima.p, arima.d and arima.q must have same length")
  }
  
  if (length(arima.bp) != n | length(arima.bd) != n | length(arima.bq) != n) {
    stop("arima.bp, arima.bd and arima.bq must have length 1 or same length as other parameters")
  }
  
  
  spec <- vector("list", n)
  for (i in 1:n) {
    spec[[i]] <- suppressWarnings(rjd3toolkit::set_arima(rjd3toolkit::set_automodel(...,enabled = automdl.enabled),
                                                         p = arima.p[i], d = arima.d[i], q = arima.q[i],
                                                         bp = arima.bp[i], bd = arima.bd[i], bq = arima.bq[i]))
  }
  spec
}
