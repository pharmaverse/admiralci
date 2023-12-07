# Read the dependencies from the CSV file
dependencies <- read.csv("deps.csv", stringsAsFactors = FALSE)

# Loop through the dependencies and reinstall packages with specific versions
for (i in seq_len(nrow(dependencies))) {
  dep_name <- dependencies[i, "Package"]
  dep_version <- dependencies[i, "Version"]
  devtools::install_version(dep_name, version = dep_version, repos = "")
}

# TODO: del : check diff between renv.lock and deps.csv
# library(diffdf)
# library(jsonlite)

# # Read deps.csv file
# deps_data <- read.csv("deps.csv", stringsAsFactors = FALSE)

# # Read renv.lock file
# renv_lock <- jsonlite::fromJSON("renv.lock")

# # Extract dependencies from renv.lock
# renv_deps <- renv_lock$Packages
# renv_deps <- names(renv_deps)

# # Create data frames for comparison
# deps_df <- as.data.frame(deps_data[c("Package")])
# renv_deps_df <- as.data.frame(renv_deps)
# colnames(renv_deps_df)[colnames(renv_deps_df) == "renv_deps"] <- "Packages"

# # Find differences using diffdf
# diff_result <- not_in_deps_data <- setdiff(renv_deps_df$Package, deps_df$Package)

# # Print the differences
# cat("Dependencies in renv.lock but not in deps.csv:\n")
# print(diff_result$right_only)