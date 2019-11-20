# Introduction
Below is a description of my submission for the Coursera **Getting and Cleaning Data** Week 4 course
project. 

In addition to this `README.md` file, the files `codebook.md`, `run_assignment.R`, and
`sample_wearable_summary_output.txt` should be available in this GitHub repository as part of the assignment
(`sample_wearable_summary_output.txt` is the file that's output by the script, but is also provided for
reference). Please see those files for details that supplement the description in this `README.md` file.

The files `ORIGINAL_README.txt` and `features_info.txt` are also in this GitHub repository for
reference; they were part of the original assignment dataset. 

# Running the Script
## Expected Directory Structure
This script expects the directory structure to be identical to what is downloaded from the course
website (and unzipped), available here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Specifically, the top level directory (which by default is named `UCI HAR Dataset`) should include the following files:

* `activity_labels.txt`
* `features.txt`
* `train`
* `test`

`train` and `test` are themselves directories and should contain the following files:
* `train` directory:
  * `X_train.txt`
  * `y_train.txt`
  * `subject_train.txt`

* `test` directory:
  * `X_test.txt`
  * `y_test.txt`
  * `subject_test.txt`

The R script I wrote (`run_analysis.R`) should also be placed in the top level directory for best
performance (see below)

Note that these input files can be renamed but they are hardcoded in my script so should be updated
where indicated there to reflect any changes (if this were more than a course assignment then they
should be parameterized to reflect best practices).

It is OK to have other files in these directories; they will be ignored.

## Running from the Command Line
To run the script from the command line, save the R script in the top level directory as noted
above and run 

`Rscript run_analysis.R`

If necessary, you can run the script from somewhere else on your file system, and specify the input
directory by adding it to the call to `execute()` at the very bottom of the script where indicated. If
this were more than a course assignment, the directory could be passed on the command line as an argument.

## Running from RStudio
The script can also be sourced from R Studio by typing `source('run_analysis.R`). The script either
needs to be in your current working directory, or alternatively the full path to it should be
specified. 

When the script is sourced, it automatically calls the `execute()` function which runs the full
script start to finish and expects all input files in their appropriate locations as described
above. Alternatively, you can call `execute()` yourself from  within RStudio and pass the full path
to the input directory (here, passing nothing will default to the current working directory).

When you do this, an added nice effect is that you can return the tidy dataset that is constructed
in the script, and either view or manipulate it from within RStudio. To do this, uncomment the last
line in the `execute()` function that specifies the return value.

## Script Workflow
Following is the general workflow of the script:

1. Read the three training set files (full dataset, subject identifiers, activity identifiers)
2. Read the three test set files (full dataset, subject identifiers, activity identifiers)
3. Read the feature and activity label files
4. Perform some basic user input validation (files exist and no NAs are present)
5. Add the activity and feature labels to these datasets through various indexing strategies
6. Identify target variables of interest as specified in the assignment criteria (searching features
   for mean() and std(); see justification below)
7. Concatenate the training and test sets
8. Rename the feature variables to be more readable and follow a regular pattern
9. Reshape the data from wide-form to long-form
10. Aggregate the data by taking the average for each variable for each activity and subject
11. Write the data frame to a file

These steps are a high level overview and omit some details, and aren't necessarily run exactly in
this sequence.

## Script Output File
The script writes outpt to the current working directory. The output file is called `wearable_summary.txt`. 

To read the file back in, run the following command from RStudio (or an R Console or script):

`resultDf <- read.table("wearable_summary.txt", quote = "", header=T)`

If the file is not in your current directory, specify its full path as the first argument to `read.table`.

# Notes on the "Tidy Dataset"
This assignment is somewhat open to interpretation as to what the form the final output should take,
provided that it's in 'tidy' format. I believe the output file that my script generates takes this
form for the following reasons:

1. There is one column per variable. Here, the columns are mostly ID variables (`subject id`, `activity
   name`, `dataset`). The `dataset` variable isn't necessarily required but I thought it would be
   useful to have for each observation whether it's from the training set or test set (note that
   strictly speaking, this could be its own table to reduce redunancy). Columns are all labeled with
   meaningful names.
   
2. There is one row per observation. Since the output is in 'long' form, there is are two columns
   specifying variable name and values. This ensures that each row is a single measurement which is
   a canonical aspect of tidy data and allows for easy filtering and modeling. Alternatively, each
   measurement variable could be specified as its own column (wide form) which would significantly
   reduce the number of rows, but I went with long form.
   
3. There is one table per type of observation. Certainly we could break this up as noted above (have
   a separate table specifying training and test set) or the time and frequency variables could be
   assigned different tables, but that seems overkill for a course assignment.
   
4. There are no duplicate columns -- this should be self-evident

5. Variable names are readable: I'm hoping this is the case. I made the decision to include '_' in
   the column names to separate words since I think it's more readable. The course videos said to
   avoid this convention but I think it's fine in this case (both in the column names as well as in
   the `varaiable` column. The other file `codebook.md` explains further the convention I chose to
   represent the entries in the `variable` column -- refer to that for more details. Note that some
   variables in the `features.txt` file had "BodyBody" in them which I took to be a typo, so I
   deleted one occurrence of "Body." I also only included variables with the text `mean()` and
   `std()` in the original values, ignoring some variables that had `mean` (without `()`) because
   they seemed less relevant according to the spirit of the assignment.
   
# Miscellaneous
I would like to thank the reviewers (if you made it this far) for your time and hope that I've been
able to justify some of the decisions I've made, especially given the fact that this assignment is
open to interpretation and the exact evaluation criteria aren't made available ahead of time (I
actually find this a little vague and think the course design could be changed to be more
specific). 

Also, this post was excellent:

https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/

And I'd like to thank the author for the helpful advice.


