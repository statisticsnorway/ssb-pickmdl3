
#' Corona outliers
#'
#' Corona outliers as a type-date data frame. Also a function to update spec with these outliers.
#'
#' Corona outliers with same date as outliers already in spec will be omitted.
#'
#' @param option Only `"ssb"` implemented
#' @param freq frequency, `4` or `12`
#' @param day day of month as character
#' @param q_month month of quarter as `1`, `2` or `3`
#' @param spec A specification object of class "JD3_X13_SPEC" to be updated.
#' @param outlier_date_limit  Only outliers with `date < outlier_date_limit` will be included in updated spec.
#'
#' @return data frame
#' @export
#'
#'
#' @examples
#'
#' corona_outliers()
#' corona_outliers(freq = 4)
#'
#' spec_a <- rjd3x13::x13_spec(name = "rsa3")
#' spec_a <- rjd3toolkit::set_transform(spec_a, fun = "Log")
#' spec_a2 <- update_spec_corona_outliers(spec_a)
#' as.data.frame(t(sapply(spec_a$regarima$regression$outliers,"[")))
#' as.data.frame(t(sapply(spec_a2$regarima$regression$outliers,"[")))
#'
#' spec_b <- rjd3x13::x13_spec(name = "rsa3")
#' spec_b <- rjd3toolkit::set_transform(spec_b, fun = "Log")
#' spec_b <- rjd3toolkit::add_outlier(spec_b,type=rep("AO",3),
#'                                 date=c("2009-01-01", "2016-01-01", "2020-05-01"))
#' spec_b2 <- update_spec_corona_outliers(spec_b, outlier_date_limit = "2021-11-01")
#' as.data.frame(t(sapply(spec_b$regarima$regression$outliers,"[")))
#' as.data.frame(t(sapply(spec_b2$regarima$regression$outliers,"[")))
#'
corona_outliers <- function(option = "ssb", freq = 12, day = "01", q_month = 1) {
  if (option != "ssb") {
    stop('Only type "ssb" implemented')
  }
  if (!(freq %in% c(4, 12))) {
    stop("Only freq 4 and 12 implemented")
  }
  if (!(q_month %in% 1:3)) {
    stop("q_month must be in 1:3")
  }
  year <- rep(2020:2022, each = 12)
  month <- rep(1:12, 3)
  dates <- paste(year, Number(month, 2), day, sep = "-")
  
  if (freq == 4) {
    dates <- dates[q_month + 3 * (0:8)]
  }
  if (freq == 12) {
    dates <- dates[3:27]
  }
  data.frame(type = "LS", date = dates, stringsAsFactors = FALSE)
}


#' @rdname corona_outliers
#' @export
update_spec_corona_outliers <- function(spec, option = "ssb", freq = 12, day = "01", q_month = 1, outlier_date_limit = "3000-01-01") {
  co <- corona_outliers(option = option, freq = freq, day = day, q_month = q_month)
  co <- co[co$date < outlier_date_limit, , drop = FALSE]
  if (nrow(co)) {
    pre_date <- lapply(spec$regarima$regression$outliers,"[[","pos")
    pre_date <- sapply(pre_date,as.character)
    updated <- co[!(co$date %in% pre_date),]
  } else {
    updated <- NULL
  }
  if (is.null(updated) ) {
    return(spec)
  }
  if(!nrow(updated)){
    return(spec)
  }else{
    rjd3toolkit::add_outlier(spec,type=as.character(updated$type),date=as.character(updated$date))
  }
}



# SSBtools::Number
Number <- function(n, width = 3) {
  s <- "s <- sprintf('%0d', n)"
  s <- gsub("0", as.character(width), s)
  eval(parse(text = s))
  s <- gsub(" ", "0", s)
  s
}
