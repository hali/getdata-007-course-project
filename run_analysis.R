install.packages("data.table")
install.packages("microbenchmark")
library(data.table)
library(microbenchmark)

unzip("getdata-projectfiles-UCI HAR Dataset.zip")
setwd("UCI HAR Dataset")

# I wish I could use fread() from data.table here, but the leading spaces in first column
# break this function. This bug is fixed according to stackoverflow, but
# bugfix isn't in production yet.
X_test <- read.table("test/X_test.txt")
X_train <- read.table("train/X_train.txt")
#rbind() appends rows from X_test to the end of X_train
X <- rbind(X_train, X_test)
X <- data.table(X)
#remove() clears the environment to make script better for computers low on RAM
remove(X_test)
remove(X_train)

Y_test <- fread("test/y_test.txt")
Y_train <- fread("train/y_train.txt")
Y <- rbind(Y_train, Y_test)
remove(Y_test)
remove(Y_train)

subject_test <- fread("test/subject_test.txt")
subject_train <- fread("train/subject_train.txt")
subject <- rbind(subject_train, subject_test)
remove(subject_test)
remove(subject_train)

#Subsetting only the columns containing mean or std
X_new <- data.table(X$V1, X$V2, X$V3, X$V4, X$V5, X$V6, X$V41, X$V42, X$V43, X$V44, X$V45, X$V46,
                                         X$V81, X$V82, X$V83, X$V84, X$V85, X$V86, X$V121, X$V122, X$V123, X$V124,
                                         X$V125, X$V126, X$V161, X$V162, X$V163, X$V164, X$V165, X$V166, X$V201,
                                         X$V202, X$V214, X$V215, X$V227, X$V228, X$V240, X$V241, X$V253, X$V254,
                                         X$V266, X$V267, X$V268, X$V269, X$V270, X$V271, X$V345, X$V346, X$V347,
                                         X$V348, X$V349, X$V350, X$V424, X$V425, X$V426, X$V427, X$V428, X$V429,
                                         X$V503, X$V504, X$V529, X$V530, X$V542, X$V543)

#reading the list of column names. X is reused here so that the previous
#huge subsetting command could be reused as well
X <- fread("features.txt")
#transpose rows into columns
X <- t(X$V2)
X <- data.table(X)
#Subsetting only the columns containing labels for mean and std
X_labels <- data.table(X$V1, X$V2, X$V3, X$V4, X$V5, X$V6, X$V41, X$V42, X$V43, X$V44, X$V45, X$V46,
                    X$V81, X$V82, X$V83, X$V84, X$V85, X$V86, X$V121, X$V122, X$V123, X$V124,
                    X$V125, X$V126, X$V161, X$V162, X$V163, X$V164, X$V165, X$V166, X$V201,
                    X$V202, X$V214, X$V215, X$V227, X$V228, X$V240, X$V241, X$V253, X$V254,
                    X$V266, X$V267, X$V268, X$V269, X$V270, X$V271, X$V345, X$V346, X$V347,
                    X$V348, X$V349, X$V350, X$V424, X$V425, X$V426, X$V427, X$V428, X$V429,
                    X$V503, X$V504, X$V529, X$V530, X$V542, X$V543)
#By default data.table turns strings to factors, disabling it didn't work for me,
#so I explicitely turn factor to strings here
X_labels <- data.frame(lapply(X_labels, as.character), stringsAsFactors=FALSE)
#Change column names for the dataset to descriptive names from the features.txt
colnames(X_new) <- unlist(X_labels)
remove(X)
remove(X_labels)
#Add subject info to the dataset
X_new[, Subject:=subject$V1]
remove(subject)

#read activity labels from a file and replace activity numbers with activity labels
activity_labels <- fread("activity_labels.txt")
Y.V1 <- factor(Y$V1)
levels(Y$V1) <- activity_labels$V2
#Add activity info to the dataset
X_new[, Activity:=Y$V1]
remove(Y)
remove(activity_labels)

#Creating new tidy dataset that creates averages for each variable by subject and activity
results <- X_new[,lapply(.SD, mean), by=list(Subject,Activity)]
results <- results[order(Subject,Activity)]

#Making Variables names nicer to read: getting read of special characters and upper case
names(results) <- sub("\\(\\)", "", names(results),)
names(results) <- tolower(names(results))

#Saving a resulting dataset into the file
setwd("../")
write.table(results, row.names=FALSE, file="./resulting-set.txt")