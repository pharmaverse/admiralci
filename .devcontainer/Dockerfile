ARG VARIANT="4.0"
ARG RENV_VERSION=0.17.0
FROM ghcr.io/pharmaverse/admiralci-${VARIANT}:latest

RUN useradd -s /bin/bash -m rstudio \
    && usermod -a -G staff rstudio

# Install renv from GitHub.
ENV RENV_VERSION=$RENV_VERSION
RUN R -e "remotes::install_github('rstudio/renv', ref = Sys.getenv('RENV_VERSION'))"
