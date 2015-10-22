## function wrapper
library(PKPDsim)
load("model.Robj") # loads model object and parameters / regimen

form <- function (t, p, X) {
  reg <- new_regimen(amt = X, times=c(0), type="infusion", t_inf = 2)
  pars <- list(CL = p[1], V=p[2])
  y <- sim_ode(model,
               parameters = parameters_pkpdsim,
               regimen = regimen_pkpdsim,
               only_obs = TRUE,
               t_obs = t)$y
  return(y)
}
