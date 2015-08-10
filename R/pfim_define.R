#' Define settings for PFIM run
#' @param args arguments to be set for PFIM. The argument names correspond to the object names in that you would normally set in stdin.R.
#' @param tempate_file optional template filename for PFIM settings to override defaults
#' @export
pfim_define <- function (args = list(),
                         model = NULL,
                         template_file = NULL,
                         out_file = NULL,
                         version = "4.0") {
  if(is.null(template_file)) {
    template_file <- paste0(system.file(package="PFIMwrap"), "/PFIM", version, "/stdin.R")
  }
  if(!file.exists(template_file)) {
    print(template_file)
    stop("Sorry, template file does not exist.")
  }
  templ <-readLines(template_file)
  args_allowed <- get_args_from_template(templ = templ)
  m <- names(args) %in% args_allowed
  if(!all(m)) {
    message(paste("Unknown arguments to PFIM:", paste(names(args[!m]), collapse=", ")))
    message(paste("Allowed arguments are:", paste(args_allowed, collapse=", ")))
    stop()
  }
  for (i in seq(names(args))) {
    assign(names(args)[i], args[[names(args[i])]])
  }
  temp_folder <- tempdir()
  r_obj_file <- tempfile(pattern="args_", tmpdir=temp_folder, fileext=".Robj")
  save(list = names(args), file = r_obj_file)
  templ <- c(templ, "\n\n\n### Overwrite defaults ###", paste0("load(file = '", r_obj_file, "')"))
  if(is.null(out_file)) {
    out_file <- tempfile(pattern = "file", tmpdir = "", fileext = ".R")
  }
  writeLines(templ, paste0(temp_folder,"/", out_file))

  # write model PFIM.R
  if(is.null(model)) {
    suppressWarnings(
      model_tmp <- readLines(paste0(system.file(package="PFIMwrap"), "/PFIM", version, "/model.R"))
    )
  }
  model_file <- "model.R"
  writeLines(model_tmp, paste0(temp_folder, "/", model_file))

  # create new PFIM.R
  PFIM_file <- tempfile(pattern = "PFIM_", tmpdir = temp_folder, fileext = ".R")
  PFIM_tmp <- readLines(paste0(system.file(package="PFIMwrap"), "/PFIM", version, "/PFIM.R"))
  dir1 <- !is.na(str_match(PFIM_tmp, "directory<-"))
  dir2 <- !is.na(str_match(PFIM_tmp, "directory.program<-"))
  PFIM_tmp[dir1] <- paste0("directory         <- '", temp_folder, "'")
  PFIM_tmp[dir2] <- paste0("directory.program <- '", paste0(system.file(package="PFIMwrap"), "/PFIM", version, "/Program"), "'")
  writeLines(PFIM_tmp, PFIM_file)
  return(list(folder = temp_folder,
              stdin = out_file,
              model = model_file,
              PFIM  = PFIM_file,
              args  = args))
}
