#' Run PFIM
#'
#' @description Run PFIM calculations based on specified settings object
#' @param ini arguments to be set for PFIM. The argument names correspond to the object names in that you would normally set in stdin.R.
#' @export

pfim_run <- function(ini = list()) {
  out <- list()
  if(file.exists(ini$PFIM)) {
    e <- new.env()
    evalq({
      source(ini$PFIM)
      if(file.exists(paste0(ini$folder, "/", ini$stdin))) {
        PFIM(ini$stdin)
      } else {
        stop("Sorry, stdin script not found, please redefine your settings.")
      }
    }, envir = e)
  } else {
    stop("Sorry, PFIM main script not found, please redefine your settings.")
  }
  return(out)
}
