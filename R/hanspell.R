#' @export
hanspell <- setClass("hanspell", slots = c(text_corrected="character",
                                           text_original="character",
                                           checks="data.frame"))

#' @export
print.hanspell <- function(x, ...) {


  cat(sprintf("%sOriginal: %s\n",
              emojifont::emoji("page_facing_up"),
              x$text_original))
  cat(sprintf("%sCorrected: %s\n",
              emojifont::emoji("white_check_mark"),
              x$text_corrected))
  cat(sprintf("%sCorrection count: %d",
              emojifont::emoji("exclamation"),
              nrow(x$checks)))
}
