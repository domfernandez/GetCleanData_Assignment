#
# Setting [download.file.automatically] to TRUE will download [Dataset.zip]
# - automatically
# May not work on all platforms!

# download.file.automatically <- FALSE
# data.file <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
#  if (! file.exists(local.data.file)) {
#    if (download.file.automatically) {
#     download.file(data.file,
#                  destfile = local.data.file, method = 'curl')
#    }
# }

# Crash if file is not present
# if (! file.exists(local.data.file)) {
#    stop(paste(local.data.file, 'must be present in working directory.'))
# }
# Uncompress the original data file
# if (! file.exists(local.data.dir)) {
#    unzip(local.data.file)
#  }

# Fail if unzip failed
#  if (! file.exists(local.data.dir)) {
#    stop(paste('Unable to unpack the compressed data.'))
#  }
#
# For this Assignment data-file has been downloaded AND unZipped
# local.data.file <- './original-dataset.zip'
# ... AND, lies in the [local.data.dir] ... that is: './UCI HAR Dataset'

# workingDir <- setwd("C:/Users/Dominic/GetCleanData_Project")
workingDir <- getwd()
local.data.dir <- paste(workingDir,'UCI HAR Dataset',sep='/')

tidy.data.file <- './tidy-UCI-HAR-dataset.csv'
tidy.avgs.data.file <- './tidy-UCI-HAR-avgs-dataset.csv'

# Read activity labels
activities <- read.table(paste(local.data.dir, 'activity_labels.txt', sep = "/"),
                   header = FALSE)
names(activities) <- c('id', 'name')
# Read feature labels
features <- read.table(paste(local.data.dir, 'features.txt', sep = '/'),
                    header = FALSE)
names(features) <- c('id', 'name')

# Read the plain data files, assigning sensible column names
train.X <- read.table(paste(local.data.dir, 'train', 'X_train.txt', sep = '/'),
                      header = FALSE)
names(train.X) <- features$name

train.y <- read.table(paste(local.data.dir, 'train', 'y_train.txt', sep = '/'),
                      header = FALSE)
names(train.y) <- c('activity')
train.subject <- read.table(paste(local.data.dir, 'train', 'subject_train.txt',
                                  sep = '/'),
                            header = FALSE)
names(train.subject) <- c('subject')
test.X <- read.table(paste(local.data.dir, 'test', 'X_test.txt', sep = '/'),
                     header = FALSE)
names(test.X) <- features$name
test.y <- read.table(paste(local.data.dir, 'test', 'y_test.txt', sep = '/'),
                     header = FALSE)
names(test.y) <- c('activity')
test.subject <- read.table(paste(local.data.dir, 'test', 'subject_test.txt',
                                 sep = '/'), header = FALSE)
names(test.subject) <- c('subject')

# Merge the training and test sets
X <- rbind(train.X, test.X)
y <- rbind(train.y, test.y)
subject <- rbind(train.subject, test.subject)

# Extract just the mean and SD features
# Note that this includes meanFreq()s - it's not clear whether we need those,
# but they're easy to exlude if not needed.
X <- X[, grep('mean|std', features$name)]

# Convert activity labels to meaningful names
y$activity <- activities[y$activity,]$name
# Merge partial data sets together
tidy.data.set <- cbind(subject, y, X)

# Dump the data set
write.csv(tidy.data.set, tidy.data.file)
# Compute the averages grouped by subject and activity
tidy.avgs.data.set <- aggregate(tidy.data.set[, 3:dim(tidy.data.set)[2]],
                                list(tidy.data.set$subject,
                                     tidy.data.set$activity),
                                mean)
names(tidy.avgs.data.set)[1:2] <- c('subject', 'activity')
# Dump the second data set
write.csv(tidy.avgs.data.set, tidy.avgs.data.file)
