#' test
#' 
#' test
#' 
#' @param text test
#' @param url test
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
#' smmry_api(text = lorem_ipsum)
#'
#' @importFrom magrittr "%>%"
#'
#' @export
smmry_api <- function(
  text = NULL, url = NULL, length = NULL, keywords = NULL, 
  quote_avoid = FALSE, breaks = FALSE
  ) {
  
  # remove breaks
  text <- gsub("[\r\n]", "", text)
  # remove multiple spaces
  text <-  gsub(
    "(?<=[\\s])\\s*|^\\s+|\\s+$", "", 
    text, 
    perl = TRUE
  )
  
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
        !is.null(url), 
        paste0("&SM_URL=", url),
        ""
      )
    ), collapse = "")
  )
  url %>% httr::POST(
    body = list(sm_api_input = text)
    ) %>%
    httr::content() %>% 
    return()
}