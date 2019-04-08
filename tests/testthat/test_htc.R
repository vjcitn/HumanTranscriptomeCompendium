#
# exported
#
# [1] "addRD"                                
# [2] "bigrnaFiles"                          
# [3] "ds4842"                               
# [4] "experTable"                           
# [5] "getPMID"                              
# [6] "htx_app"                              
# [7] "htx_load"                             
# [8] "htx_query_by_study_accession"         
# [9] "htx_query_by_text"                    
#[10] "HumanTranscriptomeCompendium.colnames"
#[11] "procExpToGene"                        
#[12] "sampleAtts"                           
#[13] "studTable"                            
#[14] "tx2gene_gencode27"                    
#[15] "uniqueAcc_120518"                     


library(HumanTranscriptomeCompendium)

hh = htx_load()  # reuse
ll = load_bigrnaFiles()
xx = load_experTable()

context("basic objects")
test_that("key sizes are as expected", {
  expect_true(length(ll) == 3829708)
# following help to determine if source has changed
# and may need additional tests or doc
  expect_true(length(as.list(body(htx_query_by_study_accession)))==8)
  expect_true(length(as.list(body(htx_query_by_text)))==8)
  expect_true(length(as.list(body(htx_app))) == 11)
  expect_true(all(dim(xx)==c(294174,3)))
  expect_true(all(dim(hh)==c(58288L, 181134L)))
})

context("query resolution")

test_that("query resolution works", {
  nn = htx_query_by_text("HNRNPC", hh)
  expect_true(all(dim(nn) == c(58288L, 37L)))
  nn = htx_query_by_text("Triple", hh)
  expect_true(all(dim(nn) == c(58288L, 546L)))
})
 

