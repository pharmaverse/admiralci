#!/usr/bin/env bash

printenv 

Rscript /app/check-status.R --status_types $1

# change underscore to dash