# The libraries used
library(data.table)
library(dplyr)
library(rstudioapi)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# First going to get the feature names before merging data set
# Only keeping feature name from file
feature_names <- fread("../raw_data/features.txt", col.names = c("idx", "feature"), stringsAsFactors = FALSE)$feature
# Now clean up names of features
# Lowercase variable names
features_clean <- gsub("([a-z])([A-Z])", "\\1_\\2", feature_names)
features_clean <- tolower(features_clean)
# Remove parenthesis in names
features_clean <- gsub("[()]",  "",  features_clean) # gsub replaces all instances not just first
features_clean <- gsub("-",     "_",  features_clean) # We have been using _ and that's pretty standard in programming not '-'
features_clean <- gsub(",",     "",   features_clean)
# input -> feature_names[[1]] tBodyAcc-mean()-X output -> tbodyacc_mean_x
# Give the column a name
features <- data.table(idx = 1:length(features_clean), name = features_clean)

# Get indices based on original feature names (from uncleaned feature_names)
mean_std_idx <- grep("mean\\(\\)|std\\(\\)", feature_names) # Looks complicated but just escaping '(' and ')' special character

# Keep only those rows
features_keep <- features[mean_std_idx]

# Now to read in training data
train_df <- data.table(
  subject = fread("../raw_data/train/subject_train.txt")[[1]],
  activity = fread("../raw_data/train/y_train.txt")[[1]],
  fread("../raw_data/train/X_train.txt", col.names = features_clean)
)
# See dimensions of train_df
print(dim(train_df))
# See unique values for some of the columns
print(unique(train_df$subject)) # There are 30 subjects 70% is training data
print(length(unique(train_df$subject))) # 21 which reconciles with 70% of 30 total being training
print(unique(train_df$activity)) # See from activity_labels.txt which labels match which activity i.e. 1 corresponds to walking

# Now to do the same thing for the test_df
# Now to read in training data
test_df <- data.table(
  subject = fread("../raw_data/test/subject_test.txt")[[1]],
  activity = fread("../raw_data/test/y_test.txt")[[1]],
  fread("../raw_data/test/X_test.txt", col.names = features_clean)
)
# See dims of test set
print(dim(test_df))
# See unique subjects
print(unique(test_df$subject)) 
print(length(unique(test_df$subject))) # 9 rest of subjects

# Now just stacking the test and train sets row wise
merged_df <- rbind(train_df, test_df)
dim(merged_df)

# Now to keep only mean and standard deviation of dataset
merged_mean_std <- merged_df %>%
  select(subject, activity, all_of(features_keep$name))
# Now going to give activity a meaningful label
merged_meaninful_df <- merged_mean_std %>%
                      mutate(activity = factor(activity,
                                       levels = 1:6,
                                       labels = c("walking", "walking_up", "walking_down", "sitting", "standing", "laying")
                                       )
                             )

# This yields the final tidy grouped data set by averaging the mean and std for each variable per group
# Note that the new data set now creates
# This essentially creates a composite primary key for averaged set
# Group_by is fairly simple, but syntax for summarise is important, notably see .groups = "drop" is important
averaged_dataset <- merged_meaninful_df %>%
                    group_by(subject, activity) %>%
                    summarise(across(everything(), mean), .groups = "drop")

# Note at the top I added a script to set working directory to this files location hence we go out of scripts '../'
if (!dir.exists("../final_data")) {
  dir.create("../final_data")
}

file_path <- "../final_data/tidy_dataset.csv"

if (!file.exists(file_path)) {
  # Need to use row.names = FALSE or there's an extra column of indices
  write.csv(averaged_dataset, file_path, row.names = FALSE)
} else {
  message("File already exists — skipping write.")
}

