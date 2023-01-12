# RQ: faire juste un json avec mapping fichiers => md5 (que pour les erreurs)
library(dplyr)
library(rvest)
library(stringr)
library(digest)

# check if needed : package name and working dir path as input arguments :
#library("optparse")
#option_list = list(
#  make_option(c("-w", "--working_dir_path"), type="character", default=NULL, 
#              help="working dir", metavar="character"),
#    make_option(c("-p", "--package_name"), type="character", default=NULL, 
#              help="Current package name", metavar="character")
#); 
#opt_parser = OptionParser(option_list=option_list);
#opt = parse_args(opt_parser);


parseErrors <- function(url) {
    return(
        tryCatch(url %>%  read_html() %>% html_text(), error=function(e) "URL Not Found")
    )
}   

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
    errors$Details <- lapply(errors$Links, FUN=parseErrors)
    errors$Id <- lapply(errors$Details, digest)

    # Alphanumeric order on Flavor (for cran status comparison)
    errors <- errors[order(errors$Flavor),] 

    # Save into CSV: 
    errors %>% select(Flavor, Id) %>% write.csv('cran_errors.csv',row.names=FALSE)
            
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
        print("❌ One or more CRAN checks resulted in an invalid status ❌")
        }
}