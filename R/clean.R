# ==================================================================== #
# TITLE                                                                #
# cleaner: Fast and Easy Data Cleaning                                 #
#                                                                      #
# SOURCE                                                               #
# https://github.com/msberends/cleaner                                 #
#                                                                      #
# LICENCE                                                              #
# (c) 2022 Berends MS (m.s.berends@umcg.nl)                            #
#                                                                      #
# This R package is free software; you can freely use and distribute   #
# it for both personal and commercial purposes under the terms of the  #
# GNU General Public License version 2.0 (GNU GPL-2), as published by  #
# the Free Software Foundation.                                        #
#                                                                      #
# This R package was publicly released in the hope that it will be     #
# useful, but it comes WITHOUT ANY WARRANTY OR LIABILITY.              #
# ==================================================================== #

#' Clean column data to a class
#' 
#' Use any of these functions to quickly clean columns in your data set. Use \code{clean()} to pick the functions that return the least relative number of \code{NA}s. They \strong{always} return the class from the function name (e.g. \code{clean_Date()} always returns class \code{Date}).
#' @param x data to clean
#' @param true \link[base]{regex} to interpret values as \code{TRUE} (which defaults to \code{\link{regex_true}}), see Details
#' @param false \link[base]{regex} to interpret values as \code{FALSE} (which defaults to \code{\link{regex_false}}), see Details
#' @param na \link[base]{regex} to force interpret values as \code{NA}, i.e. not as \code{TRUE} or \code{FALSE}
#' @param remove \link[base]{regex} to define the character(s) that should be removed, see Details
#' @param levels new factor levels, may be named with regular expressions to match existing values, see Details
#' @param droplevels logical to indicate whether non-existing factor levels should be dropped
#' @param ordered logical to indicate whether the factor levels should be ordered
#' @param fixed logical to indicate whether regular expressions should be turned off
#' @param trim logical to indicate whether the result should be trimmed with \code{\link{trimws}(..., which = "both")}
#' @param ignore.case logical to indicate whether matching should be case-insensitive
#' @param format a date format that will be passed on to \code{\link{format_datetime}}, see Details
#' @param currency_symbol the currency symbol to use, which will be guessed based on the input and otherwise defaults to the current system locale setting (see \code{\link{Sys.localeconv}})
#' @param guess_each logical to indicate whether all items of \code{x} should be guessed one by one, see Examples
#' @param max_date date (coercible with [as.Date()]) to indicate to maximum allowed of \code{x}, which defaults to today. This is to prevent that \code{clean_Date("23-03-47")} will return 23 March 2047 and instead returns 23 March 1947 with a warning.
#' @param format character string giving a date-time format as used by \link[base]{strptime}. 
#' 
#' For \code{clean_Date(..., guess_each = TRUE)}, this can be a vector of values to be used for guessing, see Examples.
#' @param ... for \code{clean_Date} and \code{clean_POSIXct}: other parameters passed on these functions
#' @inheritParams base::as.POSIXct
#' @details
#' Using \code{clean()} on a vector will guess a cleaning function based on the potential number of \code{NAs} it returns. Using \code{clean()} on a data.frame to apply this guessed cleaning over all columns.
#' 
#' Info about the different functions:
#' 
#' \itemize{
#'   \item{\code{clean_logical()}:\cr}{Use parameters \code{true} and \code{false} to match values using case-insensitive regular expressions (\link[base]{regex}). Unmatched values are considered \code{NA}. At default, values are matched with \code{\link{regex_true}} and \code{\link{regex_false}}. This allows support for values "Yes" and "No" in the following languages: Arabic, Bengali, Chinese (Mandarin), Dutch, English, French, German, Hindi, Indonesian, Japanese, Malay, Portuguese, Russian, Spanish, Telugu, Turkish and Urdu. Use parameter \code{na} to override values as \code{NA} that would else be matched with \code{true} or \code{false}. See Examples.}
#'   \item{\code{clean_factor()}:\cr}{Use parameter \code{levels} to set new factor levels. They can be case-insensitive regular expressions to match existing values of \code{x}. For matching, new values for \code{levels} are internally temporary sorted descending on text length. See Examples.}
#'   \item{\code{clean_numeric()}, \code{clean_double()}, \code{clean_integer()} and \code{clean_character()}:\cr}{Use parameter \code{remove} to match values that must be removed from the input, using regular expressions (\link[base]{regex}). In case of \code{clean_numeric()}, comma's will be read as dots and only the last dot will be kept. Function \code{clean_character()} will keep middle spaces at default. See Examples.}
#'   \item{\code{clean_percentage()}:\cr}{This new class works like \code{clean_numeric()}, but transforms it with \code{\link{as.percentage}}, which will retain the original values, but will print them as percentages. See Examples.} 
#'   \item{\code{clean_currency()}:\cr}{This new class works like \code{clean_numeric()}, but transforms it with \code{\link{as.currency}}. The currency symbol is guessed based on the most traded currencies by value (see Source): the United States dollar, Euro, Japanese yen, Pound sterling, Swiss franc, Renminbi, Swedish krona, Mexican peso, South Korean won, Turkish lira, Russian ruble, Indian rupee and the South African rand. See Examples.}
#'   \item{\code{clean_Date()}:\cr}{Use parameter \code{format} to define a date format, or leave it empty to have the format guessed. Use \code{"Excel"} to read values as Microsoft Excel dates. The \code{format} parameter will be evaluated with \code{\link{format_datetime}}, which means that a format like \code{"d-mmm-yy"} with be translated internally to \code{"\%e-\%b-\%y"} for convenience. See Examples.}
#'   \item{\code{clean_POSIXct()}:\cr}{Use parameter \code{remove} to match values that must be removed from the input, using regular expressions (\link[base]{regex}). The resulting string will be coerced to a date/time element with class \code{POSIXct}, using \code{\link{as.POSIXct}()}. See Examples.}
#' }
#' 
#' The use of invalid regular expressions in any of the above functions will not return an error (like in base R), but will instead interpret the expression as a fixed value and will throw a warning.
#' @rdname clean
#' @return The \code{clean_*} functions \strong{always} return the class from the function name:
#' \itemize{
#'   \item{\code{clean_logical()}: class \code{logical}}
#'   \item{\code{clean_factor()}: class \code{factor}}
#'   \item{\code{clean_numeric()} and \code{clean_double()}: class \code{numeric}}
#'   \item{\code{clean_integer()}: class \code{integer}}
#'   \item{\code{clean_character()}: class \code{character}}
#'   \item{\code{clean_percentage()}: class \code{percentage}}
#'   \item{\code{clean_currency()}: class \code{currency}}
#'   \item{\code{clean_Date()}: class \code{Date}}
#'   \item{\code{clean_POSIXct()}: classes \code{POSIXct/POSIXt}}
#' }
#' @export
#' @source \href{https://www.bis.org/publ/rpfx16fx.pdf}{Triennial Central Bank Survey Foreign exchange turnover in April 2016} (PDF). Bank for International Settlements. 11 December 2016. p. 10.
#' @examples 
#' clean_logical(c("Yes", "No"))   # English
#' clean_logical(c("Oui", "Non"))  # French
#' clean_logical(c("ya", "tidak")) # Indonesian
#' clean_logical(x = c("Positive", "Negative", "Unknown", "Some value"),
#'               true = "pos", false = "neg")
#' 
#' gender_age <- c("male 0-50", "male 50+", "female 0-50", "female 50+")
#' clean_factor(gender_age, c("M", "F"))
#' clean_factor(gender_age, c("Male", "Female"))
#' clean_factor(gender_age, c("0-50", "50+"), ordered = TRUE)
#' 
#' clean_Date("13jul18", "ddmmmyy")
#' clean_Date("12 August 2010")
#' clean_Date("12 06 2012")
#' clean_Date("October 1st 2012")
#' clean_Date("43658")
#' clean_Date("14526", "Excel")
#' clean_Date(c("1 Oct 13", "October 1st 2012")) # could not be fitted in 1 format
#' clean_Date(c("1 Oct 13", "October 1st 2012"), guess_each = TRUE)
#' clean_Date(c("12-14-13", "1 Oct 2012"), 
#'            guess_each = TRUE,
#'            format = c("d mmm yyyy", "mm-yy-dd")) # only these formats will be tried
#' 
#' clean_POSIXct("Created log on 2020/02/11 11:23 by user Joe")
#' clean_POSIXct("Created log on 2020.02.11 11:23 by user Joe", tz = "UTC")
#' 
#' clean_numeric("qwerty123456")
#' clean_numeric("Positive (0.143)")
#' clean_numeric("0,143")
#' clean_numeric("minus 12 degrees")
#' 
#' clean_percentage("PCT: 0.143")
#' clean_percentage(c("Total of -12.3%", "Total of +4.5%"))
#' 
#' clean_character("qwerty123456")
#' clean_character("Positive (0.143)")
#' 
#' clean_currency(c("Received 25", "Received 31.40"))
#' clean_currency(c("Jack sent £ 25", "Bill sent £ 31.40"))
#' 
#' df <- data.frame(A = c("2 Apr 2016", "5 Feb 2020"), 
#'                  B = c("yes", "no"),
#'                  C = c("Total of -12.3%", "Total of +4.5%"),
#'                  D = c("Marker: 0.4513 mmol/l", "Marker: 0.2732 mmol/l"))
#' df
#' clean(df)
clean <- function(x) {
  UseMethod("clean")
}

