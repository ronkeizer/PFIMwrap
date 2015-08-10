#' Show help for argument
#' @param argument string to speficy which argument to show help info for. If NULL, a list of all available arguments is shown. Help information is extracted from stdin.R template script provided with PFIM.
#' @export
pfim_help <- function(argument = "") {
  if(!is.null(argument)) {
    # extract help info from stdin template
  } else {
    # show list of all available arguments
  }
}
