# CRAN Status

## Purpose

Checks the CRAN status of an R package using the
[insightsEngineering/cran-status-action](https://github.com/insightsengineering/cran-status-monitor)
GitHub Action. Creates an issue if specified statuses (`'NOTE'`,
`'WARN'`, `'ERROR'`) are reported.

## Inputs

- `issue-assignees`: Whom should the issue be assigned to if errors are
  encountered in the CRAN status checks? Comma-separated GitHub
  usernames.

  *Default:* `""`

- `statuses`: Create an issue if one or more of the following statuses
  are reported on the check report. Allowed: `'NOTE'`, `'WARN'`,
  `'ERROR'`.

  *Default:* `"ERROR"`

- `path`: Path to the R package root, if not at the top level of the
  repository.

  *Default:* `"."`

## Jobs

### `cran-status` Job

Checks the CRAN status of the package. Runs on Ubuntu using the
`rocker/tidyverse:latest` Docker container.

#### Steps

- Runs
  [insightsEngineering/cran-status-action](https://github.com/insightsengineering/cran-status-monitor)
  with the specified inputs.

## Triggers

- [`workflow_dispatch`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch):
  Manual trigger, allows specifying inputs.
- [`workflow_call`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_call):
  Triggered by another workflow, passes inputs.

[Source file:
`.github/workflows/cran-status.yml`](https://github.com/pharmaverse/admiralci/blob/main/.github/workflows/cran-status.yml)