#' @method clean default
#' @export
#' @noRd
clean.default <- function(x, ...) {
  x_withoutNA <- x[!is.na(x)]
  fns <- c("Date", "percentage", "numeric", "logical", "character")
  n_valid <- integer(length(fns))
  for (i in seq_len(length(fns))) {
    fn <- get(paste0("clean_", fns[i]), envir = asNamespace("cleaner"))
    n_valid[i] <- sum(!is.na(suppressWarnings(suppressMessages(fn(x_withoutNA)))))
  }
  class_winner <- fns[n_valid == max(n_valid)][1L]
  if (max(n_valid) == 0) {
    warning("no appropriate cleaning function found")
    return(x)
  }
  
  # determine the winner
  if (class_winner == "Date") {
    end_with_LF <- FALSE
  } else {
    end_with_LF <- TRUE
  }
  if (!is.null(list(...)$variable)) {
    message("Note: Assuming class '", class_winner, "' for variable '", list(...)$variable, "' ", appendLF = end_with_LF)
  } else {
    message("Note: Assuming class '", class_winner, "' ", appendLF = end_with_LF)
  }
  
  fn_winner <- get(paste0("clean_", class_winner), envir = asNamespace("cleaner"))
  fn_winner(x)
}

#' @method clean data.frame
#' @export
#' @rdname clean
clean.data.frame <- function(x) {
  n <- 0
  as.data.frame(lapply(x, function(y) {
    clean.default(y, variable = colnames(x)[n <<- n + 1])
  }), stringsAsFactors = FALSE)
}

