#' use SRAdbV2 to get one PMID for a study
#' @param acc character(1) study accession number
#' @return character string of PMID or NA_character_
#' @examples
#' if (interactive()) getPMID("SRP057500")
#' @export
getPMID = function (acc) 
{
    if (!requireNamespace("SRAdbV2")) 
        stop("install SRAdbV2 to use this function")
    n1 = SRAdbV2::Omicidx$new()$search(q = sprintf("study.accession: %s", 
        acc), size=5)$scroll()$yield()
    suppressWarnings({att = try(n1$study.xrefs[[1]], silent = TRUE)})
    if (is.null(att) || inherits(att, "try-error")) 
        return(NA_character_)
    poss = which(tolower(att$db) == "pubmed")[1]
    if (length(poss) == 0)  
        return(NA_character_)
    as.character(att$id[poss])
}

