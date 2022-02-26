#' hanspell
#'
#' @slot text_corrected corrected text
#' @slot text_original original text
#' @slot checks a data.table object that provides details on checks performed
#'
#' @return
#' @export
hanspell <- setClass("hanspell", slots = c(text_corrected="character",
                                           text_original="character",
                                           checks="data.frame"))


#' Print a hanspell object
#'
#' @param object hanspell object
#'
#' @return
#'
#' @examples
#' print(spell_check(wrongkortextsample))
print.hanspell <- function(object) {


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

setMethod(f = "show",
          signature = "hanspell",
          definition = print.hanspell)
