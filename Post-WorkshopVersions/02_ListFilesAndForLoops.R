#Data processing 3: A more in-depth example
#Nichola Burton
#10/4/19

#clear the workspace
rm(list = ls())

#set the working directory to the location of this script
dir.name <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(dir.name)
getwd()

#if we want to run through all of our data files, we need to list them:
fileNames<- list.files("Data/")

#we can now call each file name from the list:

fileNames[1]


#now we want to open one of these data files. Remember that before we opened the file like this:

#data <- read.csv("Data/578104_undefined_20180414_210607.csv", header = F, stringsAsFactors = F)

#we have our file names, but we need to be able to stick that "Data/" part onto the front...

paste0("Data/", fileNames[1])

#how would you use the line above to open a datafile?
data <- read.csv(paste0("Data/", fileNames[1]), header = F, stringsAsFactors = F)

#like before, subset out the data you want
dataOut <- data[2, 1:6]

#Doing this for each file in turn: the for-loop

for(i in 1:5){
  print(i)
}

#How do we use this loop to run through our data files?

for(fileNum in 1:length(fileNames)){
  #open a datafile
  data <- read.csv(paste0("Data/", fileNames[fileNum]), header = F, stringsAsFactors = F)
  #subset out the data you want
  dataOut <- data[2, 1:6]
}

#We want to store the output from each round of the loop...
#Make a place to store the data:
compiledDataOut <- as.data.frame(matrix(0, nrow = length(fileNames), ncol = 7))

#now run the loop again, but this time copy dataOut to a new row of our storage dataframe:
for(fileNum in 1:length(fileNames)){
  #open a datafile
  data <- read.csv(paste0("Data/", fileNames[fileNum]), header = F, stringsAsFactors = F)
  #subset out the data you want
  dataOut <- data[2, 1:6]
  
  compiledDataOut[fileNum,] <- c(fileNames[fileNum], dataOut)
}

#add in the column names:
names(compiledDataOut) <- c("file", "browser", "version", "screenWidth", "screenHeight", "OS", "OSLang")

#and save out the compiled data
write.csv(compiledDataOut, "02_CompiledData.csv", row.names = F)
