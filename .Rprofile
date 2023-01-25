if (Sys.getenv("GITHUB_ACTIONS") == "" || (Sys.getenv("GITHUB_ACTIONS") == "true" && getRversion()$major == 3 && getRversion()$minor == 6)) {
  source("renv/activate.R")
} else {
  options(repos = c(CRAN = "https://cran.rstudio.com"))
}

.get_dependencies <- function(project_dir) {
  admdev_loc <- find.package("admiraldev", lib.loc = .libPaths(), quiet = TRUE)
  adm_dev_suggests <- renv:::renv_dependencies_discover_description(admdev_loc, fields = "Suggests")
  suggests_packages <- renv:::renv_dependencies_discover_description(project_dir, fields = "Suggests")

  packages <- names(
    renv:::renv_package_dependencies(
      unique(c(
        project_dir,
        adm_dev_suggests[["Package"]],
        suggests_packages[["Package"]]
      ))
    )
  )
  packages[!(packages %in% c("admiral", "admiraldev", "admiralci", "admiral.test"))]
}

options(renv.snapshot.filter = .get_dependencies)
