install.packages("tidyverse")

library(tidyverse)

# Set working directory to the folder with all the zip files for each year
setwd("/Users/aranansari/EDGAR_Data_RegCF")

#Unzip all folders

Folders <- list.files(path=getwd())

for (i in seq(length(Folders))) {
  unzip(Folders[i])
}

#REMOVE ZIP FOLDERS
do.call(file.remove, list(list.files(getwd(), pattern = ".zip",full.names = TRUE)))

#Re-initiate the folders class
Folders <- list.files(path=getwd(),full.names=TRUE)


Files <- as.data.frame(list.files(path=Folders[1:length(Folders)],full.names = TRUE))

#create lists of files of certain types (offering, issuers, etc)
SUBMISSION <-list.files(path=Folders[1-length(Folders)],full.names = TRUE,pattern="FORM_C_SUBMISSION.tsv")
INFORMATION <- list.files(path=Folders[1-length(Folders)],full.names = TRUE,pattern="FORM_C_ISSUER_INFORMATION.tsv")
JURISDICTIONS <- list.files(path=Folders[1-length(Folders)],full.names = TRUE,pattern="FORM_C_ISSUER_JURISDICTIONS.tsv")
DISCLOSURE <- list.files(path=Folders[1-length(Folders)],full.names = TRUE,pattern="FORM_C_DISCLOSURE.tsv")
SIGNATURE <- list.files(path=Folders[1-length(Folders)],full.names = TRUE,pattern="FORM_C_SIGNATURE.tsv")
ISSUER_SIGNATURE <- list.files(path=Folders[1-length(Folders)],full.names = TRUE,pattern="FORM_C_ISSUER_SIGNATURE.tsv")


#import the data from each of these files, placing them in a large list of data frames
SUBMISSION.DATA <- lapply(SUBMISSION,read.csv,sep = '\t')
INFORMATION.DATA <- lapply(INFORMATION,read.csv,sep = '\t')
JURISDICTIONS.DATA <- lapply(JURISDICTIONS,read.csv,sep = '\t')
DISCLOSURE.DATA <- lapply(DISCLOSURE,read.csv,sep = '\t')
SIGNATURE.DATA <- lapply(SIGNATURE,read.csv,sep = '\t')
ISSUER_SIGNATURE.DATA <- lapply(ISSUER_SIGNATURE,read.csv,sep = '\t')

#for each type of file, combine the files into larger ones, eventually having only 6 very long dataframes
SUBMISSION.MASTER<-do.call("rbind",SUBMISSION.DATA)
INFORMATION.MASTER<-do.call("rbind",INFORMATION.DATA)
JURISDICTIONS.MASTER<-do.call("rbind",JURISDICTIONS.DATA)
DISCLOSURE.MASTER<-do.call("rbind",DISCLOSURE.DATA)
SIGNATURE.MASTER<-do.call("rbind",SIGNATURE.DATA)
ISSUER_SIGNATURE.MASTER<-do.call("rbind",ISSUER_SIGNATURE.DATA)

#create csv files of the combined data frames
write.csv(SUBMISSION.MASTER,"SUBMISSION.MASTER.csv",row.names=FALSE)
write.csv(INFORMATION.MASTER,"ISSUERS.MASTER.csv",row.names=FALSE)
write.csv(JURISDICTIONS.MASTER,"OFFERING.MASTER.csv",row.names=FALSE)
write.csv(DISCLOSURE.MASTER,"RECIPIENTS.MASTER.csv",row.names=FALSE)
write.csv(SIGNATURE.MASTER,"RELATEDPERSONS.MASTER.csv",row.names=FALSE)
write.csv(ISSUER_SIGNATURE.MASTER,"SIGNATURES.MASTER.csv",row.names=FALSE)


summary(SUBMISSION.MASTER)


#focus on Honeycomb, 