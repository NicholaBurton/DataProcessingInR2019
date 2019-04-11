#Data processing 1: Set the working directory and open files
#Nichola Burton
#10/4/19

#what is the current working directory?
getwd()

#set the working directory (note the quotation marks - this is a string!)
setwd("/Users/nicholaburton/Dropbox/Postdoc/resources/R/2019_AdvancedDataProcessing")

#set the working directory to the location of this script(helpful code snippet provided by Julian Basanovic)
dir.name <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(dir.name)
getwd()

#open a datafile
data <- read.csv("Data/578104_undefined_20180414_210607.csv", header = F, stringsAsFactors = F)

#subset out the data you want
dataOut <- data[2, 1:6]

#done!
