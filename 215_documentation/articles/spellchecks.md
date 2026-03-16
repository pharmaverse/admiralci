# Spellchecks

## Purpose

The
[Spelling](https://github.com/pharmaverse/admiralci/blob/main/.github/workflows/spellcheck.yml)
workflow checks spelling in documentation files within the repository.

## Inputs

- `r-version`: The version of R to use. The value is passed to the
  [r-lib/setup-r](https://github.com/r-lib/actions/tree/v2/setup-r)
  action (see its documentation for permitted values).

  *Default:* `release`.

- `exclude`: List of paths to exclude (comma-separated list).

  *Default:* `""`.

## Other Resources

Misspelled words can be ignored using the `inst/WORDLIST` file. Update
it automatically with
[`spelling::update_wordlist()`](https://docs.ropensci.org/spelling//reference/wordlist.html).

## Jobs

### `spellcheck` Job

Runs spellcheck on R files.

#### Conditions

Executed unless the commit message contains `[skip spellcheck]`.

#### Steps

1.  Set up R environment using the
    [`setup_R`](https://github.com/pharmaverse/admiralci/blob/main/.github/actions/setup_R/action.yaml)
    action.
2.  Run
    [`insightsengineering/r-spellcheck-action`](https://github.com/insightsengineering/r-spellcheck-action)
    to check spelling, using the specified inputs.

## Triggers

- [`workflow_dispatch`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch):
  Manual trigger with optional inputs.
- [`workflow_call`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_call):
  Invoked by other workflows.
- [`pull_request`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#pull_request):
  On pull requests to the `main` branch.
