#' export Function
#'
#' Export dataset with readme file.
#'
#' This is the final step of data cleaning. It will take the raw data object
#' you get from the takeFive, transform them into formats that required
#' by PI reseseach team(Insert link here). It will also return necessary variables
#' that include information that you will find handy in later data cleaning.
#' @param readyPack A PI object, included elements like Explicit, Sessions, Tasks, IAT and Demo which representing the original five datasets(required to process) and further addon variables(optional).
#' @keywords Data pre-analysis
#' @export
#' @examples
#'  \dontrun{
#'			rawData <- takeFive('~/explicit.txt','~/iat.txt','~/sessions.txt','~/sessionTasks.txt','~/demographics.txt','mTurk')
#'      prepare(rawData)
#'    }
#' @seealso  \code{\link{~/Requirements}} For files naming consistency and dataset cleaning requirements.
#' @return If it works correctly, there will be an objects return as original datasets and extra elements for reference. They are: $Explicit, $IAT, $Sessions, $Tasks and $Demo for actual datasets, and $participant_id $participatedNum $completedID $completedNum etc.

export <- function(readyPack) {
    
}