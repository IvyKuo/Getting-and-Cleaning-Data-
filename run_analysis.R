### step 1 : Merges the training and the test sets to create one data set.
# import trainning datasets 
X_train <- read.table("~/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("~/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset/train/Y_train.txt")
S_train <- read.table("~/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset/train/subject_train.txt")

# check number of rows in the trainning datasets
# nrow(X_train) ---7352
# nrow(Y_train) ---7352
# nrow(S_train) ---7352

# import test datasets 
X_test <- read.table("~/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("~/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset/test/Y_test.txt")
S_test <- read.table("~/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset/test/subject_test.txt")

# check number of rows in the test datasets
# nrow(X_test) ---2947
# nrow(Y_test) ---2947
# nrow(S_test) ---2947

# import features and activity labels information
features <- read.table("~/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset/features.txt")
act_label <- read.table("~/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset/activity_labels.txt")

# merge trainning and test datasets into one big dataset
# rename the column as activity label column in Y tables
colnames(Y_test)[1] <- "act_label"
colnames(Y_train)[1] <- "act_label"

# rename the column as activity label column in Y tables
colnames(S_test)[1] <- "subject"
colnames(S_train)[1] <- "subject"

# combine the XY tables in each dataset 
XY_test <- cbind(X_test,Y_test,S_test)
# check no. of rows=2947, no. of columns=563
XY_train <- cbind(X_train,Y_train,S_train)
# check no. of rows=7352, no. of columns=563

# merge two XY dataset into one big dataset
XY_TT <- rbind(XY_train,XY_test)
# check no. of rows=10299, no. of columns=563

### step 2 : Extracts only the measurements on the mean and standard deviation for each measurement. 

# find the column names matched with mean and std
stringmatch <- c("mean","std")
col_index <- features[grep(paste(stringmatch, collapse='|'),features$V2, ignore.case=TRUE),]
# nrow(col_index) --- 86 columns

# subset dataset with the matching column index
XY_TT_a <- subset(XY_TT, select = col_index$V1)

### step 3: Uses descriptive activity names to name the activities in the data set

# give the corresponding column names
colnames(XY_TT_a) <- col_index$V2

### step 4 : Appropriately labels the data set with descriptive variable names. 

# add the activity label 
XY_TT_b <- cbind(XY_TT$subject,XY_TT$act_label,XY_TT_a)
# nrow(XY_TT_b)=10299, ncol=(XY_TT_b)=88

XY_TT_b[[2]] <- factor(XY_TT_b[[2]], levels = c(1,2,3,4,5,6), 
                       labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))

colnames(XY_TT_b)[1] <- "subject"
colnames(XY_TT_b)[2] <- "act_label"

### step 5 : Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# create final dataset 
XY_TT_final <- aggregate(XY_TT_b[3:88], by = list (XY_TT_b$subject, XY_TT_b$act_label), FUN = "mean")
write.table(XY_TT_final, "~/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset/final_dataset.txt", sep="\t")



