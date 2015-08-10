# Introduction

This R package is a wrapper around PFIM. The PFIM software is a widely-used tool for optimal design and is made available as a collection of R scripts (not an R-package). While the authors do provide ample documentation and examples, the software lacks an easy-to-use interface in R, and requires the user to create and adapt several custom script to evaluate an optimal design. This package attempts to make this easier by providing a structured set of functions that in turn create the required PFIM scripts and their input. 

## To be added soon:
In addition, `PFIMwrap` also makes it easier to use models defined by ordinary differential equations, by providing a link with the `PKPDsim` package which allows much faster numerical integration than `deSolve`. PFRIMwrap also provides some additional plotting features, using `ggplot` instead of the base plotting library.

# How to use

## Install PFIMwrap

    devtools::install_github("ronkeizer/PFIMwrap")

## Install PFIM

The following command will download PFIM from the INSERM website and install it into PFIMwrap's installation folder

    # grab from INSERM website
    pfim_install() 
    
    # or install from local zip file
    pfim_install(local_file = "~/Downloads/PFIM4.0.zip")

## Using PFIMwrap

Define settings:

    # use all default settings
    ini <- pfim_define() 

Run PFIM:
    
    pfim_run (ini = ini) # default run

** More elaborate examples will follow soon. **

# license

MIT open source license.

Note that this package does not include the PFIM software itself, but does contain a function to download and install PFIM from the INSERM website.
