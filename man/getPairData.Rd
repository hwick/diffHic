\name{getPairData}
\alias{getPairData}

\title{Get read pair data}
\description{Extract diagnostics for each read pair from an index file}

\usage{
getPairData(file, param)
}

\arguments{
\item{file}{character string, specifying the path to the index file produced by \code{\link{preparePairs}}}
\item{param}{a \code{pairParam} object containing read extraction parameters}
}

\value{
A dataframe is returned containing integer fields for \code{length}, \code{orientation} and \code{insert} for each read pair.
}

\details{
This is a convenience function to extract read pair diagnostics from an index file, generated from a Hi-C library with \code{\link{preparePairs}}. 
The aim is to examine the distribution of each returned value to determine the appropriate cutoffs for \code{\link{prunePairs}}. 

The \code{length} refers to the length of the DNA fragment used in sequencing.
It is computed for each read pair by adding the distance of each read to the closest restriction site in the direction of the read. 
This will be set to \code{NA} if the fragment IDs are non-positive, e.g., for DNase Hi-C data (where the concept of fragments is irrelevant anyway).

The \code{insert} simply refers to the insert size for each read pair.
This is defined as the distance between the extremes of each read on the same chromosome.
Values for interchromosomal pairs are set to \code{NA}.

For \code{orientation}, setting 0x1 or 0x2 means that the read mapped into the first or second anchor fragment respectively is on the reverse strand.
For intrachromosomal reads, an orientation value of 1 represents inward-facing reads whereas a value of 2 represents outward-facing reads.

\code{getPairData} will now respect any settings of \code{restrict}, \code{discard} or \code{cap} in the input \code{pairParam} object.
Statistics will not be reported for read pairs that lie outside of restricted chromosomes, within discarded regions or exceed the cap for a restriction fragment pair.
Note that \code{cap} will be ignored for DNase-C experiments as this depends on an unknown bin size.

}

\seealso{
\code{\link{preparePairs}},
\code{\link{prunePairs}}
}

\author{Aaron Lun}

\examples{
hic.file <- system.file("exdata", "hic_sort.bam", package="diffHic")
cuts <- readRDS(system.file("exdata", "cuts.rds", package="diffHic"))
param <- pairParam(cuts)


tmpf <- tempfile(fileext=".h5")
invisible(preparePairs(hic.file, param, tmpf))
getPairData(tmpf, param)
}

\keyword{diagnostics}
