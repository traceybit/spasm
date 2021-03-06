#' create manager
#'
#' @param year_mpa
#'
#' @return a manager object
#' @export
#'
#' @examples create_manager(year_mpa = 12)
create_manager <- function(year_mpa = 15,
                           mpa_size = 0.25){



  manager <- list(year_mpa = year_mpa,
                  mpa_size = mpa_size)

  return(manager)

}