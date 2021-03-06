#' unDuplicated Function
#'
#' Main data cleaning function for PI datasets.
#'
#' This is one of the main function of GMDPP package. It will take the sorted
#' data object and automatically detect the duplicated cases.
#' You can choose to automatically
#' clean out all the cases with duplicated data(suggested when the percetage of duplication
#' is low and you get enough data for your analysis), or stop the auto cleaning
#' and start cleaning duplicated data with the information returned(semi-cleaned data object and
#' the duplicatedNum and duplicatedID variables)
#' @param sortedPack A PI object, included subfields like Explicit, Sessions, Tasks, IAT and Demo which representing the original five datasets(required to process) and further addon variables like participatedID, participatedNum etc(optional).
#' @keywords Data cleaning
#' @export
#' @examples
#'  \dontrun{
#'			rawData <- takeFive('~/explicit.txt','~/iat.txt','~/sessions.txt','~/sessionTasks.txt','~/demographics.txt','mTurk')
#'      sortedData <- prepare(rawData)
#'      workingData <- unDu(sortedData)
#'    }
#' @seealso  \code{\link{~/Requirements}} For files naming consistency and dataset cleaning requirements.
#' @return If it works correctly, there will be an objects return as original datasets and extra elements for reference. They are: $Explicit, $IAT, $Sessions, $Tasks and $Demo for actual datasets, and $participant_id $participatedNum $completedID $completedNum etc.

unDu <- function(sortedPack) {
  cleanedPack <- list()
  class(cleanedPack) <- "PI"

  testData <- sortedPack$Tasks[c("task_number","participant_id")]
  uniqueID <- sortedPack$participatedID

  # check function: check duplication
  checkDu <- function(x) {
    testDose <- testData[which(testData$participant_id == x),]
    flag <- sum(duplicated(testDose))
    if (flag > 0) {
      return (TRUE)
      } else {
        return (FALSE)
      }
  }


  Dupli <- sapply(uniqueID, checkDu)

  if (sum(Dupli) > 0) {
    duplicatedID <- uniqueID[Dupli]
    duplicatedNum <- length(duplicatedID)
    } else {
      duplicatedID <- NA
      duplicatedNum <- 0
    }

  duplicatedRatio <- duplicatedNum / sortedPack$participatedNum
  unDuplicatedID <- uniqueID[-which(Dupli)]
  unDuplicatedNum <- length(unDuplicatedID)

  # Subsetting all the datasets with only cleaned participants' data
  cleanedExplicit <- sortedPack$Explicit[sortedPack$Explicit$participant_id %in% unDuplicatedID,]
  cleanedSessions <- sortedPack$Sessions[sortedPack$Sessions$participant_id %in% unDuplicatedID,]
  cleanedTasks <- sortedPack$Tasks[sortedPack$Tasks$participant_id %in% unDuplicatedID,]
  cleanedDemo <- sortedPack$Demo # Need to be fixed
  cleanedIAT <- sortedPack$IAT[sortedPack$IAT$participant_id %in% unDuplicatedID,]


  #Output: Added these variables:
  cleanedPack$Explicit <- cleanedExplicit
  cleanedPack$Sessions <- cleanedSessions
  cleanedPack$Tasks <- cleanedTasks
  cleanedPack$Demo <- cleanedDemo
  cleanedPack$IAT <- cleanedIAT

  # Added new reference variables for simple cleaned Objects
  cleanedPack$participatedID <- sortedPack$participatedID
  cleanedPack$participatedNum <- sortedPack$participatedNum
  cleanedPack$unDuplicatedID<- unDuplicatedID
  cleanedPack$unDuplicatedNum <- unDuplicatedNum
  cleanedPack$duplicatedID <- duplicatedID
  cleanedPack$duplicatedNum <- duplicatedNum
  cleanedPack$Source <- sortedPack$Source
  cleanedPack$Type <- "non_duplicated_only_data"
  cleanedPack$Last_time <- Sys.time()
  if (exists('completedID',where=sortedPack)) cleanedPack$completedID <- sortedPack$completedID
  if (exists('completedNum',where=sortedPack)) cleanedPack$completedNum <- sortedPack$completedNum
  if (exists('unfinishedID',where=sortedPack)) cleanedPack$unfinishedID <- sortedPack$unfinishedID
  if (exists('unfinishedNum',where=sortedPack)) cleanedPack$unfinishedNum <- sortedPack$unfinishedNum


  # Added new reference variables for non-cleaned Objects
  sortedPack$unDuplicatedID<- unDuplicatedID
  sortedPack$unDuplicatedNum <- unDuplicatedNum
  sortedPack$duplicatedID <- duplicatedID
  sortedPack$duplicatedNum <- duplicatedNum
  sortedPack$Last_time <- Sys.time()


  output <- function(duplicatedRatio,duplicatedNum,participatedNum){

    #Ask for user input
    info <- cat("The percentage of duplication is: ", duplicatedRatio*100,"%, ", duplicatedNum," out of ",participatedNum," attent participants. Would you like to cleanout duplication automatically?[Y/N]")
    x <- readline(prompt = info)
    while (!((x == "Y")|(x=="N"))) {x <- readline(prompt = "I don't get it. Would you like to cleanout duplication automatically?[Y/N]")}
    #Return
    return(x)
  }
  flag <- output(duplicatedRatio, duplicatedNum, sortedPack$participatedNum)
  if (flag == "Y") return(cleanedPack) else return (sortedPack)
}
