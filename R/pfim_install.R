#' Download PFIM and install
#' @param version string with PFIM version (default is "4.0")
#' @param url URL for zip-file of PFIM. If NULL, will default to INSERM download location for specified `pfim_version`.
#' @param local_file path to local zip file containing PFIM
#' @param to install location. By default, PFIM will be installed to the PFIMwrap package folder.
#' @export
pfim_install <- function(
  version = "4.0",
  url = NULL,
  local_file = NULL,
  to = NULL
  ) {
  if(is.null(local_file)) {
    if(is.null(url)) {
      url <- paste0("http://www.pfim.biostat.fr/PFIM", version, ".zip")
    }
    tmp_file <- tempfile(pattern="pfim_", fileext = "zip")
    download.file(url, tmp_file)
  } else {
    if(file.exists(local_file)) {
      tmp_file <- local_file
    } else {
      stop("Specified local zip file not found!")
    }
  }
  if(is.null(to)) {
    to <- system.file(package = "PFIMwrap")
  }
  unzip(tmp_file, exdir = to)
  if(is.null(local_file)) {
    unlink(tmp_file)
  }
  if(file.exists(paste0(to, "/PFIM4.0/PFIM.r"))) {
    message(paste0("PFIM ", version, " successfully installed to ", to, "/PFIM", version))
  } else {
    message("Something wrent wrong while installing PFIM.")
  }
}
