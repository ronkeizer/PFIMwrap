# test
library(PFIMwrap)
pfim_install(local_file = "~/Downloads/PFIM4.0.zip")
library(PKPDsim)

setwd("~/git/PFIMwrap/tests")
mod <- new_ode_model(
  code ="
    dAdt[1] = -(CL/V) * A[1] + rate;
  ",
  obs = list(cmt = 1, scale= "V")
)
#mod <- pkbusulfanlt12kg::model("pk_busulfan_lt12kg")
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
#    graph.logical = TRUE,
#    graphsensi.logical = TRUE,
    previous.FIM = "fim_prior.txt",
    sig.interA = 1,
    sig.slopeA = 0.1
  ),
  model = mod,
  parameters = pars,
  regimen = reg
)
pfim_run (ini = ini) # default run
