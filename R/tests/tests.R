# test
setwd("~/git/PFIMwrap/R/tests")
library(PFIMwrap)
pfim_install(local_file = "~/Downloads/PFIM4.0.zip")
library(PKPDsim)
library(pkbusulfanlt12kg)

mod <- pkbusulfanlt12kg::model("pk_busulfan_lt12kg")
reg <- new_regimen(amt = 8, n=1, type='infusion', t_inf = 2)
covs <- list(WT = new_covariate(value = 4.5))
pars <- list(CL = 0.89, V = 3.15)
t <- c(2, 4, 6, 8)

ini <- pfim_define(
  args = list(
    dose = 50,
    parameters = c("CL", "V"),
    beta = c(pars$CL, pars$V),
    protA = list(c(2, 4, 6, 8)),
    graph.logical = TRUE,
    graphsensi.logical = TRUE,
    sig.interA = 48.6,
    sig.slopeA = 0.0855
  ),
  template_file = "~/projects/busulfan_od_neo/pfim/busulfan/eval_2.R",
  model = mod,
  parameters = pars,
  regimen = reg
)

pfim_run (ini = ini) # default run
