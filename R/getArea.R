getArea <- function(data, bp=TRUE)
# Computes the area of the interaction space, either in base pair-squared terms
# or in terms of pairs of restriction fragments. This allows adjustment of
# abundances for comparison between differently-sized areas. Special behaviour
# is necessary on the diagonal, as reflection halves the space. Coercion to 
# double is necessary to prevent overflows of the integer type.
# 
# written by Aaron Lun
# created 30 July 2014
# last modified 8 December 2015
{
    .check_StrictGI(data)
	ax <- anchors(data, type="first", id=TRUE)
	tx <- anchors(data, type="second", id=TRUE)
	reg <- regions(data)

	if (bp) {
		cur.width <- as.double(width(reg))
		returned <- cur.width[ax] * cur.width[tx]

		# Accounting for special behaviour around the diagonal.	It you don't halve,
		# you'll have to double every other (unreflected) area.
		overlap <- pairdist(data, type="gap")
		is.olap <- !is.na(overlap) & overlap < -0.5
		lap.dist <- -overlap[is.olap]
		self.lap.area <- lap.dist * (lap.dist - 1)/2		
		returned[is.olap] <- returned[is.olap] - self.lap.area
	} else {
		is.same <- ax==tx
		curnfrag <- as.double(reg$nfrags[ax])
		returned <- curnfrag * reg$nfrags[tx]
		returned[is.same] <- curnfrag[is.same]*(curnfrag[is.same]+1)/2

		# Detour to protect against overlapping regions.
		left.edge <- pmax(start(reg)[ax], start(reg)[tx])
		right.edge <- pmin(end(reg)[ax], end(reg)[tx])
		is.partial <- !is.same & right.edge >= left.edge & 
			as.logical(seqnames(reg)[ax]==seqnames(reg)[tx]) 

		if (any(is.partial)) { 
			right.edge <- right.edge[is.partial]
			left.edge <- left.edge[is.partial]
			by.chr <- split(seq_len(sum(is.partial)), as.character(seqnames(reg)[ax][is.partial]))
			fragments <- metadata(data)$param$fragments
			fdata <- .splitByChr(fragments)

			for (x in seq_along(fdata$chrs)) {
				current.chr <- fdata$chrs[x]
				curdex <- by.chr[[current.chr]]
				if (is.null(curdex)) { next }
		
				indices <- fdata$first[x]:fdata$last[x]
				right.olap <- match(right.edge[curdex], end(fragments)[indices])
				left.olap <- match(left.edge[curdex], start(fragments)[indices])
				if (any(is.na(right.olap)) || any(is.na(left.olap))) { stop("region boundaries should correspond to restriction fragment boundaries") }
		
				n.overlap <- right.olap - left.olap + 1	
				returned[is.partial][curdex] <- returned[is.partial][curdex] - n.overlap*(n.overlap-1)/2
			}
		}
	}

	return(returned)
}
