# PNU_URL <- "http://speller.cs.pusan.ac.kr/results"
PNU_URL <- "http://164.125.7.61/speller/results"
TEXT_CHUNK_LENGTH <- 250

extract_check_json <- function(raw) {
  json_loc_first <- stringr::str_locate(raw, stringr::fixed("{\"str\":\""))[1]
  json_loc_last <- stringr::str_locate(raw, stringr::fixed("\"idx\":0}"))[2]
  substring(raw, json_loc_first, json_loc_last) %>%
    jsonlite::fromJSON()
}

retrieve_checks <- function(text, exceptions) {
  response <- httr::POST(PNU_URL, body = list(text1 = text), encode = "form", httr::accept_json())
  nodes <- rvest::html_nodes(httr::content(response, as = "parsed"), "script")
  if (length(nodes) < 3)
    return (data.table::data.table())
  suppressWarnings(checks <- extract_check_json(as.character(nodes[3])) %>%
    data.table::as.data.table() %>%
    tidyr::separate(errInfo.candWord, c("suggestion", "suggestion2"), sep = "([|])") %>%
      dplyr::rename(original = errInfo.orgStr) %>%
      dplyr::filter(stringr::str_length(suggestion) != 0))

  # if there is no exception rule, just return
  if (length(exceptions) == 0 || exceptions == "")
    return (checks)

  checks %>%
    dplyr::filter(!stringr::str_detect(original, paste(exceptions, collapse = "|")))
}

#' Spell checker with PNU Korean spell checker
#'
#' @param text Korean text to be checked
#' @param exceptions words or phrases that checks contain to be exempted
#'
#' @importFrom magrittr "%>%"
#' @return a hanspell object
#' @export
#'
#' @examples
#' spell_check(wrongkortextsample)
spell_check <- function(text, exceptions = character()) {
  # retrieve spell check results by splitting up a given text
  text_chunks <- split_text_by_length(text, TEXT_CHUNK_LENGTH)
  checks <- do.call(rbind,lapply(text_chunks,
                                 function (chunk) retrieve_checks(chunk, exceptions)))
  text_and_checks_to_hanspell(text, checks)
}


