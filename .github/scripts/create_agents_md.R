#!/usr/bin/env Rscript

#' Create AGENTS.md Files from admiraldev Vignettes
#'
#' Downloads the following admiraldev vignettes and writes them as AGENTS.md
#' context files that are picked up by AI coding assistants (GitHub Copilot,
#' Gemini, Claude, etc.):
#'
#'   - programming_strategy.Rmd
#'   - git_usage.Rmd
#'   - rcmd_issues.Rmd
#'   - unit_test_guidance.Rmd
#'
#' Files created:
#'   - AGENTS.md                      (root – Programming Strategy, Git, R CMD Check)
#'   - tests/testthat/AGENTS.md       (testthat dir – Unit Test Strategy, if it exists)
#'
#' Usage:
#'   Rscript create_agents_md.R [package_name]
#'
#' If package_name is omitted the script falls back to the repository name
#' derived from the GITHUB_REPOSITORY environment variable, then to "admiral".

suppressPackageStartupMessages(library(glue))

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

args         <- commandArgs(trailingOnly = TRUE)
package_name <- if (length(args) >= 1 && nchar(args[[1]]) > 0) {
  args[[1]]
} else if (nchar(Sys.getenv("GITHUB_REPOSITORY")) > 0) {
  # GITHUB_REPOSITORY is "owner/repo" – take the part after the slash
  sub(".*/", "", Sys.getenv("GITHUB_REPOSITORY"))
} else {
  "admiral"
}

project_root    <- if (file.exists(".git")) "." else ".."
agent_md_root   <- file.path(project_root, "AGENTS.md")
agent_md_tests  <- file.path(project_root, "tests", "testthat", "AGENTS.md")
has_testthat    <- dir.exists(file.path(project_root, "tests", "testthat"))

admiraldev_base <- "https://raw.githubusercontent.com/pharmaverse/admiraldev/main/vignettes"
admiraldev_docs <- "https://pharmaverse.github.io/admiraldev/articles"

cat(glue("Creating AGENTS.md files for package: {package_name}\n"))

# ---------------------------------------------------------------------------
# Download helpers
# ---------------------------------------------------------------------------

#' Attempt to download a text file from `download_url` using several fallback methods.
#' Returns a character vector of lines, or NULL on failure.
try_download <- function(download_url, description) {
  # Method 1 ── readLines via connection
  result <- tryCatch({
    con <- base::url(download_url, open = "rt")
    on.exit(try(close(con), silent = TRUE))
    lines <- readLines(con, warn = FALSE)
    close(con); on.exit()
    if (length(lines) > 10) {
      cat(glue("  ✓ {description} (readLines, {length(lines)} lines)\n"))
      return(lines)
    }
    NULL
  }, error = function(e) NULL)
  if (!is.null(result)) return(result)

  # Method 2 ── download.file
  result <- tryCatch({
    tmp <- tempfile(fileext = ".Rmd")
    on.exit(unlink(tmp))
    if (download.file(download_url, tmp, quiet = TRUE, method = "auto", timeout = 30) == 0 &&
        file.exists(tmp) && file.size(tmp) > 100) {
      lines <- readLines(tmp, warn = FALSE)
      if (length(lines) > 10) {
        cat(glue("  ✓ {description} (download.file, {length(lines)} lines)\n"))
        return(lines)
      }
    }
    NULL
  }, error = function(e) NULL)
  if (!is.null(result)) return(result)

  # Method 3 ── curl (if available on PATH)
  if (nchar(Sys.which("curl")) > 0) {
    result <- tryCatch({
      tmp <- tempfile(fileext = ".Rmd")
      on.exit(unlink(tmp))
      ret <- system2("curl",
        c("-sSL", "--connect-timeout", "10", "--max-time", "30", "-o", tmp, download_url),
        stdout = FALSE, stderr = FALSE)
      if (ret == 0 && file.exists(tmp) && file.size(tmp) > 100) {
        lines <- readLines(tmp, warn = FALSE)
        if (length(lines) > 10) {
          cat(glue("  ✓ {description} (curl, {length(lines)} lines)\n"))
          return(lines)
        }
      }
      NULL
    }, error = function(e) NULL)
    if (!is.null(result)) return(result)
  }

  cat(glue("  ✗ All download methods failed for {description}\n"))
  NULL
}

