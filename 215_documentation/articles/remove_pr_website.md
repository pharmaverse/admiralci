# remove_pr_website

## Purpose

Deletes the documentation website for a pull request when the pull
request is closed. Used with the
[`pkgdown`](https:/pharmaverse.github.io/admiralci/215_documentation/articles/pkgdown.md)
workflow, which generates and deploys documentation to a subfolder of
the `gh-pages` branch.

[Source
file](https://github.com/pharmaverse/admiralci/blob/main/.github/workflows/remove_pr_website.yml)

## Inputs

None

## Jobs

### `delete-subfolder` Job

Removes the subfolder in the `gh-pages` branch named after the merged
branch, if present.

#### Conditions

Executed only if the pull request event action is
[`closed`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#pull_request).

#### Steps

1.  Checkout the repository (default branch) using
    [`actions/checkout`](https://github.com/actions/checkout).
2.  Ensure the `gh-pages` branch exists and check it out.
3.  Remove the subfolder named after the merged branch (if present).
    - If the subfolder exists, remove it, commit, and push changes.
    - If not, exit without changes.

## Triggers

- [`workflow_call`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_call):
  Allows this workflow to be called by other workflows.
