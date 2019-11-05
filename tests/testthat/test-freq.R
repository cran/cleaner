# ==================================================================== #
# TITLE                                                                #
# Fast and Easy Data Cleaning                                          #
#                                                                      #
# SOURCE                                                               #
# https://github.com/msberends/cleaner                                 #
#                                                                      #
# LICENCE                                                              #
# (c) 2019 Berends MS (m.s.berends@umcg.nl)                            #
#                                                                      #
# This R package is free software; you can freely use and distribute   #
# it for both personal and commercial purposes under the terms of the  #
# GNU General Public License version 2.0 (GNU GPL-2), as published by  #
# the Free Software Foundation.                                        #
#                                                                      #
# This R package was publicly released in the hope that it will be     #
# useful, but it comes WITHOUT ANY WARRANTY OR LIABILITY.              #
# ==================================================================== #

context("freq.R")

test_that("frequency table works", {
  expect_equal(nrow(freq(c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5))), 5)
  
  nrs <- as.integer(runif(2000, min = 0, max = 20))

  expect_output(print(freq(nrs)))
  expect_output(print(freq(nrs, nmax = 5)))
  expect_output(print(freq(nrs, nmax = Inf, markdown = FALSE)))
  expect_output(print(freq(nrs, nmax = Inf)))
  expect_output(print(freq(nrs, nmax = NA)))
  expect_output(print(freq(nrs, nmax = NULL)))
  expect_output(print(freq(nrs, sort.count = FALSE)))
  expect_output(print(freq(nrs, markdown = TRUE)))
  expect_output(print(freq(nrs, markdown = TRUE), markdown = FALSE))
  expect_output(print(freq(nrs, markdown = TRUE), markdown = TRUE))
  expect_output(print(freq(nrs, quote = TRUE)))
  
  # character
  expect_output(print(freq(unclean$gender)))
  # # integer
  # expect_output(print(freq(septic_patients$age)))
  # # date
  # expect_output(print(freq(septic_patients$date)))
  # # factor
  # expect_output(print(freq(septic_patients$hospital_id)))
  # # table
  # expect_output(print(freq(table(septic_patients$gender, septic_patients$age))))
  # # rsi
  # expect_output(print(freq(septic_patients$AMC)))
  # # hms
  # expect_output(print(freq(hms::as.hms(sample(c(0:86399), 50)))))
  # # matrix
  # expect_output(print(freq(as.matrix(septic_patients$age))))
  # expect_output(print(freq(as.matrix(septic_patients[, c("age", "gender")]))))
  # # list
  # expect_output(print(freq(list(age = septic_patients$age))))
  # expect_output(print(freq(list(age = septic_patients$age, gender = septic_patients$gender))))
  # # difftime
  # expect_output(print(
  #   freq(difftime(Sys.time(),
  #                 Sys.time() - runif(5, min = 0, max = 60 * 60 * 24),
  #                 units = "hours"))))
  # 
  # expect_output(print(freq(septic_patients$age)[,1:3]))
  # 
  # library(dplyr)
  # expect_output(septic_patients %>% select(1:2) %>% freq() %>% print())
  # expect_output(septic_patients %>% select(1:3) %>% freq() %>% print())
  # expect_output(septic_patients %>% select(1:4) %>% freq() %>% print())
  # expect_output(septic_patients %>% select(1:5) %>% freq() %>% print())
  # expect_output(septic_patients %>% select(1:6) %>% freq() %>% print())
  # expect_output(septic_patients %>% select(1:7) %>% freq() %>% print())
  # expect_output(septic_patients %>% select(1:8) %>% freq() %>% print())
  # expect_output(septic_patients %>% select(1:9) %>% freq() %>% print())
  # expect_output(print(freq(septic_patients$age), nmax = 20))
  # 
  # # grouping variable
  # expect_output(print(septic_patients %>% group_by(gender) %>% freq(hospital_id)))
  # expect_output(print(septic_patients %>% group_by(gender) %>% freq(AMX, quote = TRUE)))
  # expect_output(print(septic_patients %>% group_by(gender) %>% freq(AMX, markdown = TRUE)))
  # 
  # # quasiquotation
  # expect_output(print(septic_patients %>% freq(mo_genus(mo))))
  # expect_output(print(septic_patients %>% freq(mo, mo_genus(mo))))
  # expect_output(print(septic_patients %>% group_by(gender) %>% freq(mo_genus(mo))))
  # expect_output(print(septic_patients %>% group_by(gender) %>% freq(mo, mo_genus(mo))))
  # 
  # # top 5
  # expect_equal(
  #   septic_patients %>%
  #     freq(mo) %>%
  #     top_freq(5) %>%
  #     length(),
  #   5)
  # # there are more than 5 lowest values
  # expect_gt(
  #   septic_patients %>%
  #     freq(mo) %>%
  #     top_freq(-5) %>%
  #     length(),
  #   5)
  # # n has length > 1
  # expect_error(
  #   septic_patients %>%
  #     freq(mo) %>%
  #     top_freq(n = c(1, 2))
  # )
  # # input must be freq tbl
  # expect_error(septic_patients %>% top_freq(1))
  # 
  # # charts from plot, hist and boxplot, should not raise errors
  # plot(freq(septic_patients, age))
  # hist(freq(septic_patients, age))
  # boxplot(freq(septic_patients, age))
  # boxplot(freq(dplyr::group_by(septic_patients, gender), age))
  # 
  # # check vector
  # expect_identical(septic_patients %>%
  #                    freq(age) %>%
  #                    as.vector() %>%
  #                    sort(),
  #                  septic_patients %>%
  #                    pull(age) %>%
  #                    sort())
  # 
  # # check format
  # expect_identical(septic_patients %>%
  #                    freq(age) %>%
  #                    format() %>%
  #                    apply(2, class) %>%
  #                    unname(),
  #                  rep("character", 5))
  # 
  # # check tibble
  # expect_identical(septic_patients %>%
  #                    freq(age) %>%
  #                    as_tibble() %>%
  #                    class() %>%
  #                    .[1],
  #                  "tbl_df")
  # 
  # expect_error(septic_patients %>% freq(nonexisting))
  # expect_error(septic_patients %>% select(1:10) %>% freq())
  # expect_error(septic_patients %>% freq(peni, oxac, clox, AMX, AMC,
  #                                       ampi, pita, czol, cfep, cfur))
  # 
  # # (un)select columns
  # expect_equal(septic_patients %>% freq(hospital_id) %>% select(item) %>% ncol(),
  #              1)
  # expect_equal(septic_patients %>% freq(hospital_id) %>% select(-item) %>% ncol(),
  #              4)
  # 
  # # run diff
  # expect_output(print(
  #   diff(freq(septic_patients$AMC),
  #        freq(septic_patients$AMX))
  # ))
  # expect_output(print(
  #   diff(freq(septic_patients$age),
  #        freq(septic_patients$age)) # "No differences found."
  # ))
  # expect_error(print(
  #   diff(freq(septic_patients$AMX),
  #        "Just a string") # not a freq tbl
  # ))
  # 
  # # directly on group
  # expect_output(print(septic_patients %>% group_by(ageplusone = as.character(age + 1)) %>% freq(ageplusone)))

})