#' Replace relative vignette links with absolute admiraldev URLs.
fix_relative_links <- function(lines) {
  if (is.null(lines)) return(lines)
  lines <- gsub(
    "\\(([a-z_]+\\.html)(#[^)]*)?\\)",
    paste0("(", admiraldev_docs, "/\\1\\2)"),
    lines
  )
  lines <- gsub(
    "\\(\\.\\.(/(reference/[^)]+))\\)",
    "(https://pharmaverse.github.io/admiral\\1)",
    lines
  )
  lines
}

# ---------------------------------------------------------------------------
# Download vignettes
# ---------------------------------------------------------------------------

cat("Downloading admiraldev vignettes...\n")

programming_strategy <- try_download(
  file.path(admiraldev_base, "programming_strategy.Rmd"),
  "programming_strategy.Rmd"
)

git_usage <- try_download(
  file.path(admiraldev_base, "git_usage.Rmd"),
  "git_usage.Rmd"
)

rcmd_issues <- try_download(
  file.path(admiraldev_base, "rcmd_issues.Rmd"),
  "rcmd_issues.Rmd"
)

unit_test_guidance <- try_download(
  file.path(admiraldev_base, "unit_test_guidance.Rmd"),
  "unit_test_guidance.Rmd"
)

n_ok <- sum(
  !is.null(programming_strategy),
  !is.null(git_usage),
  !is.null(rcmd_issues),
  !is.null(unit_test_guidance)
)
cat(glue("Downloaded {n_ok}/4 admiraldev vignettes\n\n"))

# ---------------------------------------------------------------------------
# Root AGENTS.md  (Programming Strategy)
# ---------------------------------------------------------------------------

