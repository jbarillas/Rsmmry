#' test
#' 
#' test
#' 
#' @param x test
#' @param quick test 
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
#'   smmry_api(x = lorem_ipsum, quick = FALSE)
#'   smmry_api(x = testurl)
#'   smmry_api(x = testurl, quick = FALSE)
#' }
#' 
#' @importFrom magrittr "%>%"
#'
#' @export
smmry_api <- function(
  x = NULL, quick = TRUE, isurl = NULL, length = NULL, 
  keywords = NULL, quote_avoid = FALSE, breaks = FALSE
  ) {
  
  # check for an internet connection
  if (!curl::has_internet()) {
    stop("No internet connection. Can't use SMMRY API.")
  }
  
  # set user agent
  ua <- httr::user_agent("http://github.com/nevrome/Rsmmry")
  
  # check, if access token to SMMRY is available
  pat <- Sys.getenv('SMMRY_PAT')
  if (identical(pat, "")) {
    stop(
      "Please set env var SMMRY_PAT to your SMMRY personal access token.
      See https://github.com/nevrome/Rsmmry for more info.",
      call. = FALSE
    )
  }
  
  # remove breaks from input x
  x <- gsub("[\r\n]", "", x)
  
  # remove multiple spaces from input x
  x <- gsub(
    "(?<=[\\s])\\s*|^\\s+|\\s+$", "", 
    x, 
    perl = TRUE
  )
  
  # check, if input x is a currently working url
  # only if isurl is not set (NULL)
  if (is.null(isurl) && RCurl::url.exists(x)) {
    isurl <- TRUE
  }
  
  # parse url for api call
  url <- httr::modify_url(
    "http://api.smmry.com", 
    path = paste0(c(
      # api key
      paste0("&SM_API_KEY=", pat),
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
  
  # API request
  api_result_raw <- url %>% 
    # add text data and send to smmry
    httr::POST(
      body = list(sm_api_input = x)
    )
    
  # catch and print http errors
  if (httr::http_error(api_result_raw)) {
    stop(
      sprintf(
        "HTTP Error: ", 
        httr::status_code(api_result_raw)
      ),
      call. = FALSE
    )
  }

  # extract content from request
  api_result <- api_result_raw %>% httr::content(as = "parsed")
  
  # catch and print SMMRY notices, warnings, and error 
  # messages
  if (exists('sm_api_message', where = api_result)) {
    message(
      "SMMRY API message: ",
      api_result[["sm_api_message"]]
    )
  }
  
  # catch and print SMMRY limitation message
  if (exists('sm_api_limitation', where = api_result)) {
    message(
      "SMMRY API limitations: ",
      api_result[["sm_api_limitation"]]
    )
  }

  # remove mysterious leading whitespace in sm_api_content
  api_result[["sm_api_content"]] <- sub(
    "^\\s+", "", 
    api_result[["sm_api_content"]]
  )
  
  # setup output
  if (quick) {
    
    # return just reduced text
    return(api_result[["sm_api_content"]])
    
  } else {
    
    # put complete api_result in own S3 data structure
    result <- structure(
      api_result,
      class = "smmry_api"
    )

    return(result)
  }
}