#!/usr/bin/env bash
echo "${INPUT_STATUS-TYPES}"
Rscript /app/check-status.R --status_types "${INPUT_STATUS-TYPES}"