write_root_agents_md <- function() {
  header <- c(
    glue("# {package_name} Development Guidelines for AI Assistants"),
    "",
    glue(
      "This file provides context for AI coding assistants (GitHub Copilot, ",
      "Gemini, Claude, Cursor, etc.) about {package_name} ecosystem standards ",
      "and best practices."
    ),
    "",
    "**Auto-generated** – see commit history for the last update date.",
    "**Sources:** [`programming_strategy.Rmd`](https://pharmaverse.github.io/admiraldev/articles/programming_strategy.html), [`git_usage.Rmd`](https://pharmaverse.github.io/admiraldev/articles/git_usage.html), [`rcmd_issues.Rmd`](https://pharmaverse.github.io/admiraldev/articles/rcmd_issues.html)",
    "**Update workflow:** `create-agents-md.yml` (callable from any admiral ecosystem repo)",
    "",
    "---",
    "",
    "## AI Verification",
    "",
    glue(
      "> **Verification:** If you have read this file, include the comment  \n",
      "> `# {package_name} guidelines loaded` on the first line of every **new** R file  \n",
      "> you create in this repository. This confirms you are following admiral-specific conventions.  \n",
      "> When working inside `tests/testthat/`, also read `tests/testthat/AGENTS.md` and  \n",
      "> include the comment `# {package_name} test guidelines loaded` at the top of every new test file."
    ),
    "",
    "---",
    ""
  )

  body <- if (!is.null(programming_strategy)) {
    ps_section <- c(
      "# Admiral Programming Strategy",
      "",
      glue("**Source:** [{admiraldev_docs}/programming_strategy.html]({admiraldev_docs}/programming_strategy.html)"),
      "",
      fix_relative_links(programming_strategy),
      "",
      "---",
      ""
    )
    git_section <- if (!is.null(git_usage)) {
      c(
        "# Guidance for git and GitHub Usage",
        "",
        glue("**Source:** [{admiraldev_docs}/git_usage.html]({admiraldev_docs}/git_usage.html)"),
        "",
        fix_relative_links(git_usage),
        "",
        "---",
        ""
      )
    } else character(0)
    rcmd_section <- if (!is.null(rcmd_issues)) {
      c(
        "# Common R CMD Check Issues",
        "",
        glue("**Source:** [{admiraldev_docs}/rcmd_issues.html]({admiraldev_docs}/rcmd_issues.html)"),
        "",
        fix_relative_links(rcmd_issues),
        "",
        "---",
        ""
      )
    } else character(0)
    c(ps_section, git_section, rcmd_section)
  } else {
    c(
      "# Admiral Programming Strategy",
      "",
      glue(
        "> **Note:** Could not download the latest admiraldev vignette at workflow run time.  \n",
        "> Full documentation: [{admiraldev_docs}/programming_strategy.html]({admiraldev_docs}/programming_strategy.html)"
      ),
      "",
      "## Function Design Principles",
      "",
      "- **Modularity** – Keep logic in small, single-purpose functions.",
      "- **Avoid copy-paste** – Extract shared logic into helper functions.",
      "- **Meaningful errors** – Use `assert_*` helpers with clear messages.",
      "- **Flexibility** – Support optional arguments; never reduce usability.",
      "",
      "## Function Naming Convention",
      "",
      "Names follow `verb_object_detail` in snake_case:",
      "",
      "| Prefix | Purpose |",
      "| --- | --- |",
      "| `derive_var_*` | Add a single variable to a dataset |",
      "| `derive_vars_*` | Add multiple variables |",
      "| `derive_param_*` | Add a parameter (long format) |",
      "| `compute_*` | Vectorised computation; returns a vector |",
      "| `assert_*` | Input validation (error on failure) |",
      "| `warn_*` | Input validation (warning on failure) |",
      "| `filter_*` | Filter observations |",
      "| `get_*` | Retrieve metadata / mappings |",
      "",
      "---",
      ""
    )
  }

  footer <- c(
    "## Unit Testing Guidelines",
    "",
    glue("For unit testing context see `tests/testthat/AGENTS.md` (generated from [{admiraldev_docs}/unit_test_guidance.html]({admiraldev_docs}/unit_test_guidance.html))."),
    "",
    "## Package Documentation",
    "",
    "After adding or modifying any roxygen2 comments (`#'`) in R source files,",
    "regenerate the documentation before committing:",
    "",
    "```r",
    "devtools::document()",
    "```",
    "",
    "This updates all `.Rd` files in `man/` and the `NAMESPACE` file. Always",
    "run it when you:",
    "",
    "- Add or rename a `@param`, `@return`, `@export`, or `@importFrom` tag",
    "- Add a new exported function",
    "- Change a function signature",
    "",
    "R CMD check will issue a WARNING for undocumented arguments or a mismatch",
    "between the code and docs if `devtools::document()` has not been run.",
    "",
    "## Key References",
    "",
    glue("- [Programming Strategy]({admiraldev_docs}/programming_strategy.html)"),
    glue("- [Git and GitHub Usage]({admiraldev_docs}/git_usage.html)"),
    glue("- [Common R CMD Check Issues]({admiraldev_docs}/rcmd_issues.html)"),
    glue("- [Unit Test Guidance]({admiraldev_docs}/unit_test_guidance.html)"),
    "- [Admiral Website](https://pharmaverse.github.io/admiral/)",
    "- [admiraldev Website](https://pharmaverse.github.io/admiraldev/)",
    "",
    "---",
    "",
    "*Auto-generated by `pharmaverse/admiralci` – `create-agents-md.yml`*"
  )

  writeLines(c(header, body, footer), agent_md_root)
  cat(glue("✓ Written: {agent_md_root}\n"))
}

