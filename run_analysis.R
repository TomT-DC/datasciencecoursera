## run_analysis.R

# most of the data manipulation will be done with the dplyr package
library(dplyr)

# get the data
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "projdata.zip")
#unzip("projdata.zip")

# Set the input directory as the subdirectory in the user working directory
# where the Samsung data file file was unzipped
InputDirectory<- ".\\uci har dataset"
#file.exists(InputDirectory)

## Two subdirectories 'test' and 'train' contain data sets to be combined
# A 2-pass loop is used to create dataframes to be merged

for(i in 1:2){
if(i==2)TestOrTrain<- "train" else TestOrTrain<- "test"
InputSubDirectory<- paste(as.character(InputDirectory),"\\",TestOrTrain, sep ="")
InputXFile<- paste(as.character(InputSubDirectory),"\\X_",TestOrTrain,".txt", sep="")
Xdf1<- read.table(InputXFile)

# The y-test(train).txt lists the numbers corresponding to the
# activities (walking, walking upstairs,sitting, etc)
# which correspond row-by-row with the x_test values
InputYFile<- paste(as.character(InputSubDirectory),"\\y_", TestOrTrain,".txt", sep="")

###file.exists(InputYFile)
Ydf1<- read.table(InputYFile)
####dim(Ydf1)

## The subject file identifies line-by-line by number the person
# that each row of measurement corresponds with
InputSubjectFile<-  paste(as.character(InputSubDirectory),"\\subject_", TestOrTrain, ".txt", sep="")
Subjdf1<- read.table(InputSubjectFile)

# Features.txt specifies by number and descriptive words
# the variables measured (column names) that go
# with each of the 561 columns of the x_test data
# The variables are then reduced to just those containing
# '-mean' or '-std' 
# 

FeaturesColumnFileName<- paste(as.character(InputDirectory),"\\features.txt", sep="")
                               
FeaturesColumnNames<- read.table(FeaturesColumnFileName, sep="", colClasses = c("numeric", "character"))
SearchStrings<- "-mean|-std"
ShorterColumnNames<- FeaturesColumnNames[(grepl(SearchStrings,FeaturesColumnNames[,2])),]


## Measured data gets reduced to just columns with '-mean' or '-std' 
ColumnNumbersToPull<- ShorterColumnNames[,1]
Xdf_small<- Xdf1[,ColumnNumbersToPull]

# A column containing the descriptive activity numbers
# and a column containing subject numbers
# are merged with the measured data
if(i==1){
Xdf_small_plus_activity_test<- cbind(Ydf1, Subjdf1, Xdf_small)
} else {
  Xdf_small_plus_activity_train<- cbind(Ydf1, Subjdf1, Xdf_small)
}
}
## end of loop

## The two dataframes get merged
Merged_df<- rbind(Xdf_small_plus_activity_test, Xdf_small_plus_activity_train )


## Columns of the merged dataframe get names

ColNames1<- ShorterColumnNames[,2]
ColNames2<- c("activity", "subject", ColNames1)
# Clean up variable names for later processing
ColNamesNew <- gsub("-", "_", ColNames2)
ColNamesNew2 <-   gsub("[(, )]","", ColNamesNew, perl = TRUE)
colnames(Merged_df)<- ColNamesNew2

## Activity Labels in character form come from the file activity_labels.txt

ActivityLabels<- read.table(paste(as.character(InputDirectory),"\\activity_labels.txt", sep=""))

# ActivityLabels in character form are substituted for the numbers in the original data tables
for(i in 1:nrow(Merged_df)){
as.character(ActivityLabels[as.numeric(Merged_df$activity[i]),2])
Merged_df$activity[i]<- as.character(ActivityLabels[as.numeric(Merged_df$activity[i]),2])
}

# A summary dataframe is created by taking the mean of each variable by activity and by subject
Summary_df<- Merged_df %>%
               arrange(activity, subject) %>%
               group_by(activity, subject)  %>%
               summarise_each( funs(mean))
# View(Summary_df)

# write the summary dataframe to a text file
write.table(Summary_df, "project_summary_results.txt", row.names = FALSE)

