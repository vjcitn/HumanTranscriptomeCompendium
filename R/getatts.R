
# this function will process the sample.attributes
# element of the tibbles returned by SRAdbV2
# ft is a character vector of 'forced tags'
attproc = function (x, ft) 
{
    tt = x[[1]][, 1]
    if (is.null(ft)) {
        vals = lapply(x, "[[", "value") 
        } else {
      vals = lapply(x, function(z) {
       tmp = z[, "value", drop=TRUE]  # from data.frame
       names(tmp) = z[,"tag", drop=TRUE]
       ans = tmp[ft]
       ans })
      }
    ans = do.call(rbind, vals)
    if (is.null(ft)) {
        colnames(ans) = tt } else colnames(ans) = ft
    ans
}


getStudy = function(studyAcc) {
if (!requireNamespace("SRAdbV2")) stop("install SRAdbV2 to use this function")
SRAdbV2::Omicidx$new()$search(q=
  sprintf("study.accession: %s", studyAcc))$scroll()$collate()
}

#' retrieve a normalized data.frame of sample attributes for SRAdbV2 study tibbles
#' @param studyAcc character(1) accession
#' @param returnBad logical(1) returns tibble of experiment metadata for which number 
#' of fields in sample.attributes is less than the number in the majority
#' @param forcedTags NULL or character(), introduced to cope with studies
#' for which SRA metadata has inconsistent field sets across experiments.
#' Supply a vector of tags that need to be retrieved; when the metadata
#' lacks a value for the tag it is filled with NA.
#' @note Sometimes a field is omitted for control experiments, and with manual programming
#' conformant metadata can be produced for these experiments.  Sometimes there is substantial
#' diversity among sample.attribute fields recorded within a study.
#' @return a data.frame instance
#' @examples
#' if (interactive()) {
#'   sa = sampleAtts("SRP027530")
#'   head(sa)
#' }
#' @export
sampleAtts = function(studyAcc, returnBad=FALSE, forcedTags=NULL) {
 if (!requireNamespace("dplyr")) stop("install dplyr to use this function")
 st = getStudy(studyAcc)
 nr = nrow(st)
 if (nr==0) return(data.frame(study.accession=studyAcc, norowsInGetStudy=TRUE))
 sampatts = dplyr::select(st, sample.attributes)[[1]]
 nrs = vapply(sampatts, nrow, numeric(1))
 if (is.null(forcedTags) & !all(nrs==nrs[1])) {
  message("varying numbers of sample.attributes recorded through study")
  message("taking union of all available tags for study")
  allt = lapply(sampatts, function(x) x[,"tag",drop=TRUE])
  forcedTags = unique(unlist(allt))
#  nrt = table(nrs)
#  ind = which.max(nrt) # modal attr count
#  num2use = as.numeric(names(nrt)[ind])
#  bad = st[which(nrs < num2use),]
#  nb = nrow(bad)
##  if (!returnBad) message(nb, " experiments were excluded, use 'returnBad=TRUE' to see why their sample attributes are different from the majority")
#  st = st[-which(nrs < num2use),]
  }
 ea = st$experiment.accession
 procd = attproc(st$sample.attributes, forcedTags)
 np = nrow(procd)
 if (np != nr) message("metadata on ", nr-np, " experiments could not be processed; set returnBad = TRUE to get full metadata on the excluded experiments")
 if (returnBad) return(bad)
 data.frame(cbind(study.accession=studyAcc, 
    experiment.accession=ea, procd),
    stringsAsFactors=FALSE)
}

#getPMID = function (acc) 
#{
#    n1 = getStudy(acc)
#    att = try(n1$study.xrefs[[1]], silent=TRUE)
#    if (inherits(att, "try-error")) return(NA_character_)
#    poss = which(tolower(att$db) == "pubmed")[1]
#    if(length(poss)==0) return(NA_character_)
#    as.character(att$id[poss])
#}

