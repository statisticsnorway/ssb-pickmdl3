
#' Create an initial parameter file for x13_text_frame(). All values in the column are the same
#'
#' @param indat Either i) a multiple time series object or ii) a data frame with time variable in the first column.
#' In both cases columns must be named.
#' @param ... Additional arguments passed to x13_spec or x13_both
#'
#' @details
#' The '...' parameter can include any combination of arguments and their values that are valid for the functions 'x13_spec' and 'x13_both'.
#' @return A data frame.
#' @export
#'
#' @examples
#'
#' set.seed(123)
#'
#' years <- 2000:2024
#' ts1 <- runif(length(years), min = 50, max = 150)
#' ts2 <- runif(length(years), min = 50, max = 150)
#' ts3 <- runif(length(years), min = 50, max = 150)
#'
#' inndata <- data.frame(
#'  year = years,
#'  tidsserie_1 = ts1,
#'  tidsserie_2 = ts2,
#'  tidsserie_3 = ts3
#')
#'
#' tf_test1 <- make_paramfile(indat = inndata, spec="rsa3")




make_paramfile <- function(indat,...) {
  
  arg_tool <- utils::lsf.str("package:rjd3toolkit")
  arg_3x13 <- utils::lsf.str("package:rjd3x13")
  
  namelist <- NULL
  
  for(i in 1:length(arg_tool)){
    namelist <- c(namelist,paste(arg_tool[[i]],names(as.list(args(arg_tool[[i]]))),sep="__"))
  }
  for(i in 1:length(arg_3x13)){
    namelist <- c(namelist,paste(arg_3x13[[i]],names(as.list(args(arg_3x13[[i]]))),sep="__"))
  }
  
  # noe som gjoer at "__" , "__x" og "__..." fjernes fra namelist ....
  
  namelist <- namelist[!(grepl("__\\.\\.\\." ,unique(namelist))|
                           grepl("__x",unique(namelist))|endsWith(unique(namelist),"__"))]
  namelist <- namelist[startsWith(namelist,"set")|startsWith(namelist,"add")]
  
  namelist_x13_both <- names(as.list(args(x13_both)))
  namelist_x13_both <- namelist_x13_both[!namelist_x13_both %in% c("...","")]
  namelist <- unique(c(namelist,namelist_x13_both))
  
  mulige_parametere <- namelist#combine_param_names(pickmdl::x13_both, RJDemetra::x13_spec)
  # Capture all the parameters passed to the function
  params <- list(...)
  
  if (!"spec" %in% names(params)) {
    params$spec <- "RSA5c"
  }
  
  #Ensure 'userdefined' is included in the parameters
  if (!"userdefined" %in% names(params)) {
    params$userdefined <- c("decomposition.a1","decomposition.a6","decomposition.a7","decomposition.a8","decomposition.b1",
                            "decomposition.d10", "decomposition.d11", "decomposition.d12", "decomposition.d13", "decomposition.d18",
                            "diagnostics.seas-si-combined","diagnostics.seas-sa-friedman","residuals.independence.value")
  }
  
  params$userdefined <- paste0('c(', paste0('"', params$userdefined, '"', collapse = ", "), ')')
  
  
  if ("identification_end" %in% names(params)) {
    params$identification_end <- params$identification_end
  }
  
  #if ("usrdef.var" %in% names(params)) {  ### sjekk add_usrdefvar.... eller set_traydingdays!!!
  #  params$usrdef.var <- params$usrdef.var
  #}
  
  
  
  #if ("usrdef.outliersDate" %in% names(params)) {
  if ("add_outlier__date" %in% names(params)) {
    params$add_outlier__date <- paste0('c(', paste0('"', params$add_outlier__date, '"', collapse = ", "), ')')
  }
  
  if ("add_outlier__type" %in% names(params)) {
    params$add_outlier__type <- paste0('c(', paste0('"', params$add_outlier__type, '"', collapse = ", "), ')')
  }
  if ("set_outlier__outliers.date" %in% names(params)) {
    params$set_outlier__outliers.date <- paste0('c(', paste0('"', params$set_outlier__outliers.date, '"', collapse = ", "), ')')
  }
  
  if ("set_outlier__outliers.type" %in% names(params)) {
    params$set_outlier__outliers.type <- paste0('c(', paste0('"', params$set_outlier__outliers.type, '"', collapse = ", "), ')')
  }
  if ("set_tradingdays__uservariable" %in% names(params)){
    params$set_tradingdays__uservariable <- paste0('c(', paste0('"', params$set_tradingdays__uservariable, '"', collapse = ", "), ')')
  }
  
  
  
  
  # Check each parameter and add quotes if it's a character
  for (navn in names(params)) {
    if (!navn %in% mulige_parametere){
      warning(paste0("The parameter ", navn, " is included, but is unknown in the list of parameters used in x13_both."))
    }
    if (!navn %in%  c("userdefined","identification_end","usrdef.var","add_outlier__date","add_outlier__type","set_outlier__outliers.type","set_tradingdays__uservariable")) {
      if (is.character(params[[navn]]) && !is.na(params[[navn]])) {
        params[[navn]] <- paste0('"', params[[navn]], '"')
      } else if (is.logical(params[[navn]])) {
        params[[navn]] <- as.character(params[[navn]])
      } else if (is.numeric(params[[navn]])) {
        params[[navn]] <- as.character(params[[navn]])
      }
    }
  }
  
  # Create the data frame
  df <- as.data.frame(params)
  
  if (ncol(df) == 1 && !"spec" %in% names(df)) {   ### hvorfor ncol(df)==1?
    df <- cbind(df, spec = params$spec)
  }
  
  datasett1 <- indat
  if(!stats::is.ts(indat)){
    datasett1 <- indat[,-1]
  }
  
  serienavn <- c(colnames(datasett1))
  
  # Replicate the rows based on the length of indat
  df <- df[rep(1, length(serienavn)), ]
  
  
  # Add the serienavn column
  df <- cbind(name = serienavn, df)
  
  # Drop the row names
  rownames(df) <- NULL
  
  return(df)
}
