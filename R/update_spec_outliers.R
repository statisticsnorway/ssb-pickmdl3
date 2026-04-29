#' Update x13 spec with outliers
#'
#' Update an `x13_spec` output object with outliers from an `x13` output object.
#'
#' @param sa   An \code{\link[rjd3x13]{x13}} output object
#' @param spec An \code{\link[rjd3x13]{x13_spec}} output object
#' @param day Day of month as character to be used in outlier coding
#' @param verbose Printing information to console when `TRUE`.
#' @param input_output When `TRUE` output is a list of `x13_spec` parameters
#'                     instead of an updated spec.
#'
#' @return `update_spec_outliers` returns an updated `x13_spec` output object with
#'          new outliers and updated `outlier.from`.
#'         `update_outliers` returns a data frame with outlier variables used to update.
#' @export
#' @importFrom stats end frequency
#'
#'
#' @note For special use, parameter `sa` to `update_outliers` can be a
#'       data frame of outliers (as created by \code{\link{corona_outliers}}).
#'
#' @examples
#' myseries <- pickmdl_data("myseries")
#'
#' spec_1 <- rjd3x13::x13_spec("rsa3")
#' spec_1 <- rjd3toolkit::set_transform(spec_1, fun = "Log")
#' spec_1 <- rjd3toolkit::set_outlier(spec_1, critical.value =3)
#' spec_1 <- rjd3toolkit::add_outlier(spec_1, type="AO",date="2008-09-01")
#'
#'
#' spec_2 <- rjd3toolkit::set_basic(spec_1, type="To", d1 = "2020-02-01")
#'
#' a <- rjd3x13::x13(myseries, spec_2)
#'
#' update_outliers(a, spec_1)
#'
#' spec_3 <- update_spec_outliers(a, spec_1)
#'
#' update_spec_outliers(a)
#'
update_spec_outliers <- function(sa, spec = NULL, day = "01", verbose = FALSE, input_output = is.null(spec)) {
  
  freq = frequency(sa$result$preadjust$a1)
  
  if (!(freq %in%  c(4, 12))) {
    stop("Only frequencies 4 and 12 implemented")
  }
  
  end_span <- sa$result_spec$regarima$estimate$span$d1
  if(!is.null(end_span)){
    end_span_integer <- as.numeric(format(sa$result_spec$regarima$estimate$span$d1,c("%Y","%m")))
    
  }else{
    end_span_integer <- end(sa$result$preadjust$a1)
  }
  
  new_from_integer = end(ts(1:2, start = end_span_integer, frequency = freq))
  
  if (freq == 4) {
    new_from_integer[2] <- 1 + (new_from_integer[2] - 1) * 3   # kvartal
  }
  
  from_ <- sub(".", "-", sprintf("%7.2f", (new_from_integer[1] + new_from_integer[2]/100)), fixed = TRUE)
  new_outlier.from <- paste(from_, day, sep = "-")
  
  if(!is.null(spec)){
    old_outlier.from <- spec$regarima$outlier$span$d0
    old_outlier.from <- ifelse(is.null(old_outlier.from),NA,as.character())
    
    
  } else {
    old_outlier.from <- NA
  }
  
  if (is.na(old_outlier.from)){
    old_outlier.from <- "0000-00-00"  ## To be used in comparison below
  }
  
  
  if (new_outlier.from <= old_outlier.from) {
    if(verbose) cat("outlier.from not updated:", old_outlier.from, "\n")
    if (input_output) {
      new_outlier.from <- old_outlier.from
    } else {
      return(spec)
    }
  }
  
  if (!input_output) {
    spec <- set_outlier(spec,span.type = "From",d0 = new_outlier.from)
  }
  
  if(verbose) cat("outlier.from updated:", new_outlier.from)
  
  updated <- update_outliers(sa = sa, spec = spec, day = day, null_when_no_new = !input_output, verbose = verbose)
  
  if (is.null(updated)) {
    return(spec)
  }
  
  if (input_output) {
    return(list(outlier.from = new_outlier.from, type = as.character(updated$type), date = as.character(updated$date)))
  }
  
  rjd3toolkit::add_outlier(spec, type= as.character(updated$type),date = as.character(updated$date))
  
}

