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

#' Readable date format to POSIX
#' 
#' Use this function to transform generic date/time info writing (dd-mm-yyyy) into POSIX standardised format (\%d-\%m-\%Y), see Examples.
#' @param format the format that needs to be transformed
#' @export
#' @return A \code{character} string (a POSIX standardised format)
#' @examples 
#' format_datetime("yyyy-mm-dd")
#' 
#' # Very hard to remember all these characters:
#' format(Sys.time(), "%a %b %d %Y %X")
#' 
#' # Easy to remember and write the same as above:
#' format(Sys.time(), format_datetime("ddd mmm dd yyyy HH:MM:ss"))
#' 
#' # seconds since the Epoch, 1970-01-01 00:00:00
#' format(Sys.time(), format_datetime("epoch"))
format_datetime <- function(format) {
  if (!any(grepl("%", format, fixed = TRUE))) {
    # first months and minutes, after that everything is caseINsensitive
    format <- gsub("mmmm", "%B1", format, fixed = TRUE)
    format <- gsub("mmm", "%b", format, fixed = TRUE)
    format <- gsub("mm", "%m", format, fixed = TRUE)
    format <- gsub("MM", "%M1", format, fixed = TRUE)
    format <- gsub("%m1", "%M", gsub("%b1", "%B", tolower(format), fixed = TRUE), fixed = TRUE)

    # dates
    format <- gsub("dddd", "%A", format, fixed = TRUE)
    format <- gsub("ddd", "%a", format, fixed = TRUE)
    format <- gsub("dd", "%!", format, fixed = TRUE)
    format <- gsub("d", "%e", format, fixed = TRUE)
    format <- gsub("%!", "%d", format, fixed = TRUE)
    format <- gsub("ww", "%V", format, fixed = TRUE)
    format <- gsub("w", "%V", format, fixed = TRUE)
    format <- gsub("yyyy_iso", "%G", format, fixed = TRUE)
    format <- gsub("jjjj_iso", "%G", format, fixed = TRUE)
    format <- gsub("yyyy", "%Y", format, fixed = TRUE)
    format <- gsub("jjjj", "%Y", format, fixed = TRUE)
    format <- gsub("yy_iso", "%g", format, fixed = TRUE)
    format <- gsub("jj_iso", "%g", format, fixed = TRUE)
    format <- gsub("yy", "%y", format, fixed = TRUE)
    format <- gsub("jj", "%y", format, fixed = TRUE)
    
    # time
    format <- gsub("hh", "%H", format, fixed = TRUE)
    format <- gsub("h", "%k", format, fixed = TRUE)
    format <- gsub("ss", "%S", format, fixed = TRUE)
    
    # seconds since the Epoch, 1970-01-01 00:00:00
    format <- gsub("unix", "%s", format, fixed = TRUE)
    format <- gsub("epoc%k", "%s", format, fixed = TRUE) # the h has become %k
    
    # equivalent to %Y-%m-%d (the ISO 8601 date format)
    format <- gsub("iso", "%F", format, fixed = TRUE)
    
  }
  format
}
