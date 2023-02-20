#' @keywords internal
"_PACKAGE"

#' onLoad function
#'
#' This function is called automatically during package loading.
#'
#' @param libname lib name
#' @param pkgname package name
#' @noRd
.onLoad <- function(libname, pkgname) { # nolint

  # Tweak page with special custom hook.
  setHook("UserHook::admiralci::tweak_page", function(...) {
    html <- ..1

    links <- xml2::xml_find_all(html, ".//a")
    if (length(links) == 0)
      return(invisible())

    hrefs <- xml2::xml_attr(links, "href")
    needs_tweak <- grepl("\\.yml$", hrefs) & xml2::url_parse(hrefs)$scheme == ""

    fix_links <- function(x) {
      x <- gsub("^./", "", x)
      x <- paste0("https://github.com/pharmaverse/admiralci/blob/HEAD/", x)
    }

    if (any(needs_tweak)) {
      purrr::walk2(
        links[needs_tweak],
        fix_links(hrefs[needs_tweak]),
        xml2::xml_set_attr,
        attr = "href"
      )
    }

    invisible()
  })

}
