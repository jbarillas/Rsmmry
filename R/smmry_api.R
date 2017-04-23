#' test
#' 
#' test
#' 
#' @param x test
#' @param isurl test
#' @param length test
#' @param keywords test
#' @param quote_avoid test
#' @param breaks test
#'
#' @examples 
#' lorem_ipsum <- "Lorem ipsum dolor sit amet, consetetur 
#'          sadipscing elitr, sed diam nonumy eirmod 
#'          tempor invidunt ut labore et dolore magna 
#'          aliquyam erat, sed diam voluptua. At vero 
#'          eos et accusam et justo duo dolores et ea 
#'          rebum. Stet clita kasd gubergren, no sea 
#'          takimata sanctus est Lorem ipsum dolor sit 
#'          amet. Lorem ipsum dolor sit amet, consetetur 
#'          sadipscing elitr, sed diam nonumy eirmod 
#'          tempor invidunt ut labore et dolore magna 
#'          aliquyam erat, sed diam voluptua. At vero 
#'          eos et accusam et justo duo dolores et ea 
#'          rebum. Stet clita kasd gubergren, no sea 
#'          takimata sanctus est Lorem ipsum dolor sit 
#'          amet."
#'
#' testurl <- "https://en.wikipedia.org/wiki/Aregund"
#'
#' \dontrun{
#'   smmry_api(x = lorem_ipsum)
#'   smmry_api(x = testurl)
#' }
#' 
#' @importFrom magrittr "%>%"
#'
#' @export
smmry_api <- function(
  x = NULL, isurl = NULL, length = NULL, keywords = NULL, 
  quote_avoid = FALSE, breaks = FALSE
  ) {
  
  # remove breaks from input x
  x <- gsub("[\r\n]", "", x)
  
  # remove multiple spaces from input x
  x <-  gsub(
    "(?<=[\\s])\\s*|^\\s+|\\s+$", "", 
    x, 
    perl = TRUE
  )
  
  # check, if input x is a currently working url
  # only if isurl is not set (NULL)
  if (is.null(isurl) && RCurl::url.exists(x)) {
    isurl <- TRUE
  }
  
  url <- httr::modify_url(
    "http://api.smmry.com", 
    path = paste0(c(
      # api key
      paste0("&SM_API_KEY=", Sys.getenv("SMMRY_PAT")),
      # amount of sentences
      ifelse(
        !is.null(length), 
        paste0("&SM_LENGTH=", length),
        ""
      ),
      # amount of keywords
      ifelse(
        !is.null(url), 
        paste0("&SM_KEYWORD_COUNT=", keywords),
        ""
      ),
      # avoid quotes
      ifelse(
        quote_avoid, 
        paste0("&SM_QUOTE_AVOID", quote_avoid),
        ""
      ),
      # breaks between sentences
      ifelse(
        breaks,
        paste0("&SM_WITH_BREAK"),
        ""
      ),
      # input url
      ifelse(
        isurl, 
        paste0("&SM_URL=", x),
        ""
      )
    ), collapse = "")
  )
  url %>% httr::POST(
    body = list(sm_api_input = x)
    ) %>%
    httr::content() %>% 
    return()
}