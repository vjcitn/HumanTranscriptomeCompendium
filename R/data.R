#' experiment-level metadata
#' @docType data
#' @format data.frame
#' @source SRAdbV2 28 June 2018
#' @examples
#' head(HumanTranscriptomeCompendium::experTable)
"experTable"
#' study-level metadata
#' @docType data
#' @format data.frame
#' @source SRAdbV2 28 June 2018
#' @examples
#' head(HumanTranscriptomeCompendium::studTable)
"studTable"
#' experiment accessions available in compendium as of may 12 2018
#' @docType data
#' @format data.frame
#' @source SRAdbV2 may 12 2018
#' @examples
#' head(HumanTranscriptomeCompendium::uniqueAcc_120518)
"uniqueAcc_120518"
#' character vector of available samples in HDF cloud assay representation
#' @docType data
#' @format character vector
#' @source compendium processing
#' @examples
#' head(HumanTranscriptomeCompendium::HumanTranscriptomeCompendium.colnames)
"HumanTranscriptomeCompendium.colnames"
#' bigrnaFiles: vector of files in bigrna
#' @docType data
#' @format vector of 186K character strings
#' @examples
#' \dontrun{
#' # this is slow
#' head(HumanTranscriptomeCompendium::bigrnaFiles)
#' }
"bigrnaFiles"
#' ds4842: ssrch::DocSet instance with most BigRNA studies
#' @docType data
#' @format DocSet class instance
"ds4842"
