# hanspellr
<!-- badges: start -->
  [![R-CMD-check](https://github.com/bayesiahn/hanspellr/workflows/R-CMD-check/badge.svg)](https://github.com/bayesiahn/hanspellr/actions)
<!-- badges: end -->

`hanspellr` is an R package for Korean spell checker using PNU/Narainfo Tech Korean Spell Checker (한국어 맞춤법/문법 검사기) inspired by [hanspell](https://github.com/9beach/hanspell).

To install this package, run

```r
usethis::install_github("bayesiahn/hanspellr")
```

## Examples

```r
hanspellr::spell_check("인생 은 아름 답고 역사는 발전한다")
```

prints as

```
📰Original  : 인생 은 아름 답고 역사는 발전한다
✅Corrected : 인생은 아름답고 역사는 발전한다.
❎Correction count : 3
✏️Corrections made : 
인생 은 -> 인생은
아름 답고 -> 아름답고
발전한다 -> 발전한다.
```

One can extract corrected text and summary of corrections made as follows:
```r
checked <- hanspellr::spell_check("인생 은 아름 답고 역사는 발전한다")
checked$text_corrected
checked$correction_summary
```


## Disclaimer
MIT license applies.
