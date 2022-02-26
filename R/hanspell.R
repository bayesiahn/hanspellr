#' hanspell
#'
#' @slot text_corrected corrected text
#' @slot text_original original text
#' @slot checks a data.table object that provides details on checks performed
#'
#' @return
#' @export
hanspell <- setClass(Class = "hanspell",
                     slots = c(text_corrected="character",
                               text_original="character",
                               checks="data.frame"))


#' Print a hanspell object
#'
#' @param object hanspell object
#'
#' @return
#' @export
#'
#' @examples
#' print(spell_check(wrongkortextsample))
print.hanspell <- function(object) {


  cat(sprintf("%sOriginal  : %s\n",
              emojifont::emoji("newspaper"),
              object$text_original))
  cat(sprintf("%sCorrected : %s\n",
              emojifont::emoji("white_check_mark"),
              object$text_corrected))
  cat(sprintf("%sCorrection count : %d",
              emojifont::emoji("negative_squared_cross_mark"),
              nrow(object$checks)))
}

setMethod(f = "show",
          signature = "hanspell",
          definition = print.hanspell)
