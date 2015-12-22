#########################################################################
##					        		                                               ##
##				            INPUT FILE FOR PFIM 4.0                          ##
#########################################################################

project        <- "template"
file.model     <- "model.R"
output         <- "eval_out.r"
outputFIM      <- "FIM.txt"
FIM            <- "B" # F/I/B
previous.FIM   <- NULL
run            <- "EVAL"
graph.only     <- F    # To display only  graphs of models and/or sensitivity functions before computing the Fisher Information matrix
option         <- 1    # Block diagonal Fisher information matrix (option<-1) or complete Fisher information matrix (option<-2)
nr             <- 1    # Number of responses
modelform      <- "AF" # Model form: Differential equations (DE) or analytical form (AF)
dose.identical <- T
dose           <- c(50)
boundA         <- list(c(0,Inf)) #Vector of the times intervals of each expression
NUM            <- TRUE #Numerical derivatives  (Yes=T, No=F) #If 'Yes', specify the model function "form" in the model file #If 'No', specify the object "form" which is a vector of expressions in the model file
# FALSE (with pre-defined infusion model) doesn't work!!

parameters     <- c("Cl","V")
beta           <- c(0.89, 3.25)
beta.fixed     <- c(F, F)
n_occ          <- 1
Trand          <- 2 # Random effect model (1) = additive  (2) = exponential
omega          <- matrix(c(0.1, 0.05, 0.05, 0.1), nrow=2) #Diagonal Matrix of variance for inter-subject random effects:
gamma          <- diag(c(0.01, 0.01)) #Diagonal Matrix of variance for inter-occasion random effects:
sig.interA     <- 1    # Standard deviation of residual error (sig.inter+sig.slope*f)^2:
sig.slopeA     <- 0.1
protA          <- list(c(2, 4, 6, 8)) #List of the vectors of sampling times for each elementary design
subjects       <- c(1) #Vector of initial proportions or numbers of subjects for each elementary design
subjects.input <- 1 #Subjects input: (1) for number of subjects (2) for proportions of subjects

###################################################################
#                                                                 #
#                        Covariate model                          #
#                                                                 #
###################################################################

##########################################
# Covariates not changing with occasion  #
##########################################

covariate.model <- F # Add covariate to the model  (Yes==T No==F)
# covariate.name <- list(c("Sex")) #Vector of covariates

#Categories for each covariate (the first category is the reference)
#-----------------------------------------------------------------------
# covariate.category<-list(Sex=c("M","F"))

#Proportions of subjects in each category
#-------------------------------------------------------------------------
# covariate.proportions<-list(Sex=c(0.5,0.5))

#Parameter(s) associated with each covariate
#-------------------------------------------------------------------------
# parameter.associated<-list(Sex=c("V"))

# Values of covariate parameters in covariate model
# (values of parameters for all other categories than the reference category (for which beta=0)
# covariate is additive on parameter if additive random effect model (Trand=1)
# covariate is additive on log parameters if exponential random effect model (Trand=2)
#-----------------------------------------------------------------------
# beta.covariate <- list(Sex=list(c(log(1.5))))

#####################################
#Covariates changing with occasion  #
#####################################


#Add covariate to the model   (Yes==T No==F)
#---------------------------------------------------------------------------
# covariate_occ.model <- F

#Vector of covariates depending on the occasion
#---------------------------------------------------------------------
# covariate_occ.name <- list(  c("Treat") )

#Categories for each covariate (the first category is the reference)
#-----------------------------------------------------------------------
# covariate_occ.category <- list(  Treat=c("A","B") )

#Sequences of values of covariates at each occasion
#Specify as many values in each sequence as number of occasions (n_occ) for each covariate
#-------------------------------------------------------------------------------------------------------

# covariate_occ.sequence <- list(  Treat=list(c("A","B"),c("B","A"))  )

#Proportions of elementary designs corresponding to each sequence of covariate values
#Specify as many values of proportion as number of sequences defined in covariate_occ.sequence for each covariate
#-----------------------------------------------------------------------------------------------------------------
# covariate_occ.proportions <- list(  Treat=c(0.5,0.5)  )

#Parameter(s) associated with each covariate
#-------------------------------------------------------------------------
# parameter_occ.associated <- list(  Treat=c("Cl")  )

# Values of covariate parameters in covariate model
# (values of parameters for all other categories than the reference category (for which beta=0)
# covariate is additive on parameter if additive random effect model (Trand=1)
# covariate is additive on log parameters if exponential random effect model (Trand=2)
#-----------------------------------------------------------------------
# beta.covariate_occ<-list(  Treat=list(c(log(1.5)))  )


############ONLY FOR OPTIMISATION ###############################

identical.times <- T #Identical sampling times for each response # (only if you do not have sampling times==NULL)
algo.option<-"FW" #	"FW" for the Fedorov-Wynn algorithm "SIMP" for the Simplex algorithm

########################
#SIMPLEX SPECIFICATION #
########################

subjects.opt      <- T # Optimisation of the proportions of subjects: (Yes=T, No=F)
lowerA            <- c(0)  #Vector of lower and upper admissible sampling times
upperA            <- c(8)
delta.time        <- 2 # Minimum delay between two sampling times
iter.print        <- T
simplex.parameter <- 20
Max.iter          <- 5000
Rctol             <- 1e-6


#############################
#FEDOROV-WYNN SPECIFICATION #
#############################

nwindA            <- 1 #Number of sampling windows
nwindB            <- 1
sampwinA          <- list(c(3:24)) #List of vector of the allowed sampling times for each sampling window
sampwinB          <- list(c(3:24))
fixed.timesA      <- c() #Fixed times (times which will be in all evaluated protocols, corresponding to fixed constraints)
fixed.timesB      <- c()
nsampA            <- list(c(5)) #List of vector of allowed number of points to be taken from each sampling window
nsampB            <- list(c(5))
nmaxptsA          <- 5 #Maximum total number of sampling times per subject
nmaxptsB          <- 5
nminptsA          <- 5 #Minimum total number of sampling times per subject
nminptsB          <- 5


############## GRAPH SPECIFICATION OPTION ###############

graph.logical<-T
graphsensi.logical<-T
names.datax<-c("Time")
names.datay<-c("Concentration")
log.logical<-F
graph.infA<-c(0)
graph.supA<-c(24)
y.rangeA<-NULL # default range
#y.rangeA<-c(1,10)
