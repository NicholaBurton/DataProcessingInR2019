#Data processing 3: A more in-depth example
#Nichola Burton
#10/4/19

#clear the workspace
rm(list = ls())

#set the working directory to the location of this script
dir.name <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(dir.name)
getwd()

#List our files:
fileNames<- list.files("Data/")

#here we run through processing on just the first file - we'll loop through the files later

#open file
data <- read.csv(paste0("Data/", fileNames[1]), header = F, stringsAsFactors = F)

#we start with the browser etc. info we collected before:
dataOut <- data[2, 1:6]

#rather than naming that by hand, we can take the names from row 1 (since they're there!)
names(dataOut) <- data[1, 1:6]

#add the filename (we can name the column at the same time using this format)
dataOut$filename <- fileNames[1]

#now we want to work with the rest of our data. 
#The first thing that would be useful would be to get rid of the first two rows (we're done with those)
#and turn the third row into a header, then drop that row too

#to make the header, we just do this:
names(data) <- data[3,]

#and we drop rows using this (slightly odd) notation:

data <- data[-1:-3,]

#the next thing I want to do with this data is collect the demographic responses
#we find those here:
data[data$blockLabel == "demographics", "response"]

#so we grab those:
dataOut[,8:13] <- data[data$blockLabel == "demographics", "response"]

#let's take the column names from the question text, found in the column "head"
names(dataOut)[8:13] <- data[data$blockLabel == "demographics", "head"]

#next, we want to collect the responses in the trust rating trials
#to make things easier, let's subset those trials into a new dataframe:
ratingData <- data[data$blockLabel == "rate_trust",]

#there were two practice trials, which we should drop. There are a few ways of doing this, this is just one:
ratingData <- ratingData[(ratingData$target != "practice1") & (ratingData$target != "practice2"),]

#each participant made these ratings in a different order. before we pull out the rating information, we should
#sort by trial number to put them back into the same order for all participants

#we do this using the "order" function

#order() produces a vector of numbers that you can use to sort the input, from smallest to largest or alphabetically.
#this is easier to understand with a demo:

x <- c("B", "C", "A", "D")
x
order(x)

y <- x[order(x)]
y

#let's try sorting the rating trials using this method

ratingData <- ratingData[order(ratingData$trialNo),]

#this didn't work the way we expected - what might have gone wrong?

ratingData$trialNo <- as.numeric(ratingData$trialNo)
ratingData <- ratingData[order(ratingData$trialNo),]

#now we can extract the rating responses:
dataOut[,14:33] <- ratingData$response

#and name them with the names of the target stimuli:
names(dataOut)[14:33] <- ratingData$target

#finally, let's find the mean reaction time for these rating trials:
#note that we're being a bit more efficient here by incorporating the "as.numeric" function into the same line
dataOut$RT <- mean(as.numeric(ratingData$RT))


#Now let's put all of that inside the loop!

#make our storage dataframe:
compiledDataOut <- as.data.frame(matrix(0, nrow = length(fileNames), ncol = 34))

#now run the loop again, but this time copy dataOut to a new row of our storage dataframe:
for(fileNum in 1:length(fileNames)){
  #open a datafile
  data <- read.csv(paste0("Data/", fileNames[fileNum]), header = F, stringsAsFactors = F)
  
  #we start with the browser etc. info we collected before:
  dataOut <- data[2, 1:6]
  names(dataOut) <- data[1, 1:6]
  
  #add the filename 
  dataOut$filename <- fileNames[fileNum]
  
  #turn row three into a header and drop those first three rows
  names(data) <- data[3,]
  data <- data[-1:-3,]
  
  #collect the demographic responses
  dataOut[,8:13] <- data[data$blockLabel == "demographics", "response"]
  names(dataOut)[8:13] <- data[data$blockLabel == "demographics", "head"]
  
  #subset out the rating trials and drop the practice trials
  ratingData <- data[data$blockLabel == "rate_trust",]
  ratingData <- ratingData[(ratingData$target != "practice1") & (ratingData$target != "practice2"),]
  
  #sort the rating trials by trial number 
  ratingData <- ratingData[order(as.numeric(ratingData$trialNo)),]
  
  #extract the rating responses and name them with the names of the target stimuli:
  dataOut[,14:33] <- ratingData$response
  names(dataOut)[14:33] <- ratingData$target
  
  #find the mean reaction time for these rating trials:
  dataOut$RT <- mean(as.numeric(ratingData$RT))
  
  compiledDataOut[fileNum,] <- dataOut
}

#the compiled dataframe doesn't have column names, but we can take them from the last participant's 
#dataOut dataframe:

names(compiledDataOut) <- names(dataOut)

#and save out the compiled data
write.csv(compiledDataOut, "03_MoreCompiledData.csv", row.names = F)
