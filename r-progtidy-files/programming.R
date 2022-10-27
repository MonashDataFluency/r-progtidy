

# Install the entire Tidyverse collection of packages with:
#
#   install.packages("tidyverse")
#
# or just install packages needed for this section with:
#
#   install.packages(c(
#       "readr",    # read tabular data
#       "dplyr"     # general data frame manipulation
#   ))


# _______________________
# ==== If-statements ====

# The general pattern of an if statement is:

if (LOGICAL_VALUE) {
    THING_TO_DO_IF_TRUE
} else {
    THING_TO_DO_IF_FALSE
}


# Here is an example:

num <- 37                   # 1
if (num > 100) {            #   2
  cat("greater\n")          #
} else {                    #
  cat("not greater\n")      #     3
}                           #
cat("done\n")               #       4
                            # --time-->


# If-statements don't have to include an `else`. If there isn't one, R
# simply does nothing if the test is FALSE:

num <- 53                            # 1
if (num > 100) {                     #   2
    cat("num is greater than 100\n") #
}                                    #
cat("done\n")                        #     3
                                     # --time-->


# We can also chain several tests together when there are more than two
# options. As an example, here is some code that works out the sign of a
# number:

if (num > 0) {         # line 1
    print(1)           # line 2
} else if (num == 0) { # line 3
    print(0)           # line 4
} else {
    print(-1)          # line 5
}

num <- -3
num <- 0
num <- 2/3


## _______________
## ----> Quiz ----
# Which lines above are executed, and in what order, for each value of
# `num`?
#
# ___________________
# ==== Functions ====

# The general pattern of a function is:

FUNCTION_NAME <- function(ARGUMENT_NAME1, ARGUMENT_NAME2, ...) {
    FUNCTION_BODY
}


# Here is an example:

fahr_to_kelvin <- function(temp) {
    (temp-32) * (5/9) + 273.15
}


# Let's try running our function. Calling our own function is no
# different from calling any other function:

# freezing point of water
fahr_to_kelvin(32)

# boiling point of water
fahr_to_kelvin(212)


## _____________________
## ----> Variations ----

fahr_to_kelvin <- function(temp) (temp-32) * (5/9) + 273.15


fahr_to_kelvin <- function(temp) {
    kelvin <- (temp-32) * (5/9) + 273.15
    kelvin
}


fahr_to_kelvin <- function(temp) {
    kelvin <- (temp-32) * (5/9) + 273.15
    return(kelvin)
    plot(1:10)
}


fahr_to_kelvin <- function(temp) {
    kelvin <-
        (temp-32) * (5/9) +
        273.15
    return(kelvin)
}


   fahr_to_kelvin<-
function(
                   temp){(temp
  -32  )*(    5
            /9 )+

273.15}


fahr_to_kelvin_broken <- function(temp) {
    (temp-32) * (5/9)
        + 273.15
}

fahr_to_kelvin_broken(212)


charmander <- function(bulbasaur) {
    mew <- (bulbasaur-32) * (5/9) + 273.15
    mew
}


## ______________________________
## ----> Composing Functions ----

kelvin_to_celsius <- function(temp) {
    temp - 273.15
}

#absolute zero in Celsius
kelvin_to_celsius(0)


fahr_to_celsius <- function(temp) {
    temp_k <- fahr_to_kelvin(temp)
    temp_c <- kelvin_to_celsius(temp_k)
    temp_c
}

# freezing point of water in Celsius
fahr_to_celsius(32.0)


# debugging a function
debugonce(fahr_to_celsius)
fahr_to_celsius(212)


## ____________________
## ----> Challenge ----
# Write a function to calculate the length of the hypotenuse of a right
# angled triangle using Pythagorus's rule, given the lengths of the
# other sides.
# Hint: `sqrt` calculates the square root of a number.
# Testing your code is important. Invent a test case for your code
# consisting of:
# * The input arguments to your function.
# * The return value you expect.
# Confirm that your function works as expected.
#
# ___________________
# ==== For-loops ====

# The general pattern of a loop is:

for(VARIABLE_NAME in VECTOR) {
  FOR_LOOP_BODY
}


# Let's look at an example. Suppose we have a calculation we need to
# perform on a series of numbers.

i <- 10
cat("i is",i,"\n")
cat("i squared is",i*i,"\n")
i <- 20
cat("i is",i,"\n")
cat("i squared is",i*i,"\n")
i <- 30
cat("i is",i,"\n")
cat("i squared is",i*i,"\n")
i <- 40
cat("i is",i,"\n")
cat("i squared is",i*i,"\n")
i <- 50
cat("i is",i,"\n")
cat("i squared is",i*i,"\n")


# Apart from the `i <- ...` lines, the code is the same each time. This
# can be re-written as a for-loop:

for(i in c(10,20,30,40,50)) {       #    1
    cat("i is",i,"\n")              #      2   4   6   8   10
    cat("i squared is",i*i,"\n")    #        3   5   7   9    11
}                                   #
                                    #
cat("done\n")                       #                            12
                                    #   --order-of-execution-->


