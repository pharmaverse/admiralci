test_that("Test tweak local url to absolute for yml file.", {
  html <- xml2::read_html('<a href="./file.yml"></a>')
  tweak_yml_url(html)
  links <- xml2::xml_find_all(html, ".//a")
  hrefs <- xml2::xml_attr(links, "href")
  expect_equal(xml2::url_parse(hrefs)$scheme, "https")
})

test_that("Do not tweak md url as yml.", {
  html <- xml2::read_html('<a href="./file.md"></a>')
  tweak_yml_url(html)
  links <- xml2::xml_find_all(html, ".//a")
  hrefs <- xml2::xml_attr(links, "href")
  expect_equal(xml2::url_parse(hrefs)$scheme, "")
})
