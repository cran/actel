#' Group movements
#'
#' Crawls trough the detections of each fish and groups them based on ALS arrays and time requirements.
#' 
#' @param detections.list A list of the detections split by each target tag, created by splitDetections.
#' @param dist.mat A matrix of the distances between the deployed ALS.
#' @param invalid.dist Whether or not the distance matrix supplied is valid for the study area.
#' @inheritParams explore
#' @inheritParams splitDetections
#' @inheritParams loadDetections
#' 
#' @return A list containing the movement events for each fish.
#' 
#' @keywords internal
#' 
groupMovements <- function(detections.list, bio, spatial, speed.method, max.interval, 
  tz, dist.mat, invalid.dist) {
  appendTo("debug", "Running groupMovements.")
  trigger.unknown <- FALSE
  round.points <- roundDown(seq(from = length(detections.list)/10, to = length(detections.list), length.out = 10), to = 1)
  counter <- 1
  {
    if (interactive())
      pb <- txtProgressBar(min = 0, max = sum(unlist(lapply(detections.list, nrow))), style = 3, width = 60)
    movements <- lapply(names(detections.list), function(i) {
      appendTo("debug", paste0("Debug: (Movements) Analysing fish ", i, "."))
      if (invalid.dist) {
        recipient <- data.frame(
          Array = NA_character_, 
          Detections = NA_integer_, 
          First.station = NA_character_, 
          Last.station = NA_character_, 
          First.time = as.POSIXct(NA_character_, tz = tz, format = "%y-%m-%d %H:%M:%S"), 
          Last.time = as.POSIXct(NA_character_, tz = tz, format = "%y-%m-%d %H:%M:%S"), 
          Time.travelling = NA_character_, 
          Time.in.array = NA_character_, 
          Valid = NA,
          stringsAsFactors = FALSE
          )
      } else {
        recipient <- data.frame(
          Array = NA_character_, 
          Detections = NA_integer_, 
          First.station = NA_character_, 
          Last.station = NA_character_, 
          First.time = as.POSIXct(NA_character_, tz = tz, format = "%y-%m-%d %H:%M:%S"), 
          Last.time = as.POSIXct(NA_character_, tz = tz, format = "%y-%m-%d %H:%M:%S"), 
          Time.travelling = NA_character_, 
          Time.in.array = NA_character_, 
          Average.speed.m.s = NA_real_,
          Valid = NA,
          stringsAsFactors = FALSE
          )
      }
      z <- 1
      array.shifts <- c(which(detections.list[[i]]$Array[-1] != detections.list[[i]]$Array[-length(detections.list[[i]]$Array)]), nrow(detections.list[[i]]))
      time.shifts <- which(difftime(detections.list[[i]]$Timestamp[-1], detections.list[[i]]$Timestamp[-length(detections.list[[i]]$Timestamp)], units = "mins") > max.interval)
      all.shifts <- sort(unique(c(array.shifts, time.shifts)))
      capture <- lapply(seq_len(length(all.shifts)), function(j) {
        if (j == 1)
          start <- 1
        else
          start <- all.shifts[j - 1] + 1
        stop <- all.shifts[j]
        recipient[z, "Array"] <<- paste(detections.list[[i]]$Array[start])
        recipient[z, "Detections"] <<- stop - start + 1
        recipient[z, "First.station"] <<- paste(detections.list[[i]]$Standard.name[start])
        recipient[z, "First.time"] <<- detections.list[[i]]$Timestamp[start]
        recipient[z, "Last.station"] <<- paste(detections.list[[i]]$Standard.name[stop])
        recipient[z, "Last.time"] <<- detections.list[[i]]$Timestamp[stop]
        z <<- z + 1
        counter <<- counter + stop - start + 1
        if (i == tail(names(detections.list), 1)) 
          counter <<- sum(unlist(lapply(detections.list, nrow)))
        if (interactive())
          setTxtProgressBar(pb, counter)
        flush.console()
      })
      counter <<- counter

      recipient$Valid <- TRUE
      if (any(link <- recipient$Array == "Unknown")) {
        recipient$Valid[recipient$Array == "Unknown"] <- FALSE
        trigger.unknown <<- TRUE
      }
      
      recipient <- data.table::as.data.table(recipient)
      recipient <- movementTimes(movements = recipient, type = "array")
      if (!invalid.dist)
        recipient <- movementSpeeds(movements = recipient, 
          speed.method = speed.method, dist.mat = dist.mat)
      
      attributes(recipient)$p.type <- "Auto"
      return(recipient)
    })
    names(movements) <- names(detections.list)
    if (interactive())
      close(pb)
  }

  if (trigger.unknown)
    warning("Movement events at 'Unknown' locations have been rendered invalid.", immediate. = TRUE, call. = FALSE)

  appendTo("debug", "Done.")
  return(movements)
}

