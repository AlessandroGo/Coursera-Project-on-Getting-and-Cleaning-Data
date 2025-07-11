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
features_clean <- tolower(feature_names)
# Remove parenthesis in names
features_clean <- gsub("[()]",  "",  features_clean) # gsub replaces all instances not just first
features_clean <- gsub("-",     "_",  features_clean) # We have been using _ and that's pretty standard in programming not '-'
features_clean <- gsub(",",     "",   features_clean)
