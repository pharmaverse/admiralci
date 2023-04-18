# Pre-built Dev Container Image for R. More info: https://github.com/rocker-org/devcontainer-images/pkgs/container/devcontainer%2Ftidyverse
# Available R version: 4, 4.2, 4.1, 4.0,
ARG ROCKER_VERSION="r-ver"
ARG VARIANT="4.0"
ARG RENV_VERSION=0.17.0
FROM ghcr.io/rocker-org/devcontainer/${ROCKER_VERSION}:${VARIANT}

# Install renv from GitHub.
ENV RENV_VERSION=$RENV_VERSION
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"