#' Removes invalid events
#' 
#' Remove invalid movement events and recalculate times/speeds.
#'
#' @inheritParams explore
#' @inheritParams groupMovements
#' @param movements A list of movements for each target tag, created by groupMovements.
#' 
#' @return The movement data frame containing only valid events for the target fish.
#' 
#' @keywords internal
#' 
simplifyMovements <- function(movements, fish, bio, speed.method, dist.mat, invalid.dist) {
  # NOTE: The NULL variables below are actually column names used by data.table.
  # This definition is just to prevent the package check from issuing a note due unknown variables.
  Valid <- NULL

  if (any(movements$Valid)) {
    simple.movements <- movements[(Valid), ]
    aux <- movementTimes(movements = simple.movements, type = "array")
    if (!invalid.dist)
        aux <- movementSpeeds(movements = aux, speed.method = speed.method, dist.mat = dist.mat)
    output <- speedReleaseToFirst(fish = fish, bio = bio, movements = aux,
     dist.mat = dist.mat, invalid.dist = invalid.dist, speed.method = speed.method)
    return(output)
  } else {
    return(NULL)
  }
}


#' Calculate time and speed
#' 
#' Triggers movementTimes and also calculates the speed between events.
#'
#' @inheritParams explore
#' @inheritParams simplifyMovements
#' @inheritParams groupMovements
#' 
#' @return The movement data frame with speed calculations for the target fish.
#' 
#' @keywords internal
#' 
movementSpeeds <- function(movements, speed.method, dist.mat) {
  appendTo("debug", "Running movementSpeeds.")
  movements$Average.speed.m.s[1] <- NA
  if (nrow(movements) > 1) {
    capture <- lapply(2:nrow(movements), function(i) {
      if (movements$Array[i] != movements$Array[i - 1] & all(!grep("^Unknown$", movements$Array[(i - 1):i]))) {
        if (speed.method == "last to first"){
          a.sec <- as.vector(difftime(movements$First.time[i], movements$Last.time[i - 1], units = "secs"))
          my.dist <- dist.mat[movements$First.station[i], gsub(" ", ".", movements$Last.station[i - 1])]
        }
        if (speed.method == "last to last"){
          a.sec <- as.vector(difftime(movements$Last.time[i], movements$Last.time[i - 1], units = "secs"))
          my.dist <- dist.mat[movements$First.station[i], gsub(" ", ".", movements$First.station[i - 1])]
        }
        movements$Average.speed.m.s[i] <<- round(my.dist/a.sec, 6)
        rm(a.sec, my.dist)
      }
    })
  }
  return(movements)
}

#' Calculate movement times
#' 
#' Determines the duration of an event and the time from an event to the next. 
#'
#' @inheritParams simplifyMovements
#' @inheritParams movementSpeeds
#' @param type The type of movements being analysed. One of "array" or "section".
#' 
#' @return The movement data frame with time calculations for the target fish.
#' 
#' @keywords internal
#' 
movementTimes <- function(movements, type = c("array", "section")){
  type = match.arg(type)
  time.in <- paste0("Time.in.", type)
  appendTo("debug", "Running movementTimes.")
  # Time travelling
  if (nrow(movements) > 1) {
    aux <- data.frame(
      First.time = movements$First.time[-1],
      Last.time = movements$Last.time[-nrow(movements)]
      )
    recipient <- apply(aux, 1, function(x) {
      a <- as.vector(difftime(x[1], x[2], units = "hours"))
      h <- a %/% 1
      m <- ((a %% 1) * 60) %/% 1
      if (m < 10) 
        m <- paste0("0", m)
      return(paste(h, m, sep = ":"))
    })
    movements$Time.travelling[2:nrow(movements)] <- recipient
  }
  # Time on array
  movements[, time.in] <- apply(movements, 1, function(x) {
    if (x["Detections"] == 1)
      return("0:00")
    else
      a <- as.vector(difftime(x["Last.time"], x["First.time"], units = "hours"))
      h <- a %/% 1
      m <- ((a %% 1) * 60) %/% 1
      if (m < 10) 
        m <- paste0("0", m)
      return(paste(h, m, sep = ":"))
  })
  return(movements)
}

