FROM rocker/tidyverse:4.2.2

WORKDIR /app

# Copy scripts
COPY check-status.R entrypoint.sh /app/

# Make the scripts executable
RUN chmod +x /app/*

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
