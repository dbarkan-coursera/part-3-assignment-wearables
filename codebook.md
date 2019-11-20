# Introduction
This file describes the tidy dataset output by the `run_analysis.R` script that represents my
submission for the Coursera **Getting and Cleaning Data** Week 4 course project.

This file specifically describes the columns in the output dataset saved in the file
`wearable_summary.txt`. More information regarding the script including usage and expected input is
available in the accompanying `README.md` file. There is only a single output file and the data are
represented in in 'long form'.

More information regarding this raw data is available in the `features_info.txt` and `ORIGINAL_README.txt`
files which were part of the course assignment input dataset (note that `ORIGINAL_README.txt` was
downloaded from the course website and is not the `README.md` file that I generated).


# Column descriptions
- **subject_id:** Anonymized subject identifier (i.e. number representing the person performing the
  motions that are being read by the instrument). IDs range from 1 to 30. Subjects are divided into
  training and test sets. IDs do not repeat across these two sets. These are taken directly from the
  `subject_train.txt` and `subject_test.txt` files. 

- **activity_names:**: Label for the motion that the subject is undertaking. These are represented
  as strings. These values are calculated using the mapping defined in the `activity_labels.txt`
  file which assigns a name to each activity index (which themselves are found in the `y_train.txt`
  and `y_test.txt` files. There are six values, as follow:
  
```  
  - WALKING
  - WALKING_UPSTAIRS
  - WALKING_DOWNSTAIRS
  - SITTING
  - STANDING
  - LAYING
```
- **dataset:**: The dataset to which the subject was assigned. These are calculated according to
  which subdirectory the data were read from. There are two values, as follow:
  
```
  - train
  - test
```  

- **variable:**: The name of the measurement variable that was either recorded by the instrument as raw data
  or calculated from the raw data. These are represented by strings following a specification. See
  the section below, `variable column details` for this specification. There are 66 possible values,
  as follow:
  
```
  - freq_body_acc_jerk_mag_mean
  - freq_body_acc_jerk_mag_stddev
  - freq_body_acc_jerk_x_mean
  - freq_body_acc_jerk_x_stddev
  - freq_body_acc_jerk_y_mean
  - freq_body_acc_jerk_y_stddev
  - freq_body_acc_jerk_z_mean
  - freq_body_acc_jerk_z_stddev
  - freq_body_acc_raw_mag_mean
  - freq_body_acc_raw_mag_stddev
  - freq_body_acc_raw_x_mean
  - freq_body_acc_raw_x_stddev
  - freq_body_acc_raw_y_mean
  - freq_body_acc_raw_y_stddev
  - freq_body_acc_raw_z_mean
  - freq_body_acc_raw_z_stddev
  - freq_body_gyro_jerk_mag_mean
  - freq_body_gyro_jerk_mag_stddev
  - freq_body_gyro_raw_mag_mean
  - freq_body_gyro_raw_mag_stddev
  - freq_body_gyro_raw_x_mean
  - freq_body_gyro_raw_x_stddev
  - freq_body_gyro_raw_y_mean
  - freq_body_gyro_raw_y_stddev
  - freq_body_gyro_raw_z_mean
  - freq_body_gyro_raw_z_stddev
  - time_body_acc_jerk_mag_mean
  - time_body_acc_jerk_mag_stddev
  - time_body_acc_jerk_x_mean
  - time_body_acc_jerk_x_stddev
  - time_body_acc_jerk_y_mean
  - time_body_acc_jerk_y_stddev
  - time_body_acc_jerk_z_mean
  - time_body_acc_jerk_z_stddev
  - time_body_acc_raw_mag_mean
  - time_body_acc_raw_mag_stddev
  - time_body_acc_raw_x_mean
  - time_body_acc_raw_x_stddev
  - time_body_acc_raw_y_mean
  - time_body_acc_raw_y_stddev
  - time_body_acc_raw_z_mean
  - time_body_acc_raw_z_stddev
  - time_body_gyro_jerk_mag_mean
  - time_body_gyro_jerk_mag_stddev
  - time_body_gyro_jerk_x_mean
  - time_body_gyro_jerk_x_stddev
  - time_body_gyro_jerk_y_mean
  - time_body_gyro_jerk_y_stddev
  - time_body_gyro_jerk_z_mean
  - time_body_gyro_jerk_z_stddev
  - time_body_gyro_raw_mag_mean
  - time_body_gyro_raw_mag_stddev
  - time_body_gyro_raw_x_mean
  - time_body_gyro_raw_x_stddev
  - time_body_gyro_raw_y_mean
  - time_body_gyro_raw_y_stddev
  - time_body_gyro_raw_z_mean
  - time_body_gyro_raw_z_stddev
  - time_gravity_acc_raw_mag_mean
  - time_gravity_acc_raw_mag_stddev
  - time_gravity_acc_raw_x_mean
  - time_gravity_acc_raw_x_stddev
  - time_gravity_acc_raw_y_mean
  - time_gravity_acc_raw_y_stddev
  - time_gravity_acc_raw_z_mean
  - time_gravity_acc_raw_z_stddev
```
- **average_value:**: Average value of the measurement type indicated in the `variable` column,
  calculated over all observations for the subject indicated in the `subject_id` column performing
  the action indicated in the `activity_names` column. To be specific, a transformation was applied
  to group the subjects, activities, and variables (resulting in 11810 groups, i.e. 30 subjects * 6
  activities * 66 variables) where each group had a set of observations for that variable. The mean
  of these observations was saved as the value in this column.
  
  Note that the measurements are themselves means and standard deviations of the raw data, so here I
  am taking the mean of those means and the mean of the standard deviations.
  
  A note about units in this column: Normally a codebook should describe the units of each
  variable and I would do so here. However, the measurements have undergone several transformations
  from the extreme raw data (3rd order low pass Butterworth filter, Fast Fourier Transform,
  etc.). I am not familiar with this type of data and in my opinion, identifying the units in this
  case is beyond the scope of the assignment. There is some information in the accompanying
  `features_info.txt` and `ORIGINAL_README.txt` (which is the readme file that accompanied the dataset; note
  this is different from `README.md` that I generated as part of the assignment). They indicate that
  the raw data is in standard gravity units of 'g' as well as radians / second, but I'm not sure
  what these units become following the filtering and FFTs.


# Variable column description
- The values in the `variable` column were transformed from the original variable names specified in
  `features_info.txt` as follows:
  - Six fields were generated, each containing a value from a controlled vocabulary
  - Field 1 is either 'time' or 'freq' depending on whether the orignal variable name began with 't'
    or 'f' respectively. As indicated in the `features_info.txt` file, 'time' indicates that the
    measurement value is a time domain signal and 'freq' indicates that it was passed through a Fast
    Fourier Transform.
  - Field 2 is either 'body' or 'gravity', determined by which of these terms appears in the original
    variable name. As indicated in `features_info.txt`, the original acceleration signal was
    separated into these two categories.
  - Field 3 is either 'acc' or 'gyro', determined by which of these terms appears in the original
    variable name. As indicated in `features_info.txt`, these reflect whether the feature came from
    the accelerometer or the gyroscope.
  - Field 4 is either 'raw' or 'jerk'. If 'Jerk' appears in the original variable name, then this
    field gets set to 'jerk'; otherwise this field is set to 'raw'. As stated in
    `features_info.txt`, "The body linear acceleration and angular velocity were derived in time to
    obtain Jerk signals".
  - Field 5 is either 'x', 'y', 'z', or 'mag', determined by whether the original variable name
    indicates directionality (ending in one of X, Y, or Z) or whether "Mag" appears in the
    name. As stated in `features_info.txt`, the magnitude is calculated from the XYZ values using
    the Euclidean norm.
  - Field 6 is either 'mean' or 'stddev' depending on which of these summary statistics was present
    in the original feature name.

- Other notes on transforming variable names:
  - Some variables in the `features.txt` file had "BodyBody" in them which I took to be a typo, so I
    deleted one occurrence of "Body."
  - Many variables were ommitted from the original list specified in `features.txt`; this was
    according to the requirements of the course assignment which states "Extract only the
    measurements on the mean and standard deviation for each measurement." I interpreted this to say
    that only variables with the exact text `mean()` and `std()` were under consideration; other
    variables had the text `mean` in them but I ignored these since they didn't seem relevant
    (certainly they could easily have been included).







