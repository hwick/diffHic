# These are just placeholders for the real things in inst/tests.

suppressWarnings(suppressPackageStartupMessages(require(diffHic)))

hic.file <- system.file("exdata", "hic_sort.bam", package="diffHic")
cuts <- readRDS(system.file("exdata", "cuts.rds", package="diffHic"))
param <- pairParam(fragments=cuts)

# Setting up the parameters
fout <- "output.h5"
preparePairs(hic.file, param, file=fout)
head(getPairData(fout, param))

loadChromos(fout)
head(loadData(fout, "chrA", "chrA"))
head(loadData(fout, "chrA", "chrB"))

# Loading the counts.
data <- squareCounts(fout, param, width=50, filter=1)
data

margins <- marginCounts(fout, param, width=50)
margins
totalCounts(fout, param)

regions <- GRanges("chrA", IRanges(c(1, 100, 150), c(20, 140, 160)))
connectCounts(fout, param, regions=regions, filter=1L)

# Checking some values.
head(getArea(data))
head(pairdist(data))

anchors(data, type="first")
anchors(data, type="second")
assay(data)
regions(data)

data$totals
colData(data)
metadata(data)

asDGEList(data)
asDGEList(data, lib.size=20)$samples
asDGEList(data, norm.factors=2, group="a")$samples

# Playing around with some bin counts.
stuff <- correctedContact(data)
head(stuff$truth)

data.large <- squareCounts(fout, param, width=100, filter=1)
boxed <- boxPairs(larger=data.large, smaller=data)
head(boxed$indices$larger)
head(boxed$indices$smaller)

head(enrichedPairs(data))
head(clusterPairs(data, tol=10)$indices[[1]])

# End.

unlink(fout)