#' @rdname update_spec_outliers
#' @param null_when_no_new Whether to return `NULL` when no new outliers found.
#' @export
update_outliers <- function(sa, spec, day = "01", null_when_no_new = TRUE, verbose = FALSE) {
  
  if(!is.null(spec)){
    #pre <- s_preOut(spec)
    pre_pos <- sapply(spec$regarima$regression$outliers,"[[","pos")
    pre_code <- sapply(spec$regarima$regression$outliers,"[[","code")
    #pre_coeff <- sapply(spec$regarima$regression$outliers,"[[","coeff")
    pre <- data.frame(type=pre_code,date=pre_pos)
    
  } else {
    pre <- NULL
  }
  
  if(is.data.frame(pre)){
    pre <- ForceCharacterDataFrame(pre) # for old r versions
  }
  
  if (!length(nrow(pre))) {
    pre <- matrix(0, 0, 0)  # nrow is 0
  }
  
  if (!nrow(pre)) {  # when nrow is 0
    pre <- data.frame(type = character(0), date = character(0), stringsAsFactors = FALSE) # stringsAsFactors for old r versions
  } 
  
  if (is.data.frame(sa)) {  # special use
    sa_o <- sa[!(sa$date %in% pre$date), , drop = FALSE]
    if (null_when_no_new & !nrow(sa_o)) {
      return(NULL)
    }
  } else {
    sa_o <- sa_out(sa)
    
    if (length(sa_o)) {
      sa_o <- sa_o[!(sa_o$date %in% substr(pre$date, 1, 7)), , drop = FALSE]
    } else {
      #sa_o <- matrix(0, 0, 0)  # nrow is 0
      sa_o <- data.frame(type = character(0), date = character(0), stringsAsFactors = FALSE) # Better when !null_when_no_new
    }
    
    if (null_when_no_new & !nrow(sa_o)) {
      if(verbose) cat("  No new outliers.\n")
      return(NULL)
    }
    if(verbose) cat("  New outliers:", paste(sa_o$date, collapse = ", "), "\n")
    
    if (nrow(sa_o)) {
      sa_o$date <- paste(sa_o$date, day, sep = "-")
    }
  }
  sa_o
}


sa_out <- function(a) {
  
  #s <- row.names(a$regarima$regression.coefficients)
  s <- sapply(a$result$preprocessing$description$variables,"[[","name")
  if (!length(s)) {
    return(character(0))
  }
  
  k <- strsplit(s, split = "[()-]")
  
  kis3 <- (sapply(k, length) == 4 & grepl("(", s, fixed = TRUE))
  
  if (!sum(kis3)) {
    return(data.frame(type = character(0), date = character(0), stringsAsFactors = FALSE)) # stringsAsFactors for old r versions
  }
  k <- k[kis3]
  year <- as.integer(sapply(k, function(x) x[2]))
  k2 <- sapply(k, function(x) x[3])
  k2[k2 == "I"] <- "1"
  k2[k2 == "II"] <- "4"
  k2[k2 == "III"] <- "7"
  k2[k2 == "IV"] <- "10"
  month <- as.integer(k2)
  date_mnd <- sub(".", "-", sprintf("%7.2f", (year + month/100)), fixed = TRUE)
  
  type <- trimws(sapply(k, function(x) x[1]))
  
  data.frame(type = type, date = date_mnd, stringsAsFactors = FALSE) # stringsAsFactors for old r versions
  
}



#SSBtools::ForceCharacterDataFrame
ForceCharacterDataFrame <- function(x) {
  for (i in seq_len(NCOL(x))) if (is.factor(x[, i, drop =TRUE]))
    x[, i] <- as.character(x[, i, drop =TRUE])
  x
}
