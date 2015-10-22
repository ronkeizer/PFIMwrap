#' Run PFIM
#'
#' @description Run PFIM calculations based on specified settings object
#' @param ini arguments to be set for PFIM. The argument names correspond to the object names in that you would normally set in stdin.R.
#' @export

pfim_run <- function(ini = list()) {
  out <- list()
  wd <- getwd()
  if(file.exists(ini$PFIM)) {
      writeLines(
         paste0(
           "library(stringr)\n",
           "source('", ini$PFIM, "')\n",
           "res <- PFIM('", ini$stdin,"')\n",
           "save(list = 'res', file = 'pfim.res')\n"),
         paste0(ini$folder, "/start.R")
      )
      if(file.exists(paste0(ini$folder, "/", ini$stdin))) {
        setwd(ini$folder)
        suppressMessages({
          suppressWarnings({
            system("Rscript start.R")
          })
        })
        res <- NULL
        if(file.exists(paste0(ini$folder, "/pfim.res"))) {
          load(file = paste0(ini$folder, "/pfim.res"))
          setwd(wd)
          unlink(ini$folder)
        } else {
          setwd(wd)
        }
        if(is.null(res)) {
          stop(paste0("Sorry, PFIM failed for some reason. Look in ", ini$folder, " to debug."))
        } else {
          return(res)
        }
      } else {
        stop("Sorry, stdin script not found, please redefine your settings.")
      }
  } else {
    stop("Sorry, PFIM main script not found, please redefine your settings.")
  }
}
