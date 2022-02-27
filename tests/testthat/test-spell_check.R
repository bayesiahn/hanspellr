spell_check_test <- function (text, exceptions = character()) {
  Sys.sleep(0.5)
  spell_check(text, exceptions = exceptions)
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