#' @rdname clean
#' @export
clean_logical <- function(x, true = regex_true(), false = regex_false(), na = NULL, fixed = FALSE, ignore.case = TRUE) {
  # transform x to Latin characters: "sí" will be "si"
  if (identical(true, regex_true()) & identical(false, regex_false())) {
    x <- iconv(x, from = "UTF-8", to = "ASCII//TRANSLIT")
    x <- gsub("[^a-z,./ 0-9]+", "", x, ignore.case = ignore.case)
  }
  conv <- rep(NA, length(x))
  conv[x %in% c(-1, 1) | grepl_warn_on_error(true, x, ignore.case = ignore.case, fixed = fixed)] <- TRUE
  conv[x == 0 | grepl_warn_on_error(false, x, ignore.case = ignore.case, fixed = fixed)] <- FALSE
  if (!is.null(na)) {
    conv[grepl_warn_on_error(na, x, ignore.case = ignore.case, fixed = fixed)] <- NA
  }
  as.logical(conv)
}

#' @rdname clean
#' @export
clean_factor <- function(x, levels = unique(x), ordered = FALSE, droplevels = FALSE, fixed = FALSE, ignore.case = TRUE) {
  if (!all(levels %in% x)) {
    new_x <- rep(NA_character_, length(x))
    # sort descending on character length
    levels_nchar <- levels[rev(order(nchar(levels)))]
    new_x <- rep(NA_character_, length(x))
    # fill in levels
    for (i in seq_len(length(levels_nchar))) {
      # first try exact match
      tryCatch(new_x[is.na(new_x) & x == levels_nchar[i]] <- levels_nchar[i], error = function(e) invisible())
      # then regular expressions
      new_x[is.na(new_x) & grepl_warn_on_error(levels_nchar[i], x, ignore.case = ignore.case, fixed = fixed)] <- levels_nchar[i]
    }
    if (!is.null(names(levels))) {
      # override named levels
      x_set_with_name <- logical(length(x))
      for (i in seq_len(length(levels))) {
        if (names(levels)[i] != "") {
          new_x[grepl_warn_on_error(names(levels)[i], x, ignore.case = ignore.case, fixed = fixed) & x_set_with_name == FALSE] <- levels[i]
          x_set_with_name[grepl_warn_on_error(names(levels)[i], x, ignore.case = ignore.case, fixed = fixed)] <- TRUE
        }
      }
    }
    x <- new_x
  }
  if (length(levels[!levels %in% x]) > 0 & droplevels == FALSE) {
    warning("These factor levels were not found in the data: ", 
            toString(sort(levels[!levels %in% x])), call. = FALSE)
  }
  x <- factor(x = x, levels = levels, ordered = ordered)
  if (droplevels == TRUE) {
    droplevels(x)
  } else {
    x
  }
}

