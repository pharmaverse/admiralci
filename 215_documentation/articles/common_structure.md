# Common Structure

## Common Structure of the Workflows

All workflows should be triggered by the `workflow_call` event because
they are usually called by other repositories than
[admiralci](https://pharmaverse.github.io/admiralci). I.e., they should
start with:

    on:
      workflow_call:
        inputs:

See
[`common.yml.inactive`](https://github.com/pharmaverse/admiralci/blob/main/.github/workflows/common.yml.inactive)
for an example on how to call the
[admiralci](https://pharmaverse.github.io/admiralci) workflows from
other repositories.

In most workflows the first step is to setup the R environment using the
`setup_R` action. It checks out the repository, sets up the R
environment according to the specified R version, installs the necessary
dependencies, and the package itself. See [setup_R
documentation](https:/pharmaverse.github.io/admiralci/215_documentation/articles/setup_r.md)
for details.

### R-version Input

For most of the workflows, we need to select a specific R version.
That’s why most of the actions have a `r-version` input:

        inputs:
          r-version:
            description: "The version of R to use"
            default: "release"
            required: false
            type: string

By default, we have `r-version=release`, and users can also other
versions like `devel` and `oldrel` .

- `release` means we are using latest stable version of `R`.
- `oldrel` means we are using previous release of R (for example if
  current `release` is `4.4`, `oldrel` will be `4.3`).
- `devel` refers to the development version of R, which contains the
  latest changes and features that are still under development. This
  version is typically used by developers who want to test new features.
  The `devel` version may be less stable.

### Upstream Dependencies

For upstream dependencies the current development version will be
installed, except for releases and patch releases. The admiral packages
and their upstream dependencies are developed simultaneously and
released together. Using the development version of the upstream
dependencies ensures that the development version is in a good state for
the next release and that problems induced by changes in the upstream
dependencies are detected early.

The [admiral](https://pharmaverse.github.io/admiral/) package has the
following upstream dependencies:

- [pharmaversesdtm](https://pharmaverse.github.io/pharmaversesdtm/)
  (SDTM test data)
- [admiraldev](https://pharmaverse.github.io/admiraldev/) (utilities
  functions for the admiral package family)

The dependencies are referred inside the `staged_dependencies.yaml` file
in the root of the repository. The file is expected by the
[`setup_R`](https:/pharmaverse.github.io/admiralci/215_documentation/articles/setup_r.md)
action.
