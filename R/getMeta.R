##' utility for adding metadata to htxcomp extraction, using SRAdbV2
##' @param study.accession character(1) accession identifier
##' @param entity character(1) level of metadata retrieval, can be "full", "study", "experiment",
##' see SRAdbV2 documentation
##' @param asDataFrame logical(1) if FALSE, return a tibble as produced by SRAdbV2, otherwise
##' return an S4Vectors DataFrame based on atomic columns of the tibble, 
##' in which non-atomic columns in the tibble are placed in
##' the metadata component 
##' @return either a tibble or DataFrame depending on value of asDataFrame
##' @examples
##' requireNamespace("SRAdbV2")
##' requireNamespace("S4Vectors")
##' chk = getMeta()
##' head(names(chk))
##' names(S4Vectors::metadata(chk)$non.atomic)
##' chk[1:3,1:5]
#getMeta = function(study.accession="ERP005938", entity="full",
#   asDataFrame=TRUE) {
# stopifnot(is(study.accession, 'character'), length(study.accession)==1)
# oidx = SRAdbV2::Omicidx$new()
# ans = try(oidx$search(sprintf("study.accession: '%s'", study.accession),
#               entity=entity)$scroll()$collate())
# if (!asDataFrame) return(ans)
# DF = S4Vectors::DataFrame(as.data.frame(ans[,which(ato)]))
# if (any(!ato)) S4Vectors::metadata(DF) = list(non.atomic=ans[,-which(ato)])
# DF
#}
#