#' @rdname clean
#' @export
clean_numeric <- function(x, remove = "[^0-9.,-]", fixed = FALSE) {
  x <- gsub(",", ".", x)
  # remove ending dot/comma
  x <- gsub("[,.]$", "", x)
  # only keep last dot/comma
  reverse <- function(x) sapply(lapply(strsplit(x, NULL), rev), paste, collapse = "")
  x <- sub("{{dot}}", ".", 
           gsub(".", "",
                reverse(sub(".", "}}tod{{",
                            reverse(x), 
                            fixed = TRUE)),
                fixed = TRUE), 
           fixed = TRUE)
  # keep minus
  x <- gsub("(minus|min|-) ?([0-9.])", "{{minus}}\\2", x, ignore.case = TRUE)
  x <- gsub("-", "", x, fixed = TRUE)
  x <- gsub("{{minus}}", "-", x, fixed = TRUE)
  x_clean <- gsub_warn_on_error(remove, "", x, ignore.case = TRUE, fixed = fixed)
  # get the ones starting with a minus
  x_below0 <- grepl("^-", x_clean)
  # remove everything that is not a number or dot
  x_numeric <- as.numeric(gsub("[^0-9.]+", "", x_clean))
  # set minus where needed
  x_numeric[x_below0] <- -x_numeric[x_below0]
  x_numeric
}

#' @rdname clean
#' @export
clean_double <- clean_numeric

#' @rdname clean
#' @export
clean_integer <- function(x, remove = "[^0-9.,-]", fixed = FALSE) {
  as.integer(clean_numeric(x = x, remove = remove, fixed = fixed))
}

#' @rdname clean
#' @export
clean_character <- function(x, remove = "[^a-z \t\r\n]", fixed = FALSE, ignore.case = TRUE, trim = TRUE) {
  x <- as.character(gsub_warn_on_error(remove, "", x, ignore.case = ignore.case, fixed = fixed))
  if (isTRUE(trim)) {
    trimws(x, which = "both")
  } else {
    x
  }
}

