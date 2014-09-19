#Summary#
This repository contains the run_analysis.R script that tidies up data collected from the accelerometers from the Samsung Galaxy S smartphone.
Full description of the input data can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Reference:
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

#Setup and assumptions#
Before runing the script please make sure that "getdata-projectfiles-UCI HAR Dataset.zip" containing the input data is located in your working directory.
The script will only work with this exact zip file which is originally located on the http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones site.
It is assumed that order of rows in every file in the dataset is the same, and thus it is possible to correlate for example activity and measurement from different files.

#Steps#
The run_analysis.R script goes through the following steps to tidy up the input data:

1. The zip file with input data is unarchived.
2. Test and Training datasets are merged into one dataset, with Training set at the top and Test set at the bottom. This is applied to both X, Y and subject files, which contain measurements, activity and subject information appropriately.
3. As required by the assignment, only the columns that contain std or mean measurements are taken. The columns are selected that have either std() or mean() in their name. A filter is hardcoded, because the input dataset is not expected to change, and hardcoding column indexes is faster on the execution time than calculating which columns to take each time a new.
4. Labels for columns are taken from the features.txt file, and added to the dataset.
5. Subject information is added to the main dataset as a new column.
6. Activity information is added to the main dataset as a new column.
7. As required by the assignment, average is calculated for each Subject for each activity. Given 6 activity types and 30 subjects, this gives 160 rows in the resulting dataset.
8. Variables/Column names in the resulting dataset are changed for easier processing: brackets are removed, and everything is converted to lower case. Dashes are not removed, because such a removal would've made it hard to read for humans.
9. Resulting dataset is saved in the initial working directory as "resulting-set.txt".

Further details are documented in the script itself.
