PNU_URL <- "http://speller.cs.pusan.ac.kr/results"
PNU_URL2 <- "http://164.125.7.61/speller/results"
TEXT_CHUNK_LENGTH <- 250
PNU_MAX_TIMEOUT <- 10
PNU_MAX_TRY <- 30
PNU_SLEEP_DURATION <- 0.1

is_complex_word <- function(x) stringr::str_detect(x$help, stringr::fixed(COMPLEX_WORD_ERROR_PHRASE))
cannot_be_analyzed <- function(x) stringr::str_detect(x$help, stringr::fixed(UNANALYZABLE_PHRASE_ERROR_PHRASE))
soft_check <- function(x) is_complex_word(x) | cannot_be_analyzed(x)


filter_checks_by_exceptions <- function (checks, exceptions) {
  # if there is no exception rule, just return
  if (length(exceptions) == 0)
    return (checks)

  checks %>%
    dplyr::filter(!stringr::str_detect(original, paste(exceptions, collapse = "|")))
}

extract_check_json <- function(raw) {
  json_loc_first <- stringr::str_locate(raw, stringr::fixed("{\"str\":\""))[1]
  json_loc_last <- stringr::str_locate(raw, stringr::fixed("\"idx\":0}"))[2]
  substring(raw, json_loc_first, json_loc_last) %>%
    jsonlite::fromJSON()
}

retrieve_response <- function(text, URL, try.count = 0) {
  url.alternative <- ifelse(URL == PNU_URL, PNU_URL2, PNU_URL)
  Sys.sleep(PNU_SLEEP_DURATION)
  if (try.count > PNU_MAX_TRY)
    stop(sprintf("hanspellr error: %s tries have been made but unsuccessful while checking:\n %s",
                  PNU_MAX_TRY, text))
  tryCatch(return (httr::POST(URL, body = list(text1 = text), encode = "form",
                                  httr::accept_json(), httr::timeout(PNU_MAX_TIMEOUT))),
           error = function (e) return (retrieve_response(text, url.alternative, try.count + 1)))
}

retrieve_checks <- function(text, exceptions, soft.check) {
  response <- retrieve_response(text, PNU_URL)
  nodes <- rvest::html_nodes(httr::content(response, as = "parsed"), "script")
  if (length(nodes) < 3)
    return (data.table::data.table())
  suppressWarnings(checks <- extract_check_json(as.character(nodes[3])) %>%
    data.table::as.data.table() %>%
    tidyr::separate(errInfo.candWord, c("suggestion", "suggestion2"), sep = "([|])") %>%
      dplyr::rename(original = errInfo.orgStr) %>%
      dplyr::rename(help = errInfo.help) %>%
      dplyr::filter(stringr::str_length(suggestion) != 0))

  checks <- filter_checks_by_exceptions(checks, exceptions)

  # perform soft check if soft checks are exempted
  if (soft.check) {
    checks <- checks %>%
      dplyr::mutate(passes_soft_check = soft_check(checks)) %>%
      dplyr::filter(!passes_soft_check)
  }

  return (checks)
}

#' Spell checker with PNU Korean spell checker
#'
#' @param text Korean text to be checked
#' @param exceptions words or phrases that checks contain to be exempted; default is `character()`
#' @param soft.check check if polymorphemic word errors and unanalyzable phrase errors are exempted; default is `TRUE`
#'
#' @importFrom magrittr "%>%"
#' @return a hanspell object
#' @export
#'
#' @examples
#' spell_check(wrongkortextsample)
spell_check <- function(text, exceptions = character(), soft.check = T) {
  # retrieve spell check results by splitting up a given text
  text_chunks <- split_text_by_length(text, TEXT_CHUNK_LENGTH)
  checks <- do.call(rbind,lapply(text_chunks,
                                 function (chunk)
                                   retrieve_checks(chunk, exceptions, soft.check = soft.check)))
  text_and_checks_to_hanspell(text, checks)
}


