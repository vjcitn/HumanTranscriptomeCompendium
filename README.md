---
title: "htxcomp -- a compendium of sequenced human transcriptomes"
date: "`r format(Sys.time(), '%B %d, %Y')`"
vignette: >
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteIndexEntry{htxcomp -- a compendium of sequenced human transcriptomes}
  %\VignetteEncoding{UTF-8}
output:
  BiocStyle::html_document:
    highlight: pygments
    number_sections: yes
    theme: united
    toc: yes
---

```{r setup,echo=FALSE,results="hide"}
suppressPackageStartupMessages({
suppressMessages({
library(BiocStyle)
library(htxcomp)
library(beeswarm)
library(SummarizedExperiment)
library(DT)
})
})
```

# Introduction

Comprehensive archiving of genome-scale sequencing experiments
is valuable for substantive and methodological progress in
multiple domains.

The `r Biocpkg("htxcomp")` package provides functions for interacting
with quantifications and metadata for over 180000 sequenced human
transcriptomes.

# Access to gene-level quantifications

`r Biocpkg("BiocFileCache")` is used to manage access
to a modest collection of metadata about compendium
contents.  By default, `loadHtxcomp` will
load the cache and establish a connection to
remote HDF5 representation of quantifications.
As of 26 November 2018 the gene level quantifications
are obtained via an HDF Server instance run
by Channing Division of Network Medicine at
Brigham and Women's Hospital.

```{r lklo}
library(htxcomp)
genelev = loadHtxcomp()
genelev
assay(genelev)
```

## Identifying single-cell RNA-seq studies

We use crude pattern-matching in the study titles
to identify single cell RNA-seq experiments 
```{r lksi}
sing = grep("single.cell", genelev$study_title, 
   ignore.case=TRUE)
length(sing)
```

Now we will determine which studies are involved.
We will check out the titles of the single-cell
studies to assess the specificity of this approach.

```{r chkspec}
sa = genelev$study_accession[sing]
sing2 = sing[-which(duplicated(sa))]
length(sing2)
datatable(as.data.frame(colData(genelev[,sing2])),
   options=list(lengthMenu=c(3,5,10,50,100)))
```

## Collecting bulk RNA-seq samples on a disease of interest: glioblastoma


```{r lkchar}
bulk = genelev[,-sing]
kpglio = grep("glioblastoma", bulk$study_title, 
  ignore.case=TRUE)
glioGene = bulk[,kpglio]
glioGene
```

To acquire numerical values, `as.matrix(assay())` is needed.
```{r lkmat}
beeswarm(as.matrix(assay(
   glioGene["ENSG00000138413.13",1:100])), pwcol=as.numeric(factor(glioGene$study_title[1:100])), ylab="IDH1 expression")
legend(.6, 15000, legend=unique(glioGene$study_accession[1:100]),
   col=1:2, pch=c(1,1))
```

# Access to transcript-level quantifications

By setting `genesOnly` to FALSE in `loadHtxcomp`,
we get a transcript-level version of the compendium.
Note that the number of samples in this version exceeds
that of the gene version by two.  There are two
unintended columns in the underlying HDF Cloud
array, with names 'X0' and 'X0.1', that should
be ignored.

```{r dotx}
txlev = loadHtxcomp(genesOnly=FALSE)
txlev
```
