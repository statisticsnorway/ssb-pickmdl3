
#' Function to get list of column names and standard types
#'
#' @param dt Data frame for editing
#'
#' @returns List of column names and types to use in editor
#' @noRd
get_column_list <- function (dt){
  column_list <- list(set_easter__enabled = c(TRUE,FALSE),
                      automdl.enabled = c(TRUE,FALSE)
  )
  
  #  update with 'chr' for columns not in the original list
  for (col in names(dt)) {
    if(!col %in% names(column_list)) {
      column_list[[col]] = "chr"
    }
  }
  
  # Drop original col_options not in the data
  column_list <- column_list[names(column_list) %in% names(dt)]
  
  column_list
}

#' Edit a constraint data frame object
#'
#' @param dt Data frame object
#' @param view To view in browser, write "browser". 
#'
#' @returns Updated data frame object
#' @export
#' 
edit_constraints <- function(dt,view = "dialog"){
  
  if (!requireNamespace("DataEditR", quietly = TRUE)) {
    stop("Package 'DataEditR' is required for this function but is not installed. Please install it before running the function agian.")
  }
  
 
  col_options_list <- get_column_list(dt)
  
  if(view=="browser"){
    new_data <- DataEditR::data_edit(dt,viewer="browser",col_options = col_options_list)
  }else{
    new_data <- DataEditR::data_edit(dt,viewer="dialog",col_options = col_options_list)
  }
  
  # convert all variables to character
  new_data[] <- lapply(new_data, as.character)
  
  new_data
}


#' Add a constraint to a constraint data frame object and open for editing.
#'
#' @param dt Data frame object
#' @param constraint Name of the new constraint to be added
#' @param view To view in browser, write "browser". 
#' @param type The type of constraint it is. "int" for integer, "bool" for boolean
#' @param default The default value to give the constraint
#'
#' @returns Updated constraint data frame object
#' @export
add_constraint <- function(dt, view = "dialog",constraint, type = "chr", default = ""){
  
  if (!requireNamespace("DataEditR", quietly = TRUE)) {
    stop("Package 'DataEditR' is required for this function but is not installed. Please install it before running the function agian.")
  }
  
  if (type == "int" & default == "") default = NA
  if (type == "bool" & default == "") default = FALSE
  new_col <- matrix(rep(default, nrow(dt)),
                    ncol = 1,
                    dimnames = list(NULL, constraint))
  
  col_options_list <- get_column_list(dt)
  

  if(view=="browser"){
    new_data <- DataEditR::data_edit(dt,
                                     viewer = "browser",
                                     col_bind = new_col,
                                     col_options = col_options_list
    )
  }else{
    new_data <- DataEditR::data_edit(dt,
                                     col_bind = new_col,
                                     col_options = col_options_list
    )
  }
  
  # convert all variables to character
  new_data[] <- lapply(new_data, as.character)
  
  new_data
}


