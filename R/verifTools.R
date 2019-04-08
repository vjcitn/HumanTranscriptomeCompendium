#' acquire a single sample from bigRNA compendium specified by accession
#' and develop gene-level quantifications using tximport
#' @param acc character(1) sample-level accession as defined in SRA
#' @param tx2gene a data.frame instance mapping transcript identifiers
#' used in the compendium to gene identifiers.  See note.
#' @param urlprefix character(1) where the salmon run outputs are lodged,
#' with \code{acc} a subfolder defined through the manifestData parameter.
#' @param manifestdata a character vector defining folders (under
#' \code{results/human/27/} with salmon outputs.
#' @param regexp a character(1) regular expression for filtering
#' filename elements in \code{manifestdata} to define which salmon output
#' components in the bigrna compendium are retrieved.
#' @note The tx2gene_gencode function supplied with this package
#' uses the tximportData package contents to create the data.frame
#' for use as tx2gene.  The system2 function is used to generate
#' folders to be used by tximport.
#' @return the result of a tximport run
#' @examples
#' # this example involves nontrivial internet communications
#' args(procExpToGene)
#' \dontrun{
#' td = tempdir()
#' od = getwd()
#' setwd(td)
#' nn = procExpToGene("ERX1097381")
#' str(nn)
#' setwd(od)
#' }
#' @export
procExpToGene = function (acc, tx2gene = tx2gene_gencode27(), urlprefix = "http://bigrna.cancerdatasci.org/", 
    manifestdata = HumanTranscriptomeCompendium::load_bigrnaFiles(), regexp = "quant.sf.bz2|json") 
{
    if (file.exists(acc)) 
        stop("will not overwrite existing file")
    files = grep(acc, manifestdata, value = TRUE, fixed = TRUE)
    stopifnot(length(files) == 21)
    if (!is.null(regexp)) 
        files = files[grep(regexp, files)]
    curd = getwd()
    system2("mkdir", args = acc)
    system2("mkdir", args = paste0(acc, "/aux_info"))
    system2("mkdir", args = paste0(acc, "/libParams"))
    system2("mkdir", args = paste0(acc, "/logs"))
    system2("mkdir", args = paste0(acc, "/aux_info/bootstrap"))
    setwd(acc)
    fns = paste(urlprefix, files, sep = "")
    jnk = lapply(fns, function(x) system2("wget", args = x))
    if (is.null(regexp)) 
        system("mv *.txt *.json *.bz2 *tsv *.log aux_info")
    if (!is.null(regexp)) 
        system2("mv", " *.json *.bz2 aux_info")
    setwd("aux_info")
    system2("mv", " quant* ..")
    system("mv cmd_info.json ..")
    system("mv lib_format_counts.json ..")
    if (is.null(regexp)) {
        system("mv flenDist.txt ../libParams")
        system("mv salmon_quant.log ../logs")
    }
    setwd(curd)
    fn = sprintf("%s/quant.sf.bz2", acc)
    ans = try(tximport::tximport(fn, type = "salmon", txOut = FALSE, 
        tx2gene = tx2gene, countsFromAbundance = "lengthScaledTPM", 
        dropInfReps = TRUE, existenceOptional = TRUE))
    if (!inherits(ans, "try-error")) {
        try(ulcode <- unlink(acc, recursive = TRUE))
        if (ulcode != 0) 
            warning(sprintf("unlink of %s failed", acc))
    }
    if (inherits(ans, "try-error")) 
        warning(sprintf("an error was encountered in tximport, so %s is still present", 
            acc))
    ans
}

#' generate a data.frame mapping gencode 27 ensembl transcript identifiers to ensembl gene identifiers
#' @note Uses CSV in tximportData to acquire the information.
#' @return a data.frame with 200401 rows mapping transcript 
#' identifiers in column 1 to 58288 gene symbols in column 2.
#' @examples
#' head(tx2gene_gencode27())
#' @export
tx2gene_gencode27 = function () 
{
    if (!requireNamespace("tximportData")) 
        stop("install tximportData to use this package")
    dir <- system.file("extdata", package = "tximportData")
    utils::read.csv(file.path(dir, "tx2gene.gencode.v27.csv"), stringsAsFactors = FALSE)
}

#sample(ss, size=5)
#x5 = .Last.value
#xc = lapply(x5, function(x) procExpToGene)
#x5
#xc
#xc = lapply(x5, function(x) procExpToGene(x))
#str(xc)
#match(x5,sn)
#match(x5,ss)
#rr = h5read("htxcomp_genes.h5", "counts", index=list(NULL, .Last.value))
#apply(rr,2,sum)
#savehistory(file="verify.hist.txt")