# ---------------------------------------------------------------------------
# tests/testthat/AGENTS.md  (Unit Test Strategy)
# ---------------------------------------------------------------------------

write_tests_agents_md <- function() {
  header <- c(
    glue("# {package_name} Unit Testing Guidelines for AI Assistants"),
    "",
    glue(
      "Context for AI assistants when working with {package_name} unit tests ",
      "inside `tests/testthat/`."
    ),
    "",
    "**Auto-generated** – see commit history for the last update date.",
    glue("**Source:** [`admiraldev/vignettes/unit_test_guidance.Rmd`]({admiraldev_docs}/unit_test_guidance.html)"),
    "",
    "## AI Verification",
    "",
    glue(
      "> **Verification:** If you have read this file, include the comment  \n",
      "> `# {package_name} test guidelines loaded` on the first line of every **new** test file  \n",
      "> you create in `tests/testthat/`. This confirms you are following admiral-specific testing conventions."
    ),
    "",
    "---",
    ""
  )

  body <- if (!is.null(unit_test_guidance)) {
    c(
      "# Admiral Unit Test Guidance",
      "",
      glue("**Source:** [{admiraldev_docs}/unit_test_guidance.html]({admiraldev_docs}/unit_test_guidance.html)"),
      "",
      fix_relative_links(unit_test_guidance),
      "",
      "---",
      ""
    )
  } else {
    c(
      "# Admiral Unit Testing Guidelines",
      "",
      glue(
        "> **Note:** Could not download the latest admiraldev vignette at workflow run time.  \n",
        "> Full documentation: [{admiraldev_docs}/unit_test_guidance.html]({admiraldev_docs}/unit_test_guidance.html)"
      ),
      "",
      "## Test File Organisation",
      "",
      "- One test file per exported function, e.g. `test-derive_var_example.R`.",
      "- Place helpers / shared test data in `helper-*.R` files.",
      "- Keep tests self-contained – avoid relying on external state.",
      "",
      "## Required Test Scenarios",
      "",
      "1. **Happy path** – basic functionality with typical inputs.",
      "2. **Error conditions** – invalid inputs trigger informative errors.",
      "3. **Edge cases** – empty data frames, `NA` values, boundary conditions.",
      "4. **Argument validation** – every parameter is properly validated.",
      "5. **Output structure** – correct column names, types, and ungrouped result.",
      "",
      "## Test Data Best Practices",
      "",
      "- Build minimal datasets with `tibble::tribble()`.",
      "- Always verify the result is ungrouped:",
      "  ```r",
      "  expect_false(is.grouped_df(result))",
      "  ```",
      "- Test error messages with `expect_error(..., regexp = \"...\", fixed = TRUE)`.",
      "- Target ≥ 80 % line coverage.",
      "",
      "---",
      ""
    )
  }

  footer <- c(
    glue("*For complete guidance: [{admiraldev_docs}/unit_test_guidance.html]({admiraldev_docs}/unit_test_guidance.html)*"),
    "",
    "---",
    "",
    "*Auto-generated by `pharmaverse/admiralci` – `create-agents-md.yml`*"
  )

  writeLines(c(header, body, footer), agent_md_tests)
  cat(glue("✓ Written: {agent_md_tests}\n"))
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

cat("Writing AGENTS.md files...\n")
write_root_agents_md()

if (has_testthat) {
  write_tests_agents_md()
} else {
  cat(glue("ℹ  Skipping {agent_md_tests} – directory not found\n"))
}

cat(glue(
  "\n🎉 Done! Created AGENTS.md context files for {package_name}:\n",
  "   📄 {agent_md_root}\n",
  if (has_testthat) glue("   📄 {agent_md_tests}\n") else "",
  "\nAI assistants in this repo will now follow {package_name}-specific conventions.\n"
))
