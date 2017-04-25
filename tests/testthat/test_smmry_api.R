context("Tests of the SMMRY api function")

lorem_ipsum <- "Lorem ipsum dolor sit amet, consetetur 
                sadipscing elitr, sed diam nonumy eirmod 
                tempor invidunt ut labore et dolore magna 
                aliquyam erat, sed diam voluptua. At vero 
                eos et accusam et justo duo dolores et ea 
                rebum. Stet clita kasd gubergren, no sea 
                takimata sanctus est Lorem ipsum dolor sit 
                amet. Lorem ipsum dolor sit amet, consetetur 
                sadipscing elitr, sed diam nonumy eirmod 
                tempor invidunt ut labore et dolore magna 
                aliquyam erat, sed diam voluptua. At vero 
                eos et accusam et justo duo dolores et ea 
                rebum. Stet clita kasd gubergren, no sea 
                takimata sanctus est Lorem ipsum dolor sit 
                amet."

testurl <- "https://en.wikipedia.org/wiki/Aregund"

ts <- smmry_api(x = lorem_ipsum)
tl <- smmry_api(x = lorem_ipsum, quick = FALSE)
us <- smmry_api(x = testurl)

test_that("smmry_api produces a string, if quick = TRUE", {
  testthat::skip_on_cran()
  expect_type(ts, "character")
  expect_type(us, "character")
})

test_that("smmry_api produces a smmry_api object, if quick = FALSE", {
  testthat::skip_on_cran()
  expect_s3_class(tl, "smmry_api")
})