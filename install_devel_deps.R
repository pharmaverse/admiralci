# Read the dependencies from the CSV file
dependencies <- read.csv("Dependencies.list.of.docker.image.admiralci-latest.csv",
  stringsAsFactors = FALSE)

# remove built-in deps from the list
dependencies <- dependencies %>% filter(LibPath != "/usr/local/lib/R/library")

# Loop through the dependencies and reinstall packages with specific versions
for (i in seq_len(nrow(dependencies))) {
  dep_name <- dependencies[i, "Package"]
  dep_version <- dependencies[i, "Version"]
  version_parts <- strsplit(dep_version, "\\.")[[1]]
  if (length(version_parts) == 4) {
    print(sprintf("skipping installation of dep %s", dep_name))
  } else {
    print(sprintf("install dependency %s - version %s", dep_name, dep_version))
    devtools::install_version(dep_name, version = dep_version, repos = "https://cran.r-project.org", force=TRUE, upgrade="always")
  }
}