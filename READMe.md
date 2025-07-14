# Project Layout

<pre>
project-root/
├── raw_data/              # untracked originals (.gitignore’d)
│   └── /   #              # unzip here but don't include extra nesting (UCI HAR ...)
├── scripts/               # R scripts in execution order
│   ├── run_analysis.R
├── final_data/
├── ├── tidy+dataset.R     # outputs: tidy_dataset.csv, etc.                
├── README.md
├── codebook/          # knits to codebook.html / .pdf
├── ├── CODEBOOK.Rmd
├── .Rhistory
├── .gitignore
├── LICENSE
├── dependencies.txt
└── cleaning_and_getting_data_project.Rproj      # RStudio project file
</pre>

# Steps to run project
## 1
clone repo using git
## 2
Click on the .Rproj file 
## 3
If necessary install following packages
pkgs <- c("data.table", "dplyr", "rstudioapi")
install.packages(setdiff(pkgs, installed.packages()[, "Package"]))
## 4 
Download raw dataset - note this was ignored in gitignore so as to not reupload the original data set
## 5
Go into scripts then run_analysis.R and then source. This should run the script and create the folder final_data and write the tidy dataset
as a csv file if that file does not exist.
