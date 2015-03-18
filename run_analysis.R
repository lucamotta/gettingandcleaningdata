library(data.table)
library(dplyr)

training <- read.table("train/X_train.txt")
test <- read.table("test/X_test.txt")

# 1. Merges the training and the test sets to create one data set
all.data <- rbind(training, test)

labels <- read.csv("features.txt", sep=" ", header=F)
names(labels) <- c("index", "label")

# 4. Appropriately labels the data set with descriptive variable names.
names(all.data) <- labels$label

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

indexes.mean <- labels[grep("mean()", colnames(all.data), fixed=T), "index"]
indexes.std <- labels[grep("std()", colnames(all.data), fixed=T), "index"]
indexes <- c(indexes.mean, indexes.std)

means.and.std <- all.data[indexes]

# 3. Uses descriptive activity names to name the activities in the data set
activity.labels <- read.table("activity_labels.txt")
names(activity.labels) <- c("index", "label")

training.index.labels <- read.table("train/y_train.txt")
test.index.labels <- read.table("test/y_test.txt")
all.labels <- rbind(training.index.labels, test.index.labels)
names(all.labels) <- c("index")

labels.map <- merge(all.labels, activity.labels)

all.data <- cbind(all.data, activity=labels.map$label)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
training.subjects <- read.table("train/subject_train.txt")
test.subjects <- read.table("test/subject_test.txt")
all.subjects <- rbind(training.subjects, test.subjects)
names(all.subjects) <- c("subject")

all.data <- cbind(all.data, subject=all.subjects)

summary <- data.table(all.data)
summary <- group_by(summary, activity, subject)
summary <- summarise_each(summary, funs(mean))
