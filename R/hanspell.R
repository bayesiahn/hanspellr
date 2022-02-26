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
#' @param x hanspell object
#' @param ... other arguments
#'
#' @return
#' @export
#'
#' @examples
#' print(spell_check(wrongkortextsample))
print.hanspell <- function(x, ...) {


  cat(sprintf("%sOriginal  : %s\n",
              emojifont::emoji("newspaper"),
              x$text_original))
  cat(sprintf("%sCorrected : %s\n",
              emojifont::emoji("white_check_mark"),
              x$text_corrected))
  cat(sprintf("%sCorrection count : %d",
              emojifont::emoji("negative_squared_cross_mark"),
              nrow(x$checks)))
}

setMethod(f = "show",
          signature = "hanspell",
          definition = function (object) print.hanspell(object))
