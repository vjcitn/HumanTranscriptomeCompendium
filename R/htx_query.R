
#' subset compendium through keyword lookup
#' @importFrom ssrch kw2docs
#' @importFrom utils read.csv
#' @param query character(1) to be found in ls(ssrch::kw2docs(get_ds4841()))
#' @param tryGrep logical(1) if TRUE, `query` does not match any keyword directly, it will be treated as a regular expression and the vector of keywords will be grepped for pattern `query`; defaults to TRUE
#' @param ignore.case logical(1) used when tryGrep is TRUE, defaults to TRUE
#' @param \dots passed to `htx_query_by_study_accession`
#' @note The DocSet instance returned by `get_ds4841()` is used.  Lookups are case-sensitive.
#' Look carefully at note for `htx_query_by_study_accession` to
#' understand logic of incrementing metadata on a given
#' input SummarizedExperiment.
#' @return SummarizedExperiment instance
#' @examples
#' htx_query_by_text("HNRNPC")
#' @export
htx_query_by_text = function(query, ..., tryGrep=TRUE, ignore.case=TRUE) {
#
# bypass doc_retriever facility to simplify logic
#
 docset = get_ds4841()
 kw2d = kw2docs(docset)
 actual_kw = ls(envir=kw2d)
 studies = try(get(query, envir=kw2d), silent=TRUE)
 if (inherits(studies, "try-error")) {
    if (tryGrep) {
       hits = grep(query, actual_kw, ignore.case=ignore.case) # find matching keywords
       if (length(hits)>0) {
          studies = unique(unlist(lapply(actual_kw[hits], function(x)
                             get(x, kw2d))))
          }
       }
    }
 if (inherits(studies, "try-error")) stop("query not found in index [keywords to studies]")
 htx_query_by_study_accession(studies, ...)
}

#' retrieve 'restfulSE' SummarizedExperiment instance for selected studies in htx compendium
#' @importFrom S4Vectors metadata metadata<-
#' @param studies character vector of study accessions
#' @param htxSE SummarizedExperiment instance, typically the result of htx_load(), which we don't want to repeat needlessly
#' @param \dots passed to `htx_load`, ignored if `se` is nonmissing
#' @note This function was designed to perform a single
#' query on a 'fresh' compendium image from `htx_load()`.  However,
#' one could consider iterating the process to build up
#' metadata on multiple series of studies.  This is not likely
#' to succeed without careful manipulation of the colData of the
#' input SummarizedExperiment.  A message will be written if
#' the input SummarizedExperiment appears to be other than a 'fresh'
#' `htx_load` result.
#' @return SummarizedExperiment instance
#' @examples
#' htx_query_by_study_accession("ERP011411")
#' @export
htx_query_by_study_accession = function(studies, htxSE, ...) {
 if (missing(htxSE)) { # assume we have htx_load() result
  message("acquiring base restfulSE...")
  htxSE = htx_load(...)
  }
 if (ncol(htxSE) != 181134) message("non-fresh htxSE in use; unexpected results may ensue.")
 zpath = metazip_path()
 metas = lapply(studies, function(x) {
   fn = paste0(x, ".csv")
   con = unz(zpath, fn)
   ans = read.csv(con, stringsAsFactors=FALSE)
   bad = which(duplicated(ans$experiment.accession))
   if (length(bad)>0) ans = ans[-bad,]
# ans will have experiment.accession, which must be found in colnames(htxSE)
   rownames(ans) = ans$experiment.accession
   okids = intersect(rownames(ans), colnames(htxSE))
   ans[okids,]
   })
 names(metas) = studies
 metadata(htxSE) = c(metadata(htxSE), metas)
 htxSE[, which(htxSE$study_accession %in% studies)]
}


