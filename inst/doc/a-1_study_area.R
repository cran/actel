## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- echo=FALSE, results='asis'----------------------------------------------
load("badmovements.Rdata")
knitr::kable(badmovements[20:25,1:7])

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name=c("A","B","C","D","E")
    ,Array=c("Up1","Up2","Up3","Down1","Down2")
    ,Type=c("Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name=c("RS1")
    ,Array=c("Up1")
    ,Type=c("Release")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name=c("RS2")
    ,Array=c("Down1")
    ,Type=c("Release")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name=c("RS2")
    ,Array=c("Up3|Down1")
    ,Type=c("Release")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name=c("A","B","C","D","E","RS1","RS2")
    ,Array=c("Up1","Up2","Up3","Down1","Down2","Up1","Up3|Down1")
    ,Type=c("Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone","Release","Release")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name=c("A","B","C","D","E","F","G")
    ,Array=c("Lake1","Lake2","Lake3","Lake4","River1","River2","River2")
    ,Type=c("Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name=c("RS1")
    ,Array=c("Lake3|Lake4")
    ,Type=c("Release")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name=c("RS1")
    ,Array=c("Lake1|Lake2|Lake3|Lake4")
    ,Type=c("Release")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name=c("A","B","C","D","E","F","G","RS1")
    ,Array=c("Lake1","Lake2","Lake3","Lake4","River1","River2","River2","Lake1|Lake2|Lake3|Lake4")
    ,Type=c("Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone","Release")
    )
knitr::kable(spatial)

