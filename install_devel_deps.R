# Read the dependencies from the CSV file
dependencies <- read.csv("deps.csv", stringsAsFactors = FALSE)

# Loop through the dependencies and reinstall packages with specific versions
for (i in seq_len(nrow(dependencies))) {
  dep_name <- dependencies[i, "Package"]
  dep_version <- dependencies[i, "Version"]
  install.packages(dep_name, type = "source", repos = NULL, version = dep_version)
}
