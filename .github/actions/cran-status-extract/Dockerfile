FROM rocker/tidyverse:4.1.2

WORKDIR /app

# Copy scripts
COPY check-status.R /app/check-status.R
COPY entrypoint.sh /app/entrypoint.sh

RUN chmod 777 /app/check-status.R
RUN chmod 777 /app/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]