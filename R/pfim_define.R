#' Define settings for PFIM run
#' @param args arguments to be set for PFIM. The argument names correspond to the object names in that you would normally set in stdin.R.
#' @param tempate_file optional template filename for PFIM settings to override defaults
#' @param ... passed to model function
#' @export
pfim_define <- function (
  args = list(),
  model = NULL,
  folder = NULL,
  template_file = NULL,
  out_file = NULL,
  version = "4.0",
  parameters = NULL,
  regimen = NULL,
  ...) {

    ## read stdin.R
    if(is.null(template_file)) {
      template_file <- paste0(system.file(package="PFIMwrap"), "/config_template.R")
    }
    if(!file.exists(template_file)) {
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
    if(!is.null(folder) && file.exists(folder)) {
      temp_folder <- folder
    } else {
      temp_folder <- tempdir()
      message(paste0("Creating temporary folder ", temp_folder))
    }

    # write model
    if(is.null(model)) {
      message("No model specified, using default model!")
      model_file <- paste0(system.file(package="PFIMwrap"), "/PFIM", version, "/model.R")
    } else {
      if(class(model) == "character" && file.exists(model)) {
        model_file <- model
        if(file.exists(model_file)) {
          suppressWarnings(
            model_tmp <- readLines(model_file)
          )
        } else {
          stop("Can't find model file, please specify the full path of an R script with the model function.")
        }
        writeLines(model_tmp, paste0(temp_folder, "/model.R"))
      } else {# assume PKPDsim
        if(class(model) == "function") {
          parameters_pkpdsim <- parameters
          regimen_pkpdsim <- regimen
          save(list = c("model", "parameters_pkpdsim", "regimen_pkpdsim"), file=paste0(temp_folder, "/model.Robj"))
          model_file <- "model_pkpdsim.R"
          file.copy(paste0(system.file(package = "PFIMwrap"), "/model_pkpdsim.R"), paste0(temp_folder, "/model.R"))
        } else {
          stop("Model file not found")
        }
      }
    }


    ## check if previous FIM specified. If so, copy file
    prevFIM <- NULL
    if("previous.FIM" %in% names(args)) {
      prevFIM <- args$previous.FIM
    } else {
      sel <- !is.na(str_match(templ, "previous.FIM"))
      if(sum(sel) > 0) {
        prevFIM <- str_replace_all(str_split(templ[sel], "<-")[[1]][2], "[ \\\"]", "")
      }
    }
    if(!is.null(prevFIM)) {
      print(prevFIM)
      if(!file.exists(prevFIM)) {
        stop("Previous FIM file not found!")
      } else {
        fim_temp <- tempfile(pattern = "fim_", tmpdir = "", fileext = ".txt")
        file.copy(paste0(getwd(), "/", prevFIM), paste0(temp_folder, "/", fim_temp))
        args$previous.FIM <- fim_temp
      }
    }

    ## write specified arguments to R data object
    for (i in seq(names(args))) {
      assign(names(args)[i], args[[names(args[i])]])
    }
    r_obj_file <- tempfile(pattern="args_", tmpdir=temp_folder, fileext=".Robj")
    save(list = names(args), file = r_obj_file)
    templ <- c(templ, "\n\n\n### Overwrite defaults ###", paste0("load(file = '", r_obj_file, "')"))
    if(is.null(out_file)) {
      out_file <- tempfile(pattern = "file", tmpdir = "", fileext = ".R")
    }

    ## write new temp stdin.R
    writeLines(templ, paste0(temp_folder, "/", out_file))

    # create new PFIM.R
    PFIM_file <- tempfile(pattern = "PFIM_", tmpdir = temp_folder, fileext = ".R")
    PFIM_tmp <- readLines(paste0(system.file(package="PFIMwrap"), "/PFIM", version, "/PFIM.R"))
    PFIM_tmp <- str_replace_all(PFIM_tmp, "rm\\(list=ls\\(all=TRUE\\)\\)", "# line removed by PFIMwrap")
    PFIM_tmp <- str_replace_all(PFIM_tmp, "out\\(\\)", "x <- out() # removed by PFIMwrap\n")
    PFIM_tmp <- str_replace_all(PFIM_tmp, "out.fedorov", "x <- out.fedorov")
    PFIM_tmp[length(PFIM_tmp)] <- "  return(x)\n}"
    dir1 <- !is.na(stringr::str_match(PFIM_tmp, "directory<-"))
    dir2 <- !is.na(stringr::str_match(PFIM_tmp, "directory.program<-"))
    PFIM_tmp[dir1] <- paste0("directory         <- '", temp_folder, "'")
    PFIM_tmp[dir2] <- paste0("directory.program <- '", paste0(system.file(package="PFIMwrap"), "/PFIM", version, "/Program"), "'")
    PFIM_tmp <- c( # rewrite plot function, save to global variable
"assign('plots_pfim', list(), envir = globalenv())
 plot <- function(x, y, xlab, ylab, ...) {
   title <- paste(str_replace_all(xlab, '[ \\\\/]', ''), str_replace_all(ylab, '[ \\\\/]', ''), sep='_')
  plots_pfim[[title]] <<- list(x=x, y=y, xlab=xlab, ylab=ylab)
 }
 points <- function(...) {
   # dummy
 }\n", PFIM_tmp)
    writeLines(PFIM_tmp, PFIM_file)
    return(list(folder = temp_folder,
                stdin = out_file,
                model = model_file,
                PFIM  = PFIM_file,
                args  = args))
  }
