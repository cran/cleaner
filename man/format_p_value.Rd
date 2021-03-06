% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_p_value.R
\name{format_p_value}
\alias{format_p_value}
\title{Format p values (APA guideline)}
\usage{
format_p_value(p, alpha = 0.05, prepend_p = FALSE)
}
\arguments{
\item{p}{p value(s) to transform}

\item{alpha}{the value of alpha, defaults to 0.05}

\item{prepend_p}{a logical to indicate whether "p =" should be prepended to the result}
}
\value{
A character
}
\description{
This function will round p values according to the APA guideline. It will try to round to two decimals where possible, and will try to avoid printing the value of \code{alpha}, see Examples.
}
\examples{
format_p_value(0.345678)
format_p_value(0.05125)

# this must not be "0.05", but is not "0.049" either,
# so it will add as many decimals as needed:
format_p_value(0.04993) 

format_p_value(c(0.123, 0.00000001))
format_p_value(c(0.123, 0.00000001), prepend_p = TRUE)
}
