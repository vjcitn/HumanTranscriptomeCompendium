htx_check_cache = function (cache = BiocFileCache::BiocFileCache(), genesOnly=TRUE) 
{
    if (!requireNamespace("BiocFileCache")) stop("install BiocFileCache to use this function")
    allr = BiocFileCache::bfcinfo(cache)$rname
    "https://s3.amazonaws.com/bcfound-bigrna/htxcompSE.rds" %in% 
        allr
}


# WOULD importFrom BiocFileCache bfcinfo BiocFileCache bfcrpath
#' load a SummarizedExperiment shell for the Human Transcriptome Compendium
#' @importFrom S4Vectors mcols
#' @importFrom SummarizedExperiment rowRanges rowData<-
#' @param remotePath path to an RDS representation of the DelayedArray-based SummarizedExperiment
#' @param cache a BiocFileCache instance, defaulting to value of BiocFileCache()
#' @param genesOnly logical(1) if TRUE return reference to 
#' SummarizedExperiment with gene-level quantifications; in this 
#' case the remotePath value is
#' set to `https://s3.amazonaws.com/bcfound-bigrna/rangedHtxGeneSE.rds`.
#' @return a RangedSummarizedExperiment instance
#' @examples
#' htx_load
#' @export
htx_load = function (remotePath = "https://s3.amazonaws.com/bcfound-bigrna/htxcompSE.rds",
    cache = BiocFileCache::BiocFileCache(), genesOnly=TRUE) 
{
    if (!requireNamespace("BiocFileCache")) stop("install BiocFileCache to use this function")
    if (!htx_check_cache(cache)) 
        message("adding RDS to local cache, future invocations will use local image")
    if (genesOnly) remotePath = "https://s3.amazonaws.com/bcfound-bigrna/rangedHtxGeneSE.rds"
    path = BiocFileCache::bfcrpath(cache, remotePath)
    readRDS(path)
}

#' add gene-level rowData derived from transcript level rowRanges
#' @param x result of htx_load()
#' @return RangedSummarizedExperiment with enhanced rowData
#' @examples
#' # this function operates on a SummarizedExperiment that has
#' # transcript-level rowRanges but gene-level quantifications
#' addRD
#' @export
addRD = function(x) {
 txl = unlist(rowRanges(x), use.names=FALSE)
 drp = which(duplicated(txl$gene_id))
 txl = txl[-drp]
 rowData(x) = mcols(txl)[, c("gene_type", "gene_id", "gene_name", "havana_gene")]
 x
}
 
