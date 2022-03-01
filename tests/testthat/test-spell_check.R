spell_check_test <- function (text, exceptions = character(), soft.check = T) {
  Sys.sleep(0.5)
  spell_check(text, exceptions = exceptions, soft.check = soft.check)
}

test_that("spell_check", {
  expect_equal(spell_check_test("웬일이니!")$text_corrected, "웬일이니!")
  expect_equal(spell_check_test("왠일이니!")$text_corrected, "웬일이니!")

  expect_equal(spell_check_test("웬지 무섭다..")$text_corrected, "왠지 무섭다….")
  expect_equal(spell_check_test("웬지 무섭다..")$text_corrected, "왠지 무섭다….")

  expect_equal(spell_check_test("수백만의 시민들이 귀성길을 오고가고 있다.")$text_corrected,
               "수백만의 시민들이 귀성길을 오가고 있다.")

  expect_equal(spell_check_test("인생은 아름답고 역사는 발전한다.")$text_corrected,
               "인생은 아름답고 역사는 발전한다.")
  expect_equal(spell_check_test("인생은 아름답고 역사는발전한다.")$text_corrected,
               "인생은 아름답고 역사는 발전한다.")
  expect_equal(spell_check_test("인생은 아름답고 역사는 발전한다")$text_corrected,
               "인생은 아름답고 역사는 발전한다.")

  expect_equal(spell_check_test("인생은아름답고 역사는발전한다.")$text_corrected,
               "인생은 아름답고 역사는 발전한다.")
  expect_equal(spell_check_test("인생은아름답고 역사는발전한다.",
                            exceptions = "인생은아름답고")$text_corrected,
               "인생은아름답고 역사는 발전한다.")
  expect_equal(spell_check_test("인생은아름답고 역사는발전한다.",
                            exceptions = c("인생은아름답고", "역사는발전한다"))$text_corrected,
               "인생은아름답고 역사는발전한다.")

})

test_that("spell_check soft.check", {
  # complex words
  expect_equal(spell_check_test("초연결지능", soft.check = T)$text_corrected, "초연결지능")
  expect_false(spell_check_test("초연결지능", soft.check = F)$text_corrected == "초연결지능")
  expect_equal(spell_check_test("초연결지능 생성에관여했다.", soft.check = T)$text_corrected, "초연결지능 생성에 관여했다.")
  expect_false(spell_check_test("초연결지능 생성에관여했다.", soft.check = F)$text_corrected == "초연결지능 생성에 관여했다.")

  # unanalyzable phrase
  unanalyzable_sentence <- "함두릴레 우 엔타?"
  expect_equal(spell_check_test(unanalyzable_sentence, soft.check = T)$text_corrected, unanalyzable_sentence)
  expect_false(spell_check_test(unanalyzable_sentence, soft.check = F)$text_corrected == unanalyzable_sentence)

})


