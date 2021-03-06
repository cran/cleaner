% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/regex_true_false.R
\name{regex_true_false}
\alias{regex_true_false}
\alias{regex_true}
\alias{regex_false}
\title{Regular expressions for \code{TRUE} and \code{FALSE}}
\source{
Wolfram Alpha, query: \url{https://www.wolframalpha.com/input/?i=20+most+spoken+languages}
}
\usage{
regex_true()

regex_false()
}
\description{
These functions just return a regular expression to define values \code{TRUE} and \code{FALSE} in the most spoken languages in the world. They are the default input for the function \code{\link{clean_logical}}.
}
\details{
Both functions support values "Yes" and "No" in the following languages: Arabic, Bengali, Chinese (Mandarin), Dutch, English, French, German, Hindi, Indonesian, Japanese, Malay, Portuguese, Russian, Spanish, Telugu, Turkish and Urdu. 

Note: all these translations are in Latin characters only (e.g. "da" for Russian, "haan" for Hindi and "hai" for Japanese).
}
