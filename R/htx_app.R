
#' explore SRA metadata
#' @import shiny
#' @note This function deals with
#' extraction of compendium elements.  The overall scope is
#' determined by HumanTranscriptomeCompendium::studTable which is the list of
#' all studies with taxon 9606, strategy RNA-seq,
#' source transcriptomic.  Some studies will not have
#' experiments in the compendium, and if such are selected,
#' a warning will be generated in the session.
#' @examples
#' if (interactive()) htx_app()
#' @export
htx_app = function() {
 message("acquiring compendium restfulSE...")
 htxSE = htx_load()
 message("done.")
 studdata = HumanTranscriptomeCompendium::studTable
 studdata = studdata[which(
     studdata$experiment_accession %in% colnames(htxSE)),]
 todrop = which(duplicated(studdata$experiment_accession))
 if (length(todrop)>0) studdata = studdata[-todrop,]
 ui = fluidPage(
  sidebarLayout(
   sidebarPanel(
    helpText(h2("SRA human RNA-seq extractor.")),
    helpText("Add study accession numbers to 
'keep' box. SummarizedExperiment will
be returned when 'return SE' is pressed.
To browse all records, clear the 'keep' box."),
    actionButton("btnSend", strong("return SE")),
    textInput("concept", "concept (regexp ok)", "cancer"), width=3,
    selectInput("studyAcc", "keep", unique(studdata$study_accession),
      multiple=TRUE)
   ),
   mainPanel(
    tabsetPanel(
     tabPanel("studies", 
       dataTableOutput("conceptTable")
     ),
     tabPanel("background",
       textOutput("info")
     )
    )
   )
  )
 )
 server = function(input, output) {
  output$info = renderText({
   nexp = ncol(htxSE)-2
   nstud = length(unique(studdata$study_accession))
   sprintf("RNA-seq quantifications from %d experiments of
%d studies were developed by Dr. Sean Davis of the National
Cancer Institute by reprocessing all RNA-seq studies in the NCBI SRA.",
 nexp, nstud)
   })
  output$conceptTable = renderDataTable({
   curTable = studdata
   inds = grep(input$concept, curTable$study_title)
   validate( need(length(inds)>0, "concept not found in titles") )
   tmp = curTable[ inds, ]
   tmp = tmp[-which(duplicated(tmp$study_accession)),]
   rownames(tmp) = tmp$study_accession
   nperstud = table(curTable$study_accession)
   npvec = nperstud[rownames(tmp)]
   tmp = cbind(Nexp=as.numeric(npvec), tmp[,-1])
   tmp
   }, options=list(lengthMenu=c(5,10,25,50), pageLength=10))
  observe({ if (input$btnSend > 0) isolate({
          curTable = studdata
          curTable = curTable[which(curTable$study_accession %in% input$studyAcc),]
          notin = setdiff(curTable$experiment_accession, HumanTranscriptomeCompendium::HumanTranscriptomeCompendium.colnames)
          if (length(notin)>0) warning("some experiments requested not present in HumanTranscriptomeCompendium.colnames, returning only those available")
          touse = intersect(curTable$experiment_accession, HumanTranscriptomeCompendium::HumanTranscriptomeCompendium.colnames)
          attempt = htxSE[, sort(touse)]
          mtit = paste(attempt$study_accession, attempt$study_title, sep=": ")
          tis = unique(mtit)
          metadata(attempt) = c(metadata(attempt), titles=tis)
          stopApp(returnValue=attempt)
                  }) })
  }
 runApp(list(ui=ui, server=server))
}
 
