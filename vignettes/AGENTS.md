# Guidance for Agents: Vignettes Folder

This document provides guidance for contributors and agents working with the
`.Rmd` files in the `vignettes` folder of the admiralci repository.

## Purpose

The `vignettes` folder contains R Markdown (`.Rmd`) files that serve as
documentation, tutorials, and guides for users and developers. These vignettes
are rendered into articles for the package website via pkgdown.

## Structure

- Each `.Rmd` file should have a YAML header specifying the title and output format.
- Content should be clear, concise, and focused on a single topic or workflow.
- Include references, links, and images as needed to enhance understanding.
- For each workflow in the `.github/workflows` directory, there should be a
  corresponding vignette explaining its purpose and usage. The `.Rmd` file
  should be named as the workflow it describes (e.g., `check-r-tags.Rmd` for the
  `check-r-tags.yml` workflow).
- For each GitHub Action in the `.github/actions` directory, there should be a
  corresponding vignette explaining its purpose and usage. The `.Rmd` file
  should be named as the action it describes (e.g., `setup_R.Rmd` for the
  `setup_R/action.yaml` action).

## Naming Conventions

- File names should be descriptive.
- Avoid spaces and special characters in file names.

## Content Guidelines

- Begin with a brief introduction explaining the purpose of the vignette.
- Use headings to organize content logically. Use consistent headings across
  vignettes for similar sections (e.g., "Purpose", "Inputs", "Steps",
  "Triggers").
- Where relevant, link to other vignettes, documentation, or external resources.
- For each workflow or action, include the following in this order:
  - A description of its purpose. Use heading "Purpose".
  - A list of inputs and their defaults. Use heading "Inputs". Each input should
    be an item of a list like
    ```
    - `<input name>`: `<input description>`.
    
      *Default:* `<default value>`.
    ```
    If there are no inputs, state that explicitly.
  - Optionally a section which describe any other resources affecting the
    workflow, e.g., `staged_dependencies.yaml` for the `setup_r` action. Use
    heading "Other Resources". If there are no other resources, omit this
    section.
  - The jobs defined in the workflow or action. Use heading "Jobs". For each job
    (heading "`<job name>` Job", e.g., "`check` Job" for the `check` job)
    display:
    - a short description, without adding a title like "Description:".
    - if it is executed conditionally, the condition when it is executed. Use
      heading "Conditions".
    - the steps performed. If other actions (internal or external) are used,
    link to their vignettes or documentation. Use heading "Steps". Use an
    ordered list for the steps.
  - A list of events triggering the workflow (for workflows). Use heading
    "Triggers".
- When stating github action keywords or events like `workflow_dispatch, link
  them to the github action documentation.
- Do not mention this file in vignettes.
- If stating the source file of a workflow or action, link to the file in the
  repository. The URL of the repository is
  `https://github.com/pharmaverse/admiralci/blob/main/`, e.g.,
  `.github/wortkflows/links.yml` should be linked to
  `https://github.com/pharmaverse/admiralci/blob/main/.github/workflows/links.yml`.
- Don't add references regarding how to create vignettes like `rmarkdown` or
  `pkgdown`.

## Updating Vignettes

- Update vignettes when workflows, actions, or package functionality changes.
- Ensure examples are current and reproducible.
- Review for clarity and accuracy before submitting changes.

## Special Files

- `glossary.Rmd`: Lists and explains keywords used in GitHub Actions and
  workflows. Use a list like
  ```
  - `<keyword>`: `<description>`.
  ```
  The keyword should be linked to the GitHub documentation.
  The keyword should be ordered alphabetically.
- `AGENTS.md`: This guidance document.
- Other `.Rmd` files: Cover specific workflows, checks, or features.