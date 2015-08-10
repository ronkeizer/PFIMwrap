#' Get arguments to PFIM from a template .R file (stdin.R)
get_args_from_template <- function(file = NULL, templ = c()) {
  if(!is.null(file)) {
    lin <- readLines(file)
  } else {
    lin <- templ
  }
  lin_def <- lin[!is.na(str_match(lin, "<-"))]
  tmp <- str_split(lin_def, "<-")
  l <- list()
  args <- unlist(lapply (tmp, FUN=function(x) { rm_spaces(x[1]) }))
  args <- args[is.na(str_match(args, "#"))]
  args
}
