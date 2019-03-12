#' retrieve 'restfulSE' SummarizedExperiment instance for selected studies in htx compendium
#' @param study_accessions character vector of study accessions
#' @param \dots passed to loadHtxcomp
#' @return SummarizedExperiment instance
#' @examples
#' htx_query("ERP011411")
#' @export
htx_query = function(study_accessions, ...) {
 message("acquiring base restfulSE...")
 htxSE = htx_load(...)
 studdata = HumanTranscriptomeCompendium::studTable
 studdata = studdata[which(
     studdata$experiment_accession %in% colnames(htxSE)),]
 todrop = which(duplicated(studdata$experiment_accession))
 if (length(todrop)>0) studdata = studdata[-todrop,]
 exps = studdata$experiment_access[which(studdata$study_accession %in%
        study_accessions)]
 htxSE[, exps]
}
