FROM rocker/tidyverse:4.1.2

# Copy scripts
COPY check-status.R /check-status.R
COPY entrypoint.sh /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["./entrypoint.sh"]