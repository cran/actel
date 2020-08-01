## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- echo=FALSE, results='asis'----------------------------------------------
load("badmovements.Rdata")
knitr::kable(badmovements[20:25,1:7])

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name = c("A", "B", "C", "D", "E"),
    Array = c("A", "B", "C", "D", "E"),
    Section = c("Up", "Up", "Down", "Down", "Down"),
    Type = c("Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name = "RS1",
    Array = "A",
    Section = "",
    Type = "Release"
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name = "RS2",
    Array = "D",
    Section = "",
    Type = "Release"
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name = "RS2",
    Array = "C|D",
    Section = "",
    Type = "Release"
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name = c("A", "B", "C", "D", "E", "RS1", "RS2"),
    Array = c("A", "B", "C", "D", "E", "A", "C|D"),
    Section = c("Up", "Up", "Up", "Down", "Down", "", ""),
    Type = c("Hydrophone", "Hydrophone", "Hydrophone", "Hydrophone", "Hydrophone", "Release", "Release")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name = c("A", "B", "C", "D", "E", "F", "G"),
    Array = c("North", "West", "East1", "East2","R1", "R2", "R2"),
    Section = c("Lake", "Lake", "Lake", "Lake", "River", "River", "River"),
    Type = c("Hydrophone", "Hydrophone", "Hydrophone", "Hydrophone", "Hydrophone", "Hydrophone", "Hydrophone")
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name = "RS1",
    Array = "East1|East2",
    Section = "",
    Type = "Release"
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name= "RS1",
    Array = "North|West|East1|East2",
    Section = "",
    Type = "Release"
    )
knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
  spatial <- data.frame(Station.name = c("A", "B", "C", "D", "E", "F", "G", "RS1"),
    Array = c("North", "West", "East1", "East2","R1", "R2", "R2", "Lake1|Lake2|Lake3|Lake4"),
    Section = c("Lake", "Lake", "Lake", "Lake", "River", "River", "River", ""),
    Type = c("Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone","Hydrophone","Release")
    )
knitr::kable(spatial)