#' @rdname clean
#' @export
clean_currency <- function(x, currency_symbol = NULL, remove = "[^0-9.,-]", fixed = FALSE) {
  if (isTRUE(any(grepl("[^a-zA-Z]([\u0024]|USD)", x)))) { # Dollar Sign
    currency_symbol <- "USD"
  } else if (isTRUE(any(grepl("[^a-zA-Z]([\u20ac]|EUR)", x)))) { # Euro sign
    currency_symbol <- "EUR"
  } else if (isTRUE(any(grepl("[^a-zA-Z]([\u00a5]|JPY)", x)))) { # Yen sign
    currency_symbol <- "JPY"
  } else if (isTRUE(any(grepl("[^a-zA-Z]([\u00a3]|GBP)", x)))) { # Pound sign
    currency_symbol <- "GBP"
  } else if (isTRUE(any(grepl("[^a-zA-Z](Fr|CHF)", x)))) {
    currency_symbol <- "CHF"
  } else if (isTRUE(any(grepl("[^a-zA-Z]([\u5143]|CNY)", x)))) {
    currency_symbol <- "CNY"
  } else if (isTRUE(any(grepl("[^a-zA-Z](k|SEK)r", x)))) {
    currency_symbol <- "SEK"
  } else if (isTRUE(any(grepl("[^a-zA-Z]([\u20a9]|KRW)", x)))) { # Won sign
    currency_symbol <- "KRW"
  } else if (isTRUE(any(grepl("[^a-zA-Z](TRY)", x)))) { # Lira sign
    currency_symbol <- "TRY"
  } else if (isTRUE(any(grepl("[^a-zA-Z](RUB)", x)))) { # Ruble sign
    currency_symbol <- "RUB"
  } else if (isTRUE(any(grepl("[^a-zA-Z](INR)", x)))) { # Rubee sign
    currency_symbol <- "INR"
  } else if (isTRUE(any(grepl("[^a-zA-Z](ZAR)", x)))) {
    currency_symbol <- "ZAR"
  } else {
    currency_symbol <- trimws(Sys.localeconv()["int_curr_symbol"])
  }
  as.currency(clean_numeric(x = x, remove = remove, fixed = fixed),
              currency_symbol = currency_symbol)
}

#' @rdname clean
#' @export
clean_percentage <- function(x, remove = "[^0-9.,-]", fixed = FALSE) {
  x_clean <- clean_numeric(x = x, remove = remove, fixed = fixed)
  x_tested <- logical(length(x))
  for (i in seq_len(length(x))) {
    x_tested[i] <- grepl(pattern = paste0(x_clean[i], ".?(%|percent|pct)"),
                         x = x[i], ignore.case = TRUE) |
      grepl(pattern = "(percent|pct)",
            x = x[i],
            ignore.case = TRUE)
  }
  if (all(x_tested)) {
    as.percentage(x_clean / 100)
  } else {
    # they were no percentages, so return NAs
    as.percentage(rep(NA_integer_, length(x)))
  }
}

#' @rdname clean
#' @export
clean_Date <- function(x, format = NULL, guess_each = FALSE, max_date = Sys.Date(), ...) {

  if (is.Date(x)) {
    # could also be POSIX, or just Date
    return(as.Date(x))
  }
  
  if (length(max_date) == 1) {
    max_date <- rep(max_date, length(x))
  }
  if (!is.Date(max_date)) {
    max_date[is.infinite(max_date)] <- "2099-12-31"
    max_date <- as.Date(max_date)
    if (any(is.na(max_date))) {
      stop("`max_date` must (all) be dates.")
    }
  }
  max_date <- as.Date(max_date) # must be same type as x
  
  if (is.double(x)) {
    x <- as.integer(x)
  } else {
    x <- tolower(x)
  }
  
  original_format <- NULL
  
  if (!is.null(format) & length(format) == 1) {
    if (tolower(format) == "excel") {
      final_result <- as.Date(as.numeric(x), origin = "1899-12-30")
    } else {
      final_result <- as.Date(x = x, format = format_datetime(format), ...)
    }
  } else {
    if (guess_each == FALSE && length(format) < 2) {
      final_result <- guess_Date(x = x, throw_note = TRUE, guess_each = guess_each, original_format = original_format)
    } else {
      if (length(format) > 1) {
        # checking date according to set vector of format options
        x_coerced <- rep(NA_character_, length(x))
        n_coerced <- 0
        for (i in seq_len(length(format))) {
          x_coerced[is.na(x_coerced)] <- tryCatch(as.Date(x = as.character(x[is.na(x_coerced)]),
                                                          format = format_datetime(format[i])),
                                                  warning = function(w) NA_character_,
                                                  error = function(e) NA_character_)
          message("(format '", format[i], "' used for ", length(x_coerced[!is.na(x_coerced)]) - n_coerced, " items)")
          n_coerced <- length(x_coerced[!is.na(x_coerced)])
        }
        final_result <- as.Date(as.double(x_coerced), origin = "1970-01-01")
      } else {
        final_result <- as.Date(unname(sapply(x, guess_Date, throw_note = FALSE, format = format, guess_each = guess_each, original_format = original_format)), origin = "1970-01-01")
      }
    }
  }
  
  tryCatch({
    time_lt <- as.POSIXlt(final_result)
    lowered <- which(final_result > max_date)
    time_lt[lowered]$year <- time_lt[lowered]$year - 100
    x <- as.Date(time_lt)
    if (length(lowered) > 0) {
      warning(length(lowered), " year", ifelse(length(lowered) > 1, "s were", " was"),
              " decreased by 100 to not exceed ",
              ifelse(all(max_date == Sys.Date()), "today", "the set 'max_date'"),
              ". Use clean_Date(..., max_date = Inf) to prevent this.", call. = FALSE)
    }
  },
  error = function(e) x <<- final_result)
  
  as.Date(x)
}

