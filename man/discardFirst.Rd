% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load.R
\name{discardFirst}
\alias{discardFirst}
\title{Discard early detections}
\usage{
discardFirst(input, bio, trim)
}
\arguments{
\item{input}{The detections list}

\item{bio}{The biometrics table}

\item{trim}{The threshold time after release, in hours}
}
\value{
the updated detections list
}
\description{
Discard early detections
}
\keyword{internal}
