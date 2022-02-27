DAUM_URL <- "https://dic.daum.net/grammar_checker.do"

retrieve_checks_daum <- function (txt, exceptions) {
  body <- list(
    sentence = txt
  )

  response <- httr::POST(DAUM_URL, body = body, encode = "form")
  errors <- rvest::html_nodes(httr::content(response, as = "parsed"), ".txt_spell")

  if (length(errors) == 0)
    return (data.table::data.table())

  original <- errors %>% rvest::html_attr("data-error-input")
  suggestion <- errors %>% rvest::html_attr("data-error-output")
  errortype <- errors %>% rvest::html_attr("data-error-type")
  checks <- data.table::data.table(original = original, suggestion = suggestion,
                                   errortype = errortype)

  # if there is no exception rule, just return
  if (length(exceptions) == 0)
    return (checks)

  checks %>%
    dplyr::filter(!stringr::str_detect(original, paste(exceptions, collapse = "|")))
}

#' Spell checker with Daum Korean spell checker
#'
#' @param text Korean text to be checked
#' @param exceptions words or phrases that checks contain to be exempted
#'
#' @importFrom magrittr "%>%"
#' @return a hanspell object
#' @export
#'
#' @examples
#' spell_check_daum(wrongkortextsample)
spell_check_daum <- function(text, exceptions = character()) {
  # retrieve spell check results by splitting up a given text
  text_chunks <- split_text_by_length(text, TEXT_CHUNK_LENGTH)
  checks <- do.call(rbind,lapply(text_chunks,
                                 function (chunk) retrieve_checks_daum(chunk, exceptions)))
  text_and_checks_to_hanspell(text, checks)
}


