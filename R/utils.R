
split_text_by_length <- function(text, n) {
  stringr::str_extract_all(text, paste0('.{1,',n,'}'))[[1]]
}