#' @rdname clean
#' @export
clean_POSIXct <- function(x, tz = "", remove = "[^.0-9 :/-]", fixed = FALSE, max_date = Sys.Date(), ...) {
  if (is.Date(x)) {
    # could also be POSIX, or just Date
    return(as.POSIXct(x))
  }
  
  if (length(max_date) == 1) {
    max_date <- rep(max_date, length(x))
  }
  if (!is.Date(max_date)) {
    max_date[is.infinite(max_date)] <- "2099-12-31"
    max_date <- as.Date(max_date)
    if (any(is.na(max_date))) {
      stop("`max_date` must (all) be dates.")
    }
  }
  max_date <- as.POSIXct(max_date) # must be same type as x
  
  x <- trimws(gsub_warn_on_error(remove, "", x, ignore.case = TRUE, fixed = fixed))
  x <- gsub("[\\./]", "-", x)
  
  tryCatch({
    time_ct <- tryCatch(as.POSIXct(x, tz = tz, ...),
                        error = function(e) as.POSIXct(clean_Date(x, ..., max_date = Inf), tz = tz))
    if (all(is.na(time_ct)) & !all(is.na(x))) {
      # try clean_Date again
      time_ct <- as.POSIXct(clean_Date(x, ..., max_date = Inf), tz = tz)
    }
    lowered <- which(time_ct > max_date)
    time_lt <- as.POSIXlt(time_ct)
    time_lt[lowered]$year <- time_lt[lowered]$year - 100
    x <- as.POSIXct(time_lt, tz = tz, ...)
    if (length(lowered) > 0) {
      warning(length(lowered), " year", ifelse(length(lowered) > 1, "s were", " was"),
              " decreased by 100 to not exceed ",
              ifelse(all(as.Date(max_date) == Sys.Date()), "today", "the set 'max_date'"),
              ". Use clean_POSIXct(..., max_date = Inf) to prevent this.", call. = FALSE)
    }
  },
  error = function(e) x <<- time_ct)
  
  as.POSIXct(x)
}



