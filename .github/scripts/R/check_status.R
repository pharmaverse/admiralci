# RQ: faire juste un json avec mapping fichiers => md5 (que pour les erreurs)
library(dplyr)
library(rvest)
library(stringr)
library(digest)

pkg <- paste(desc::desc_get(keys="Package"))
url <- sprintf("https://cran.r-project.org/web/checks/check_results_%s.html", pkg)
if (!httr::http_error(url)) {

    # Parse html table into dataframe
    checks <- url %>%
    read_html() %>%
    html_element("table") %>%
    html_table()

    # filter errors and get their details links (and convert it to md5 unique code)
    errors <- filter(checks, Status  == 'ERROR')
    errors$Links <- str_c('https://www.r-project.org/nosvn/R.check/', errors$Flavor, '/', pkg, 
    '-00install.html') # TODO: see dinakar if we should go through each detail URI (check, install steps etc)
    errors$Details <- lapply(errors$ErrorLinks, FUN=function(x) x %>%  read_html() %>% html_text())
    errors$Id <- lapply(errors$Details, digest)
    #FIXME: wrong json format..
    ids <- errors %>% select(Flavor, Id) %>% toJSON(dataframe = 'values', pretty = T) 
            
    status_types <- "${{ inputs.status-types }}"
    statuses <- unlist(strsplit(status_types, split = ","))
    cran_status <- function(x) {
        cat(x, file="cran-status.md", append=TRUE, sep="\n")
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
        stop("❌ One or more CRAN checks resulted in an invalid status ❌")
        }
}