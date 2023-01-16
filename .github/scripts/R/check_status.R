# Install packages (find another way to install it on the docker container..?)
install.packages("optparse")
library(dplyr)
library(rvest)
library(stringr)
library(digest)

# check if needed : package name and working dir path as input arguments :
library(optparse)
option_list <- list(
  make_option(c("-s", "--status_types"), type = "character", default = "ERROR,WARN",
            help = "status types (comma separated list, for exemple ERROR,WARN,NOTE",
            metavar = "character")
)

#make_option(c("-w", "--working_dir_path"), type="character", default=NULL,
#            help="working dir", metavar="character"),
#make_option(c("-p", "--package_name"), type="character", default=NULL,
#            help="Current package name", metavar="character")

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

parse_errors <- function(url) {
    return(
        tryCatch(url %>%  read_html() %>% html_text(), error = function(e) "URL Not Found")
    )
}

pkg <- paste(desc::desc_get(keys = "Package"))
pkg <- "Brundle" # TODO: remove it after test
url <- sprintf("https://cran.r-project.org/web/checks/check_results_%s.html", pkg)

if (!httr::http_error(url)) {

    # Get input status
    status_types <- opt$status_types
    statuses <- unlist(strsplit(status_types, split = ","))

    # Parse html table into dataframe
    checks <- url %>%
    read_html() %>%
    html_element("table") %>%
    html_table()

    # filter statuses and get their details links (and convert it to md5 unique code)
    errors <- filter(checks, Status %in% statuses)

    # If errors table is empty: just get out !
    if (dim(errors)[1] == 0) {
        print(
            sprintf("None of this status found in the CRAN table. (status=%s)", status_types)
            )
    } else {
        # Build each step links
        errors$CheckLinks <- str_c("https://www.r-project.org/nosvn/R.check/",
        errors$Flavor, "/", pkg, "-00check.html")
        errors$InstallLinks <- str_c("https://www.r-project.org/nosvn/R.check/",
        errors$Flavor, "/", pkg, "-00install.html")
        errors$BuildLinks <- str_c("https://www.r-project.org/nosvn/R.check/",
        errors$Flavor, "/", pkg, "-00build.html")

        # Get details as text for each step
        errors$CheckDetails <- lapply(errors$CheckLinks, FUN = parse_errors)
        errors$InstallDetails <- lapply(errors$InstallLinks, FUN = parse_errors)
        errors$BuildDetails <- lapply(errors$BuildLinks, FUN = parse_errors)

        # Create md5 codes for each step
        errors$CheckId <- lapply(errors$CheckDetails, digest)
        errors$InstallId <- lapply(errors$InstallDetails, digest)
        errors$BuildId <- lapply(errors$BuildDetails, digest)

        # Unlist results
        errors$CheckId <- unlist(errors$CheckId)
        errors$InstallId <- unlist(errors$InstallId)
        errors$BuildId <- unlist(errors$BuildId)

        # Alphanumeric order on Flavor (for cran status comparison)
        errors <- errors[order(errors$Flavor),]

        # Save into CSV:
        errors %>% select(Flavor, CheckId, InstallId, BuildId) %>% 
        write.csv("cran_errors.csv", row.names = FALSE)
        cran_status <- function(x) {
            cat(x, file = "cran-status.md", append = TRUE, sep = "\n")
        }
        if (any(checks$Status %in% statuses)) {
            cran_status(sprintf(
            "CRAN checks for %s resulted in one or more (%s)s:\n\n",
            pkg,
            status_types
            ))
            cran_status("\nSee the table below for a summary of the checks run by CRAN:\n\n")
            cran_status(knitr::kable(checks))
            cran_status(sprintf(
                "\n\nAll details and logs are available here: %s", url
            ))
            print("❌ One or more CRAN checks resulted in an invalid status ❌")
            }
    }
} else {
    print(paste("ERROR ACCESSING URL=", url))
}

# Questions Dinakar: R: way to exit without errors ? access external workflow repo files ?