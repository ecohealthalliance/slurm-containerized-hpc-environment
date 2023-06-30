#!/bin/bash

set -e
set -x


## Install R packages that need compilation
install2.r --error --skipinstalled \
  bibtex \
  brms \
  fasterize \
  fst \
  greta \
  hexbin \
  jqr \
  officer \
  packrat \
  profmem \
  profvis \
  RcppArmadillo \
  RcppGSL \
  RcppZiggurat \
  reticulate \
  Rglpk \
  rjags \
  RJSONIO \
  Rsymphony \
  runjags \
  rstanarm \
  rvg \
  shinystan \
  slam \
  tidymodels \
  vegan \
  vroom \
  zip
