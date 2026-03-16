# R CMD CHECKS

## Purpose

The
[`r-cmd-check.yml`](https://github.com/pharmaverse/admiralci/blob/main/.github/workflows/r-cmd-check.yml)
workflow performs R CMD checks on the package across multiple operating
systems and the latest released R version. This ensures package
compatibility and quality.

## Inputs

- `error-on`: Input for the `error_on` parameter in
  [`rcmdcheck::rcmdcheck()`](http://r-lib.github.io/rcmdcheck/reference/rcmdcheck.md).

  *Default:* `note`.

## Jobs

### `R-CMD-check` Job

Runs R CMD checks in parallel on macOS, Windows, and Ubuntu using the
latest R release with latest packages installed that are listed in the
`Imports` of `DESCRIPTION` file.

#### Steps

1.  Set up R environment using the
    [`setup_R`](https://github.com/pharmaverse/admiralci/blob/main/.github/actions/setup_R/action.yaml)
    action.
2.  Run R CMD check using the
    [`check-r-package`](https://github.com/r-lib/actions/tree/v2/check-r-package)
    action.

## Triggers

The workflow is triggered by:

- [`workflow_dispatch`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch)
- [`workflow_call`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_call)
