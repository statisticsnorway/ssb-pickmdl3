#' x13 output filters to x13 input filters
#'
#' Elements `t_filter` and `s_filter` are transformed to input parameters `henderson.filter` and `seasonal.filter` in \code{\link[rjd3x13]{set_x11}}
#'
#' @param sa A \code{\link[rjd3x13]{x13}} output object
#'
#' @return list of `henderson.filter` (numeric) and `seasonal.filter` (character)
#' @export
#'
#' @examples
#' myseries <- pickmdl_data("myseries")
#'
#' a <- rjd3x13::x13(myseries, spec = "rsa3")
#'
#' a$result$decomposition$final_henderson
#' a$result$decomposition$final_seasonal
#' filter_input(a)
#'
#' spec_b <- rjd3x13::x13_spec("rsa3")
#' spec_b <- rjd3x13::set_x11(spec_b,seasonal.filter="Stable",henderson.filter=13)
#' b <- rjd3x13::x13(myseries, spec = spec_b)
#'
#' b$result$decomposition$final_henderson
#' b$result$decomposition$final_seasonal
#' filter_input(b)
#'

filter_input <- function(sa) {
  henderson.filter <- sa$result$decomposition$final_henderson
  seasonal.filter <- sa$result$decomposition$final_seasonal
  if (is.na(henderson.filter)) {
    stop("Could not find henderson.filter")
  }
  if (henderson.filter < 1) {
    stop("Could not find correct henderson.filter")
  }
  #seasonal.filter <- paste0("S3x", seasonal.filter)
  seasonal.filter <- gsub("FILTER_", "", seasonal.filter)
  
  list(henderson.filter = henderson.filter, seasonal.filter = seasonal.filter)
}

split_for_filter = function(s){
  unlist(strsplit(as.character(s), split = "[ -]"))[1]
}
