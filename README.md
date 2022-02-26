# hanspellr

## Introduction

`hanspellr` is an R package for Korean spell checker using PNU/Narainfo Tech Korean Spell Checker (한국어 맞춤법/문법 검사기) inspired by [hanspell](https://github.com/9beach/hanspell).

To install this package, run

```r
usethis::install_github("bayesiahn/hanspellr")
```

## Examples

```r
hanspellr::spell_check("인생은 아름 답고 역사는 발전한다.")
```


```r
checked <- hanspellr::spell_check("인생은 아름 답고 역사는 발전한다.")
checked$text_corrected
```


## Disclaimer
MIT license applies.
