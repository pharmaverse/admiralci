#!/usr/bin/env bash

printenv 

Rscript /app/check-status.R --status_types $1

# TODO: retry INPUT_status-types

# change underscore to dash