## ____________________
## ----> Challenge ----
# As a small group, compare your answers as you go.
# 1. Write down what these lines of code do in English. Check they do
# what you expect by running them in R. Try adding `cat`s or `print`s to
# the for-loop body to check what is going on.

myvec <- c(10,20,30,40)

total <- 0
for(item in myvec) {
    total <- total + item
}

total

# 2. Write down what these lines of code do in English. How could this
# be changed to work with any length of `myvec`?

myvec <- c(10,20,30,40)

for(index in 1:4) {
    myvec[index] <- myvec[index] * 2
}

# 3. Write the steps to calculate *n* factorial in English, i.e. `1*2*3*
# ... *n`.
# 4. Write R code to calculate 10 factorial.

numbers <- 1:10

... your code here ...

#
# __________________________________________
# ==== A practical programming exercise ====

## ____________________________________
## ----> Running external software ----

# In RStudio, you can open a terminal using "Tools/Terminal/New
# Terminal". Try this and type in:

uptime


# The "uptime" command tells you how long the computer has been running
# for. R can give a command to the shell using the `system` function.

system("uptime")


# Here is how we want to run FastQC for day 0. To R the command has no
# meaning beyond being a character string. It will be interpreted by the
# shell, which is external to R. The shell will then run FastQC for us.

system("FastQC/fastqc --extract --outdir . r-progtidy-files/Day0.fastq")


# **If you don't have FastQC, or it failed to run for some reason:** The
# expected output files can be found in the folder
# "r-progtidy-files/fastqc-output".

## ___________________________
## ----> Using a for-loop ----

# construct a command to run
day <- 0
command <- paste0("FastQC/fastqc --extract --outdir . r-progtidy-files/Day", day, ".fastq")
command


# run fastqc on each of the files

days <- c(0,4,7,10,15,20)

for(day in days) {
    command <- paste0("FastQC/fastqc --extract --outdir . r-progtidy-files/Day", day, ".fastq")
    cat("Running the command:", command, "\n")
    system(command)
}


## ________________________________________
## ----> Loading the summary.txt files ----

# **Note:** If you weren't able to run FastQC earlier, the expected
# output files can be found in the folder
# "r-progtidy-files/fastqc-output". You will need to adjust the
# filenames appropriately in the R code below.

library(readr)


read_tsv("Day0_fastqc/summary.txt")


read_tsv("Day0_fastqc/summary.txt", col_names=FALSE)


read_tsv("Day0_fastqc/summary.txt", col_names=FALSE, col_types="ccc")


# We should tidy this up a bit before using it. Columns should have
# meaningful names, and the PASS/WARN/FAIL grading looks like it should
# be a factor:

filename <- "Day0_fastqc/summary.txt"
sumtab <- read_tsv(filename, col_names=FALSE, col_types="ccc")
colnames(sumtab) <- c("grade", "test", "file")
sumtab$grade <- factor(sumtab$grade, c("FAIL","WARN","PASS"))
sumtab


# We expect to have to examine many FastQC reports in future. It will be
# convenient to have this as a function!

load_fastqc <- function(filename) {
    sumtab <- read_tsv(filename, col_names=FALSE, col_types="ccc")
    colnames(sumtab) <- c("grade", "test", "file")
    sumtab$grade <- factor(sumtab$grade, c("FAIL","WARN","PASS"))
    sumtab
}

load_fastqc("Day0_fastqc/summary.txt")


## ________________________________
## ----> Applying the function ----

# First let's work out the names of the files we want to load.

days <- c(0,4,7,10,15,20)
filenames <- paste0("Day", days, "_fastqc/summary.txt")
filenames


# Now we can use `lapply` to apply our function to each of the
# filenames.

sumtabs <- lapply(filenames, load_fastqc)


# Using `lapply` is "functional programming", where we define a series
# of objects by using functions on earlier objects. In this approach
# objects are never modified once created. Sometimes the objects used
# are themselves functions.

# See also: `purrr` package.

# An alternative would be to use a for loop. Using a for loop is
# "procedural programming", where the result is modified step by step
# until we obtain the value we want:

sumtabs <- list()
for(idx in 1:length(filenames)) {
    sumtabs[[idx]] <- load_fastqc(filenames[idx])
}


# `sumtabs` is a list. Lists can contain things of different types and
# different sizes. Here we have a list of data frames. Lists are a
# little different from the vectors we usually work with. See section
# 20.5 in the "R for data science" book for a comprehensive explanation.
# http://r4ds.had.co.nz/vectors.html

# Here are some ways to examine this object:

sumtabs
class(sumtabs)
length(sumtabs)
str(sumtabs)


sumtabs[[1]]
sumtabs[[2]]


# It would be nicer if this was a single big data frame. The `dplyr`
# package provides a function to do this:

library(dplyr)
bigtab <- bind_rows(sumtabs)

bigtab
table(bigtab$test, bigtab$grade)


## __________________
## ----> Summary ----

# What we've just done is:

# 1. Create a custom reader tool that sets up each file inside R

# 2. Use a looping tool to apply that function to a collection of file
# names

# 3. Transform the results produced by the looping tool into a data
# frame that we can use for other purposes.

## ________________________________
## ----> Improving load_fastqc ----

