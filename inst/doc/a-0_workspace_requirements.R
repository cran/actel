## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- echo=FALSE, results='asis'----------------------------------------------
biometrics <- data.frame(
  Release.date = c("2018-02-01 10:05:00", "2018-02-01 10:10:00", "2018-02-01 10:15:00"),
  Serial.nr = c("12340001", "A12-3456-1001", "19340301"),
  Signal = c(1, 1001, 301),
  Length.mm = c(150, 160, 170),
  Weight.g = c(40, 60, 50),
  Group = c("Wild", "Hatchery", "Wild"),
  Release.site = c("Site A", "Site A", "Site B"),
  ... = c("...", "...", "..."))

knitr::kable(biometrics)

## ---- echo=FALSE, results='asis'----------------------------------------------
biometrics <- data.frame(
  Release.date = c("2018-02-01 10:05:00", "2018-02-01 10:15:00", "2018-02-01 10:15:00"),
  Signal = c("501", "502|503", "504|505|506"),
  Sensor.unit = c("T", "T|D", "T|D|A"),
  Length.mm = c(150, 160, 170),
  Weight.g = c(40, 60, 50),
  Group = c("Wild", "Hatchery", "Wild"),
  Release.site = c("Site A", "Site A", "Site B"),
  ...=c("...", "...", "..."))

knitr::kable(biometrics)

## ---- echo=FALSE, results='asis'----------------------------------------------
spatial <- data.frame(
  Station.name = c("River East", "River West", "Estuary", "Site A", "Site B"),
  Latitude = c(8.411, 8.521, 8.402, 8.442, 8.442),
  Longitude = c(40.411, 40.521, 40.402, 40.442, 40.442),
  Section = c("River", "River", "River", "", ""),
  Array = c("A1", "A1", "A3", "A1", "A2"),
  Type = c("Hydrophone", "Hydrophone", "Hydrophone", "Release", "Release"))

knitr::kable(spatial)

## ---- echo=FALSE, results='asis'----------------------------------------------
deployments <- data.frame(
  Receiver = c(11111, 22222, 33333),
  Station.name = c("River East", "River West", "Estuary"),
  Start = c("2018-01-01 11:30:00", "2018-01-01 11:33:00", "2018-01-01 11:34:00"),
  Stop = c("2018-05-03 09:30:00", "2018-05-04 08:33:00", "2018-05-05 12:00:00"))

knitr::kable(deployments)

## ---- echo=FALSE, results='asis'----------------------------------------------
detections <- data.frame(
  Timestamp = c("2018-01-01 11:30:00", "2018-01-01 11:33:00", "2018-01-01 11:34:00"),
  Receiver = c(11111, 22222, 33333),
  CodeSpace = c("A12-3456", "A12-3456", "R64K"),
  Signal = c(1234, 1235, 203),
  Sensor.Value = c(10.0, 5.3, 13.6),
  Sensor.Unit = c("T", "D", "T"))

knitr::kable(detections)

