FROM rocker/tidyverse:4.1.2

WORKDIR /app

# Copy scripts
COPY --chmod=0755 check-status.R entrypoint.sh /app/

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]