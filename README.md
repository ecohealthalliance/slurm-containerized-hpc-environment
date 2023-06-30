# Reservoir: The EHA Data Science Container

A docker image for EHA's modeling and analytics work servers.

[![GitHub Actions CI](https://github.com/ecohealthalliance/reservoir/actions/workflows/build-containers.yml/badge.svg)](https://github.com/ecohealthalliance/reservoir/actions/workflows/build-containers.yml)
[![license](https://img.shields.io/badge/license-GPLv2-blue.svg)](https://opensource.org/licenses/GPL-2.0)



*reservoir* is an image built for the modeling and analytics workflow at [EcoHealth Alliance](ecohealthalliance.org).  It build on top of the [rocker project](https://www.rocker-project.org/) `geospatial` and GPU-enabled `ml-verse` images and adds commonly used other R packages, system tools, SSH and mosh access, and GPU-compiled tools.

Get the images at

```
docker pull ghcr.io/ecohealthalliance/reservoir:base # The primary image

docker pull ghcr.io/ecohealthalliance/reservoir:gpu # for hosts with GPUs
```

