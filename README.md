---
title: "README.md"
author: "Tom Tiedeman"
date: "Sunday, July 26, 2015"
output: html_document
---
run_anaylsis.R
Input data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The script assumes that the source data has been unzipped and resides in the current working directory.

Using the 'dplyr' package for a number of tasks, the script loads the test and train data.

The y-test(train).txt lists the numbers corresponding to the
activities (walking, walking upstairs,sitting, etc)
which correspond row-by-row with the x_test values.

The  Inputsubject file identifies line-by-line by number the person that each row of measurement corresponds with.

Features.txt specifies by number and descriptive words
the variables measured (column names) that go
with each of the 561 columns of the x_test data
The variables are then reduced to just those containing
'-mean' or '-std' 

A column containing the descriptive activity numbers
and a column containing subject numbers
are merged with the measured data.

The two dataframes get merged.

A summary dataframe is created by taking the mean of each variable by activity and by subject.

The summary dataframe to a text file 'project_summary_results.txt.
