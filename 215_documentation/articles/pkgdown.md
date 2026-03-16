# Create Website (pkgdown)

## Purpose

Automates the generation and deployment of documentation for the R
package using [`pkgdown`](https://pkgdown.r-lib.org/). Supports
multi-version documentation and custom tweaks for pharmaverse packages.

The website is deployed to the `gh-pages` branch of the repository.

If triggered by a pull request, the website is stored in a subdirectory
named after the feature branch, and a comment with the website link is
posted on the PR. This is helpful for the review of the pull request.
The subdirectory should be removed after the PR is merged. This can be
done by the [`remove_pr_website`
workflow](https:/pharmaverse.github.io/admiralci/215_documentation/articles/remove_pr_website.md).
In the [`common.yml.inactive`
file](https://github.com/pharmaverse/admiralci/blob/main/.github/workflows/common.yml.inactive)
the PR website is created only if `[create website]` is in the PR title.

If multi-version documentation is enabled
(`skip-multiversion-docs: false`) and the workflow is triggered by a
push to a branch or tag (usually this happens when a pull request is
merged or a release is created), the website is stored in a subdirectory
named after the branch or tag.

Source:
[`.github/workflows/pkgdown.yml`](https://github.com/pharmaverse/admiralci/blob/main/.github/workflows/pkgdown.yml)

## Inputs

- `r-version`: The version of R to use. The value is passed to the
  [r-lib/setup-r](https://github.com/r-lib/actions/tree/v2/setup-r)
  action (see its documentation for permitted values).

  *Default:* `release`

- `install-package`: Should the package be installed?

  *Default:* `true`

- `skip-multiversion-docs`: Skip creation of multi-version docs.

  *Default:* `true` (workflow_dispatch), `false` (workflow_call)

- `insert-tweak-page-hook`: Customizes `pkgdown::tweak_page` to fix
  rdrr.io links.

  *Default:* `true`

- `multiversion-docs-landing-page`: Ref for multiversion docs landing
  page.

  *Default:* `main`

- `latest-tag-alt-name`: Alternate name for ‘latest-tag’ in multiversion
  docs.

  *Default:* `""`

- `branches-or-tags-to-list`: Regular expression for branches/tags
  listed under ‘Versions’ dropdown.

  *Default:*
  `^main$|^devel$|^pre-release$|^latest-tag$|^cran-release$|^develop$|^v([0-9]+\\.)?([0-9]+\\.)?([0-9]+)$`

- `GITHUB_PAT`: GitHub API access token (optional, for downstream
  ops/rendering).

## Jobs

### pkgdown Job

Generates and deploys documentation.

#### Conditions

Executed if the commit message does not contain `[skip docs]`.

#### Steps

1.  Setup R environment using
    [`setup_R`](https://github.com/pharmaverse/admiralci/blob/main/.github/actions/setup_R/action.yaml)
    action, installing `pkgdown`.
2.  Optionally add a script to fix `rdrr.io` links for pharmaverse
    packages if `insert-tweak-page-hook` is `true`.
3.  Publish documentation using
    [`pkgdown::deploy_to_branch()`](https://pkgdown.r-lib.org/reference/deploy_to_branch.html),
    optionally in a subdirectory for multi-version docs or pull
    requests.
4.  Determine website link for documentation.
5.  If triggered by a
    [`pull_request`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#pull_request),
    comment the website link on the PR.

### Multi-version docs Job

Deploys multi-version documentation.

#### Conditions

Executed if `skip-multiversion-docs` is `false` and commit message does
not contain `[skip docs]`.

#### Steps

1.  Checkout repository at `gh-pages` branch.
2.  Create and publish multi-version docs using
    [`r-pkgdown-multiversion`](https://github.com/insightsengineering/r-pkgdown-multiversion)
    action.

## Triggers

- [`workflow_dispatch`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch)
- [`workflow_call`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_call)

## Requirements

To enable website creation, create an orphan `gh-pages` branch in your
repository:

``` bash
git checkout --orphan gh-pages
# Remove everything (except .git)
git rm -rf .
# Create a README file
echo "# Orphan branch for website" > README.md
# Add, commit and push your new branch
git add README.md
git commit -m "Init gh-pages"
git push origin gh-pages
```
