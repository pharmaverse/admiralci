# Build arguments
ARG R_VERSION=4.1.3
ARG STAGED_DEP_REF=devel

# R version managed by --build-arg at build cmd 

# Fetch base image
FROM rocker/rstudio:${R_VERSION}

ENV R_VERSION_MINOR=4.1


# Set image metadata
LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
    org.opencontainers.image.source="https://github.com/pharmaverse/admiralci" \  
    org.opencontainers.image.vendor="Insights Engineering - Pharmaverse" \
    org.opencontainers.image.authors="Insights Engineering - Pharmaverse"

# Set working directory
WORKDIR /workspace
COPY "renv/profiles/${R_VERSION_MINOR}/renv.lock" renv.lock

# Copy installation scripts TODO: see needed scripts for admiral
COPY --chmod=0755 ./.github/actions/push-docker-image/scripts ./scripts 

# Install sysdeps
RUN ./scripts/install_sysdeps.sh

# Install the remotes package, which allows us to install packages from GitHub.
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"

# Install renv from GitHub.
ENV RENV_VERSION 0.16.0  
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

# restore renv
ENV RENV_PATHS_LIBRARY renv/library
RUN R -s -e 'renv::restore()'

# Pre-install the devel branch of the admiraldev and admiral.test packages.
RUN ./scripts/install_github_dependencies.sh


ENTRYPOINT ["/init"]