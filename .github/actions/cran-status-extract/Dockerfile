FROM rocker/tidyverse:4.1.2

WORKDIR /app

# Copy scripts
COPY check-status.R /app/check-status.R
COPY entrypoint.sh /app/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["./entrypoint.sh"]