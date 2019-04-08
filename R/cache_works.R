#https://s3.amazonaws.com/bcfound-bigrna/doc4842.zip
#https://s3.amazonaws.com/bcfound-bigrna/ds4841.rda

#https://s3.amazonaws.com/bcfound-bigrna/studTable.rda
#https://s3.amazonaws.com/bcfound-bigrna/experTable.rda
#https://s3.amazonaws.com/bcfound-bigrna/bigrnaFiles.rda

#' return path to metadata csvs in zip file
#' @param cache instance of `BiocFileCache`, defaults to `BiocFileCache::BiocFileCache()`
#' @return path to zipfile
#' @note CSVs were retrieved using methods provided at
#' \url{https://api-omicidx.cancerdatasci.org/sra/1.0/ui/} and zipped together.  Function
#' will lodge zipfile in `cache` if not present.
#' @examples
#' path_doc4842()
#' @export
path_doc4842 = function(cache = BiocFileCache::BiocFileCache()) {
  resname = "https://s3.amazonaws.com/bcfound-bigrna/doc4842.zip" 
  allr = BiocFileCache::bfcinfo(cache)$rname
  if (!(resname %in% allr)) message("one time retrieval for ", resname)
  BiocFileCache::bfcrpath(cache, resname)
}

#' return instance of ssrch::DocSet with metadata on 4841 human
#' transcriptome studies in NCBI SRA
#' @param cache instance of `BiocFileCache`, defaults to `BiocFileCache::BiocFileCache()`
#' @param csv_zip_path a path leading to the zip file of CSV for metadata in the DocSet instance
#' @note will bind the correct value of `zipf` in `environment(ds4841@doc_retriever)`, which depends on details of installation
#' @return instance of DocSet as defined in ssrch package
#' @examples
#' get_ds4841()
#' @export
get_ds4841 = function(cache = BiocFileCache::BiocFileCache(), 
    csv_zip_path=path_doc4842()) {
  resname = "https://s3.amazonaws.com/bcfound-bigrna/ds4841.rda"
  allr = BiocFileCache::bfcinfo(cache)$rname
  if (!(resname %in% allr)) message("one time retrieval for ", resname)
  ans = get(load(BiocFileCache::bfcrpath(cache, resname)))
  assign("zipf", csv_zip_path, envir=environment(ans@doc_retriever))
  ans
}

#' obtain listing of contents of BigRNA compendium (salmon runs)
#' @param cache instance of `BiocFileCache`, defaults to `BiocFileCache::BiocFileCache()`
#' @return a named vector
#' @examples
#' if (interactive()) head(load_bigrnaFiles())
#' @export
load_bigrnaFiles = function(cache = BiocFileCache::BiocFileCache()) {
  resname = "https://s3.amazonaws.com/bcfound-bigrna/bigrnaFiles.rda"
  allr = BiocFileCache::bfcinfo(cache)$rname
  if (!(resname %in% allr)) message("one time retrieval for ", resname)
  get(load(BiocFileCache::bfcrpath(cache, resname)))
}

#' obtain listing of experiments and submission date/time in compendium
#' @param cache instance of `BiocFileCache`, defaults to `BiocFileCache::BiocFileCache()`
#' @return a data.frame
#' @examples
#' if (interactive()) head(load_experTable())
#' @export
load_experTable = function(cache = BiocFileCache::BiocFileCache()) {
  resname = "https://s3.amazonaws.com/bcfound-bigrna/experTable.rda"
  allr = BiocFileCache::bfcinfo(cache)$rname
  if (!(resname %in% allr)) message("one time retrieval for ", resname)
  get(load(BiocFileCache::bfcrpath(cache, resname)))
}

#' obtain listing of all studies in compendium
#' @param cache instance of `BiocFileCache`, defaults to `BiocFileCache::BiocFileCache()`
#' @return a data.frame
#' @examples
#' if (interactive()) head(load_studTable())
#' @export
load_studTable = function(cache = BiocFileCache::BiocFileCache()) {
  resname = "https://s3.amazonaws.com/bcfound-bigrna/studTable.rda"
  allr = BiocFileCache::bfcinfo(cache)$rname
  if (!(resname %in% allr)) message("one time retrieval for ", resname)
  get(load(BiocFileCache::bfcrpath(cache, resname)))
}