guess_Date <- function(x, throw_note = TRUE, format_options = NULL, guess_each = FALSE, original_format = NULL) {
  msg_clean_as <- function(format_set, sep = " ", orig_format = original_format) {
    if (throw_note == TRUE) {
      if (!is.null(orig_format)) {
        message("(assuming format '", orig_format, "')")
      } else if (tolower(format_set) == "excel") {
        message("(assuming Excel format)")
      } else {
        message("(assuming format '", gsub(" ", sep, format_set, fixed = TRUE), "')")
      }
    }
  }
  
  x_numeric <- suppressWarnings(as.numeric(x))
  if (all(x_numeric %in% c(as.integer(as.Date("1970-01-01") - as.Date("1899-12-30")):as.integer(Sys.Date() - as.Date("1899-12-30"))), na.rm = TRUE)) {
    # is Excel date
    msg_clean_as("Excel")
    return(as.Date(x_numeric, origin = "1899-12-30"))
  }
  
  # check for POSIX (yyyy-mm-dd HH:MM:SS)
  if (all(grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{1,2}:[0-9]{2}:[0-9]{2}$", x))) {
    msg_clean_as("yyyy-mm-dd HH:MM:SS", sep = " ")
    return(as.Date(as.POSIXct(x)))
  }
  
  if (all(grepl("^[a-z]+$", x))) {
    # support for clean_Date("February")
    out <- try(as.Date(paste("1", x, format(Sys.Date(), "%Y")),
                       format = format_datetime("d mmmm yyyy")),
               silent = TRUE)
    if (!all(is.na(out))) {
      msg_clean_as("mmmm", sep = "")
      return(out)  
    }
  } else if (all(grepl("^[a-z]+( (19|20)[0-9]{2})?$", x))) {
    # support for clean_Date("February 2021")
    out <- try(as.Date(paste("1", x), format = format_datetime("d mmmm yyyy")),
               silent = TRUE)
    if (!all(is.na(out))) {
      msg_clean_as("mmmm yyyy", sep = " ")
      return(out)  
    }
  } else if (all(grepl("^[01]?[0-9] (19|20)?[0-9]{2}$", x))) {
    # support for clean_Date("2 2021")
    x[grepl(" [0-9][0-9]$", x)] <- gsub(" ([0-9][0-9])$", " 20\\1", x[grepl(" [0-9][0-9]$", x)])
    out <- try(as.Date(paste("1", x), format = format_datetime("d mm yyyy")),
               silent = TRUE)
    if (!all(is.na(out))) {
      msg_clean_as("mm yyyy", sep = " ")
      return(out)  
    }
  }
  
  # replace any non-number/separators ("-", ".", etc.) with space
  separator <- ifelse(grepl("[0-9]-", x) & !grepl("[0-9]-$", x), "-",
                      ifelse(grepl("[0-9][.]", x) & !grepl("[0-9][.]$", x), ".",
                             " "))[1L]
  x <- trimws(gsub("[^0-9a-z]+", " ", x))
  
  # remove 1st, 2nd, 3rd, 4th followed by a space or at the end
  x <- gsub("([0-9])(st|nd|rd|th) ", "\\1 ", x)
  x <- gsub("([0-9])(st|nd|rd|th)$", "\\1", x)
  
  new_format <- NULL
  # first check if format is like 1-2 digits, text, 2-4 digits (12 August 2010) which is observed a lot
  if (all(grepl("^[0-9]+ [a-z]+ [0-9]+$", x[!is.na(x)]))) {
    if (all(grepl("^[0-9]{2} [a-z]{3} [0-9]{4}$", x[!is.na(x)]))) new_format <- "dd mmm yyyy"
    if (all(grepl("^[0-9]{2} [a-z]{3} [0-9]{2}$", x[!is.na(x)]))) new_format <- "dd mmm yy"
    if (all(grepl("^[0-9]{1} [a-z]{3} [0-9]{4}$", x[!is.na(x)]))) new_format <- "d mmm yyyy"
    if (all(grepl("^[0-9]{1} [a-z]{3} [0-9]{2}$", x[!is.na(x)]))) new_format <- "d mmm yy"
    if (all(grepl("^[0-9]{2} [a-z]{4,} [0-9]{4}$", x[!is.na(x)]))) new_format <- "dd mmmm yyyy"
    if (all(grepl("^[0-9]{2} [a-z]{4,} [0-9]{2}$", x[!is.na(x)]))) new_format <- "dd mmmm yy"
    if (all(grepl("^[0-9]{1} [a-z]{4,} [0-9]{4}$", x[!is.na(x)]))) new_format <- "d mmmm yyyy"
    if (all(grepl("^[0-9]{1} [a-z]{4,} [0-9]{2}$", x[!is.na(x)]))) new_format <- "d mmmm yy"
    if (!is.null(new_format)) {
      out <- as.Date(as.character(x), format = format_datetime(new_format))
      if (!all(is.na(out))) {
        msg_clean_as(new_format, sep = separator)
        return(out)  
      }
    }
  } else if (all(grepl("^[a-z]+ [0-9]+ [0-9]+$", x[!is.na(x)]))) {
    # text, 1-2 digits, 2-4 digits (like October 21 2012)
    if (all(grepl("^[a-z]{4,} [0-9]{1} [0-9]{2}$", x[!is.na(x)]))) new_format <- "mmmm d yy"
    if (all(grepl("^[a-z]{4,} [0-9]{1} [0-9]{4}$", x[!is.na(x)]))) new_format <- "mmmm d yyyy"
    if (all(grepl("^[a-z]{4,} [0-9]{2} [0-9]{2}$", x[!is.na(x)]))) new_format <- "mmmm dd yy"
    if (all(grepl("^[a-z]{4,} [0-9]{2} [0-9]{4}$", x[!is.na(x)]))) new_format <- "mmmm dd yyyy"
    if (all(grepl("^[a-z]{3} [0-9]{1} [0-9]{2}$", x[!is.na(x)]))) new_format <- "mmm d yy"
    if (all(grepl("^[a-z]{3} [0-9]{1} [0-9]{4}$", x[!is.na(x)]))) new_format <- "mmm d yyyy"
    if (all(grepl("^[a-z]{3} [0-9]{2} [0-9]{2}$", x[!is.na(x)]))) new_format <- "mmm dd yy"
    if (all(grepl("^[a-z]{3} [0-9]{2} [0-9]{4}$", x[!is.na(x)]))) new_format <- "mmm dd yyyy"
    if (!is.null(new_format)) {
      out <- as.Date(as.character(x), format = format_datetime(new_format))
      if (!all(is.na(out))) {
        msg_clean_as(new_format, sep = separator)
        return(out)  
      }
    }
  }
  
  # now remove spaces too
  x <- gsub(" +", "", x)
  
  # try any dateformat: 1-2 day numbers, 1-3 month numbers, 2/4 year numbers, in any order
  days <- c("d", "dd", "ddd", "dddd")
  months <- c("mm", "mmm", "mmmm")
  years <- c("yyyy", "yy")
  validated_format <- function(x, a, b, c) {
    # strip any non-number ("-", ".", etc.) and remove NAs for testing
    x_withoutNAs <- x[!is.na(x)]
    # create vector with all possible options in the order of a, b, c
    format <- do.call(paste, 
                      expand.grid(a, b, c,
                                  stringsAsFactors = FALSE,
                                  KEEP.OUT.ATTRS = FALSE))
    # sort descending on character length
    format <- format[rev(order(nchar(format)))]
    format_spaced <- format
    # remove spaces from the format too, it was already removed from input
    format <- gsub(" ", "", format)
    for (i in seq_len(length(format))) {
      validated_dates <- suppressWarnings(as.Date(as.character(x_withoutNAs), 
                                                  format = format_datetime(format[i])))
      if (all(!is.na(validated_dates))
          & all(validated_dates > as.Date("1900-01-01"))
          & (all(grepl("[a-zA-Z]", x)) | all(nchar(x) == nchar(format[i])))) {
        msg_clean_as(format_spaced[i], sep = separator)
        return(format_datetime(format[i]))
      }
    }
    # no valid format found
    return(NULL)
  }
  
  # now try all `3!` (factorial(3) = 6) combinations
  # ymd ydm mdy myd dmy dym
  new_format <- validated_format(x, years, months, days)
  if (!is.null(new_format)) {
    return(as.Date(as.character(x), format = new_format))
  }
  new_format <- validated_format(x, days, months, years)
  if (!is.null(new_format)) {
    return(as.Date(as.character(x), format = new_format))
  }
  new_format <- validated_format(x, months, days, years)
  if (!is.null(new_format)) {
    return(as.Date(as.character(x), format = new_format))
  }
  new_format <- validated_format(x, years, days, months)
  if (!is.null(new_format)) {
    return(as.Date(as.character(x), format = new_format))
  }
  new_format <- validated_format(x, days, years, months)
  if (!is.null(new_format)) {
    return(as.Date(as.character(x), format = new_format))
  }
  new_format <- validated_format(x, months, years, days)
  if (!is.null(new_format)) {
    return(as.Date(as.character(x), format = new_format))
  }
  warning(ifelse(guess_each == FALSE, "Try guess_each = TRUE to guess the format for each value.\n", ""),
          "Date/time format could not be determined automatically, returning NAs", call. = FALSE)
  as.Date(rep(NA, length(x)))
}
