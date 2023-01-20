FROM rocker/tidyverse:4.1.2

# Copy scripts
COPY check_status.R /check_status.R
COPY entrypoint.sh /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]