#' Calculate time and speed since release.
#' 
#' @inheritParams simplifyMovements
#' @inheritParams explore
#' @inheritParams groupMovements
#' @inheritParams movementSpeeds
#' @param fish The tag ID of the fish currently being analysed
#' 
#' @return The movement data frame containing time and speed from release to first event.
#' 
#' @keywords internal
#' 
speedReleaseToFirst <- function(fish, bio, movements, dist.mat, speed.method, invalid.dist = FALSE){
  appendTo("debug", "Running speedReleaseToFirst.")
  the.row <- match(fish, bio$Transmitter)
  origin.time <- bio[the.row, "Release.date"]
  origin.place <- as.character(bio[the.row, "Release.site"])
  if (origin.time <= movements$First.time[1]) {
    a <- as.vector(difftime(movements$First.time[1], origin.time, units = "hours"))
    h <- a%/%1
    m <- ((a%%1) * 60)%/%1
    if (m < 10) 
      m <- paste0("0", m)
    movements$Time.travelling[1] <- paste(h, m, sep = ":")
    if (!invalid.dist & movements$Array[1] != "Unknown") {
      if (speed.method == "last to first") {
        a.sec <- as.vector(difftime(movements$First.time[1], origin.time, units = "secs"))
        my.dist <- dist.mat[movements$First.station[1], origin.place]
        movements$Average.speed.m.s[1] <- round(my.dist/a.sec, 6)
      }
      if (speed.method == "last to last") {
        a.sec <- as.vector(difftime(movements$Last.time[1], origin.time, units = "secs"))
        my.dist <- dist.mat[movements$Last.station[1], origin.place]
        movements$Average.speed.m.s[1] <- round(my.dist/a.sec, 6)
      }
    }
  } else {
    movements$Time.travelling[1] <- NA
    movements$Average.speed.m.s[1] <- NA
  }
  return(movements)
} 

#' Compress array-movements into section-movements
#' 
#' @inheritParams simplifyMovements
#' @inheritParams migration
#' 
#' @return A data frame containing the section movements for the target fish.
#' 
#' @keywords internal
#' 
sectionMovements <- function(movements, sections, invalid.dist) {
  Valid <- NULL
  
  if (any(movements$Valid))
    vm <- movements[(Valid)]
  else
    return(NULL)

  aux <- lapply(seq_along(sections), function(i) {
    x <- rep(NA_character_, nrow(vm))
    x[grepl(sections[i], vm$Array)] <- sections[i]
    return(x)
  })

  event.index <- combine(aux)
  aux <- rle(event.index)
  last.events <- cumsum(aux$lengths)
  first.events <- c(1, last.events[-length(last.events)] + 1)
  
  if (invalid.dist) {
    recipient <- data.frame(
      Section = aux$values,
      Events = aux$lengths,
      Detections = unlist(lapply(seq_along(aux$values), function(i) sum(vm$Detections[first.events[i]:last.events[i]]))),
      First.array = vm$Array[first.events],
      First.station = vm$First.station[first.events],
      Last.array = vm$Array[last.events],
      Last.station = vm$Last.station[last.events],
      First.time = vm$First.time[first.events],
      Last.time = vm$Last.time[last.events],
      Time.travelling = c(vm$Time.travelling[1], rep(NA_character_, length(aux$values) - 1)),
      Time.in.section = rep(NA_character_, length(aux$values)),
      Valid = rep(TRUE, length(aux$values)),
      stringsAsFactors = FALSE
      )
  } else {
    recipient <- data.frame(
      Section = aux$values,
      Events = aux$lengths,
      Detections = unlist(lapply(seq_along(aux$values), function(i) sum(vm$Detections[first.events[i]:last.events[i]]))),
      First.array = vm$Array[first.events],
      First.station = vm$First.station[first.events],
      Last.array = vm$Array[last.events],
      Last.station = vm$Last.station[last.events],
      First.time = vm$First.time[first.events],
      Last.time = vm$Last.time[last.events],
      Time.travelling = c(vm$Time.travelling[1], rep(NA_character_, length(aux$values) - 1)),
      Time.in.section = rep(NA_character_, length(aux$values)),
      Speed.in.section.m.s = unlist(lapply(seq_along(aux$values), function(i) mean(vm$Average.speed.m.s[first.events[i]:last.events[i]], na.rm = TRUE))),
      Valid = rep(TRUE, length(aux$values)),
      stringsAsFactors = FALSE
      )
  }
  output <- as.data.table(movementTimes(movements = recipient, type = "section"))
  attributes(output)$p.type <- attributes(movements)$p.type
  return(output)
}

#' update array-movement validity based on the section-movements
#' 
#' @param arrmoves the array movements
#' @param secmoves the section movements
#' 
#' @return A data frame with the array movements for the target fish, with an updated 'Valid' column.
#' 
#' @keywords internal
#' 
updateValidity <- function(arrmoves, secmoves) {
  Valid <- NULL
  output <- lapply(names(arrmoves), 
    function(i) {
      if (!is.null(secmoves[[i]]) && any(!secmoves[[i]]$Valid)) {
        aux <- secmoves[[i]][(!Valid)]
        to.change <- unlist(lapply(1:nrow(aux),
          function(j) {
            A <- which(arrmoves[[i]]$First.time == aux$First.time[j])
            B <- A + (aux$Events[j] - 1)
            return(A:B)
          }))
        appendTo(c("Screen", "Report"), paste0("M: Rendering ", length(to.change), " array movement(s) invalid for fish ", i ," as the respective section movements were discarded by the user."))
        arrmoves[[i]]$Valid[to.change] <- FALSE
        if (attributes(arrmoves[[i]])$p.type == "Auto")
          attributes(arrmoves[[i]])$p.type <- "Manual"
      }
      return(arrmoves[[i]])
    })
  names(output) <- names(arrmoves)
  return(output)
}
