text_and_checks_to_hanspell <- function(text, checks) {
  # obtain a corrected text
  text_corrected <- text
  correction_summary <- ""
  if (nrow(checks) > 0) {
    replacement.dict <- checks %>%
      dplyr::select(original, suggestion) %>%
      tibble::deframe()
    text_corrected <- stringr::str_replace_all(text, replacement.dict)
    correction_summary <- get_correction_summary(checks$original, checks$suggestion)
  }


  out <- list(text_corrected = text_corrected, text_original = text,
              correction_summary = correction_summary, checks = checks)
  class(out) <- "hanspell"
  out
}

get_correction_summary <- function(original, corrected) {
  corrections <- mapply(function(txt1, txt2) sprintf("%s %s %s", txt1, "->", txt2),
                        original, corrected)
  paste0(corrections, collapse = '\n')
}
