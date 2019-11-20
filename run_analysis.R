library(reshape2)


## This R file provides functions for reading datasets containing measurements obtained by phones
## regarding movement and motion, along with associated feature and activity labels and subject identifiers.

## After creating data structures to store all of those measurements and labels, it writes an output file containing
## the mean of each measurement variable for each subject and activity combination (this mean is calculated over a series
## of measurements taken for the same variable).

## Extensive documentation for this file is available in the README.md and codebook.md that are available in this Git
## repository.

## Example of running:
## source('run_analysis.R')

## Note doing this source() command will run the full script start to finish; it expects all input files to be present
## in their default directory structure (which is identical to the directory downloaded from the course website). Comment
## out the last line to prevent the script from running upon the source() call. You can also run execute() from within
## RStudio, and this will return the resulting data frame for viewing and further manipulation (uncomment the line at the end
## of the execute() function where indicated to do this).

## The expected input files and directory structure are listed in the accompanying README.md file.


## This function reads in the feature name file ('features.txt') and extracts the feature names only.
## Return: A vector with the feature names in the order listed in the file.
process_features <- function(featureNameFile){
  featureNamesRaw <- readLines(featureNameFile)
  nameCols <- strsplit(featureNamesRaw, split = ' ')
  colLabels <- sapply(nameCols, function(nl){nl[2]})
  colLabels
}


## This function reads in the three main files in a dataset (i.e. the measurement file, the
## subject id file, and the activity file) and constructs a data frame for further processing.
## A dataset can either be the 'training' or 'test' sets.
## Return: a DataFrame in wide format.
read_dataset <- function(dataFile, subjectFile, activityFile, varNames, activityNames, label){
  print(paste("Reading dataset ", label))
  dataDf <- read.table(dataFile)

  checkNaList = names(table(colSums(is.na(dataDf))))
  if(length(checkNaList) != 1 | checkNaList[1] != "0"){
    print(paste("WARNING: There are NA values in input data file ", dataFile))
  }
  colnames(dataDf) <- varNames
  targetCols <- grep('mean\\(\\)|std\\(\\)', colnames(dataDf))
  dataDf <- dataDf[, targetCols]
  activityList <- readLines(activityFile)
  subjectList <- readLines(subjectFile)
  dataDf[['activityid']] <- activityList
  dataDf[['subjectid']] <- subjectList
  dataDf[['activitynames']] <- sapply(dataDf[['activityid']], function(x){activityNames[x]})
  dataDf[['dataset']] <- label
  dataDf
}

## This function transforms a feature name to conform to a specification. See the codebook.md
## file for details regarding this transformation.
## Return: the output variable name
clean_var <- function(inputVar){
  if(inputVar %in%  c('activityid', 'subjectid', 'activitynames', 'dataset')){
    o <- inputVar
  }
  else{

    inputVar <- gsub("BodyBody", "Body", inputVar)

    inputVar <- gsub("([a-z])([A-Z])", "\\1_\\2", inputVar)
    inputVar <- gsub("-", "_", inputVar)
    inputVar <- tolower(inputVar)
    cols <- strsplit(inputVar, '_')[[1]]
    m <- ifelse(cols[[1]] == 't', "time", "freq")
    t <- ifelse("jerk" %in% cols, "jerk", "raw")
    d <- ifelse("mag" %in% cols, "mag", cols[[length(cols)]])
    s <- ifelse("mean()" %in% cols, "mean", "stddev")
    o <- paste(c(m, cols[2:3], t, d, s), collapse='_')
  }
  o
}

## This function reads the mapping file of activity labels to activity names that
## can be used to give descriptive variable names to integer labels.
## Return: a vector where the names are the integers and the values are the descriptive string names.
read_activity_names <- function(activityNameFile){

  al <- readLines('activity_labels.txt')
  alCols <- strsplit(al, split = ' ')
  alLabels <- sapply(alCols, function(x){x[2]})
  alIndex <- sapply(alCols, function(x){x[1]})
  names(alLabels) <- alIndex
  alLabels

}

## This function checks that the input file exists on the file system (throwing an error if not)
## Return: the same input file name.
check_file <- function(fileName){
  if(file.exists(fileName) == FALSE){
    stop(paste("ERROR: Did not find expected file ", fileName))

  }
  fileName

}

## This function is the primary function that drives this analysis. It can be called from RStudio directly.
## It is also called by default when this script is source.

## See the README.md file for a full description of the script workflow.

## Return: The tidy dataset containing the summary of the measurements taken for each subject and activity,
## as specified in the course assignment requirements.
execute <- function(dirName=NULL) {
  if (is.null(dirName) == F){
    setwd(dirName)
  }
  trainDataFile <- check_file(file.path('train', 'X_train.txt'))
  trainActivityFile <- check_file(file.path('train', 'y_train.txt'))
  trainSubjectFile <- check_file(file.path('train', 'subject_train.txt'))

  testDataFile <- check_file(file.path('test', 'X_test.txt'))
  testActivityFile <- check_file(file.path('test', 'y_test.txt'))
  testSubjectFile <- check_file(file.path('test', 'subject_test.txt'))

  activityLabelFile <- check_file('activity_labels.txt')
  featureNameFile <- check_file('features.txt')

  varNames <- process_features(featureNameFile)
  activityNames <- read_activity_names(activityNameFile)


  trainingDataDf <- read_dataset(trainDataFile, trainSubjectFile, trainActivityFile, varNames, activityNames, 'train')
  testDataDf <- read_dataset(testDataFile, testSubjectFile, testActivityFile, varNames, activityNames, 'test')


  print("Merging datasets")
  fullDataDf <- rbind(trainingDataDf, testDataDf)
  print("Renaming variables")
  names(fullDataDf) <- sapply(names(fullDataDf), clean_var)
  print("Reshaping data to tall format")
  meltedFullDf <- melt(fullDataDf, id=c('dataset', 'activityid', 'subjectid', 'activitynames'))
  print("Generating tidy summarized dataset")
  aggDf <- aggregate(meltedFullDf[['value']], by=list(meltedFullDf[['subjectid']], meltedFullDf[['activitynames']], meltedFullDf[['dataset']], meltedFullDf[['variable']]), mean)
  names(aggDf) <- c("subject_id", "activity_names", "dataset", "variable", "average_value")
  outputFile = file.path(getwd(), 'wearable_summary.txt')
  print(paste("Writing output to ", outputFile))
  write.table(aggDf,  file=outputFile, row.names=F, quote=F)
  #aggDf # uncomment this line to return the summary DataFrame if you wish to view or manipulate it in RStudio

}
#if running from the command line, and this script is not in the data directory as described in README.md,
#then edit the line below to pass the data directory as a string parameter to execute()
execute()
