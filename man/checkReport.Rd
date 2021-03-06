% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check.R
\name{checkReport}
\alias{checkReport}
\title{Check report compatibility}
\usage{
checkReport(report)
}
\arguments{
\item{report}{Logical. Should an HTML report be created at the end of the
analysis? NOTE: Setting report to TRUE will generate an HTML file in the current
directory. Additionally, if auto.open = TRUE (default), the web browser will
automatically be launched to open the report once the function terminates.}
}
\value{
An updated report argument (logical)
}
\description{
Checks if pandoc is up and running and creates a "Report" folder, if necessary
}
\keyword{internal}
