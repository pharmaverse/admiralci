# Code Coverage

## Purpose

The [code-coverage
workflow](https://github.com/pharmaverse/admiralci/blob/main/.github/workflows/code-coverage.yml)
measures unit test coverage for the package and generates coverage
reports and badges.

## Inputs

- `r-version`: The version of R to use. Default: `'release'`. See
  [setup-r action
  inputs](https://github.com/r-lib/actions/tree/v2/setup-r).
- `skip-coverage-badges`: Skip code coverage badge creation. Default:
  `false`.

## Triggers

- [`workflow_dispatch`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch):
  Manual trigger, allows specifying inputs.
- [`workflow_call`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_call):
  Triggered by another workflow, allows specifying inputs.

## Jobs

### `coverage` Job

Runs code coverage tests, generates coverage reports, and outputs the
coverage percentage.

#### Conditions

Executed unless the latest commit message contains `[skip coverage]`.

#### Steps

- Set up R environment using
  [`setup_R`](https://github.com/pharmaverse/admiralci/blob/main/.github/actions/setup_R/action.yaml)
  action, installing [covr](https://covr.r-lib.org).
- Run coverage analysis with [covr](https://covr.r-lib.org):
  - Generate `coverage.xml`, `coverage.txt`, and `coverage-report.html`.
- Check for existence of coverage reports.
- Set coverage percentage as output.
- If coverage reports exist and event is a pull request:
  - Generate coverage summary report and badge using
    [`CodeCoverageSummary`](https://github.com/irongut/CodeCoverageSummary).
  - Upload coverage report artifact.
  - Add coverage summary as a pull request comment.

### `badge` Job

Generates a code coverage badge and commits it to the `badges` branch.

#### Conditions

Runs if `skip-coverage-badges` is not `true`, commit message does not
contain `[skip coverage]`, and branch is `main`.

#### Steps

- Checkout the `badges` branch.
- Generate badge SVG using
  [badge-action](https://github.com/emibcn/badge-action).
- Commit badge to the branch.
- Push badge updates.

## Other Resources

To enable badge creation, create an orphan `badges` branch in your
repository:

``` bash
git checkout --orphan badges
# Back up files
mv .git /tmp/.git-backup
# Remove everything else
rm -rf * .*
# Restore git files
mv /tmp/.git-backup .git
# Create a README file
echo "# Badges" > README.md
# Add, commit and push your new branch
git add . && git commit -m "Init badges" && git push origin badges
```