# Our `load_fastqc` function will currently fail in a confusing way if
# it is given the wrong file:

load_fastqc("Day0_fastqc/fastqc_data.txt")


# It's best to stop as soon as something goes wrong, and with an
# informative error message.

load_fastqc <- function(filename) {
    # Load file
    sumtab <- read_tsv(filename, col_names=FALSE, col_types="ccc")

    # Check number of columns
    if (ncol(sumtab) != 3) {
        stop("Wrong number of columns in file!")
    }

    # Make it nicer to work with
    colnames(sumtab) <- c("grade", "test", "file")
    sumtab$grade <- factor(sumtab$grade, c("FAIL","WARN","PASS"))
    sumtab
}

load_fastqc("Day0_fastqc/fastqc_data.txt")


# Checking input arguments before proceeding is a common pattern when
# writing R functions.

# ___________________________
# ==== Sourcing .R files ====

# Having developed some useful functions, we might want to re-use them
# in a future project or share them with a friend. We can store R code
# in a file, usually with extension ".R", and load it with the `source`
# function.

# fastqc.R file should contain:

library(readr)

load_fastqc <- function(filename) {
    # Load file
    sumtab <- read_tsv(filename, col_names=FALSE, col_types="ccc")

    # Check number of columns
    if (ncol(sumtab) != 3) {
        stop("Wrong number of columns in file!")
    }

    # Make it nicer to work with
    colnames(sumtab) <- c("grade", "test", "file")
    sumtab$grade <- factor(sumtab$grade, c("FAIL","WARN","PASS"))
    sumtab
}


# From the console:

source("fastqc.R", local=TRUE)


# ______________________________
# ==== Organizing a project ====

# I like to organize large projects into multiple folders:

/raw        Raw data (do not edit!)
/output     Output files
/scripts    R scripts
/reports    Reports in R Markdown
README.txt


# Use version control, such as Git + GitHub.

# Some tips I've gathered:

# * Working on a project is iterative. Sometimes we put code for
# multiple approaches side by side. Sometimes we use version control
# features such as branches.

# * Coming back to a project, we've regretted not writing down the order
# things need to be run to fully reproduce outputs and reports, and what
# the preferred approach was if we tried many things.

# * Some people like `workflowr`, which automates working on a large
# project.

# * The `here` package is useful when you have multiple folders.

# See also Software Carpentry's list of best practices in R:
# http://swcarpentry.github.io/r-novice-inflammation/06-best-practices-R/

# See also Data Fluency workshop "Introduction to Data Organization."

# __________________
# ==== Packages ====

# Packages are the next step up from sourcing .R files. They let you
# write code that other people can install and then load with `library`.

# Hadley Wickham has a package called devtools that takes a lot of the
# pain out of package writing. Also useful is the package usethis, which
# automates creation of a package directory and basic files, and can set
# up various other parts of a package.
# https://cran.r-project.org/web/packages/devtools/index.html
# https://cran.r-project.org/web/packages/usethis/index.html

# Packages generally contain documentation and example code for all
# functions, and one or more vignettes describing how to use the
# package. Function documentation is usually written as specially
# formatted comments before each function using roxygen2.
# https://cran.r-project.org/web/packages/roxygen2/index.html

library(devtools)
library(usethis)

# Create an empty package template
create_package("mypack", open=FALSE)

# ... Edit mypack/DESCRIPTION file
# ... Write .R files in mypack/R folder
# For example create a file mypack/R/hello.R containing:
# # # # #

#' Greeting function
#'
#' This function displays a greeting message.
#'
#' @examples
#' hello()
#'
#' @export
hello <- function() {
    cat("Hello, world.\n")
}

# # # # #

# Build package documentation, converting inline documentation to .Rd files using roxygen2.
# Update NAMESPACE file (lists functions the package exports for public consumption).
document("mypack")

# Load package. Use this during development.
load_all("mypack")
hello()

# Check for common problems and missing documentation.
# This also automatically runs document( ).
# A CRAN package must pass all checks.
check("mypack")


# Packages are most easily distributed by placing them on GitHub or
# GitLab. They can then be installed by others using the `remotes`
# package functions `install_github` or `install_gitlab`.

# To install from GitHub:
remotes::install_github("myusername/mypack")


# Once a package is mature and well documented, it can be submitted to
# CRAN or Bioconductor.

# **CRAN submissions:** CRAN is quite strict about packages passing
# automated checks, and they will also manually review your package.
# Submission is by uploading the package tarball using a web form. Each
# new version also gets a brief manual review.

# **Bioconductor submissions:** Bioconductor is for packages that deal
# with large biology-related datasets. Packages should make use of
# existing Bioconductor data types and infrastructure where possible.
# Bioconductor has some additional automated checks you will need to
# pass. The initial review process is more intensive than CRAN's and
# happens in GitHub, so some familiarity with git will be necessary.
# Once the package is accepted, changes can be pushed to the
# Bioconductor git repositories without further manual review. You are
# also expected to be available to answer questions on their Stack
# Overflow-style support site and subscribe to the developer mailing
# list.

# (Recording the R version and versions of packages used improves reproducibility.)
sessionInfo()

