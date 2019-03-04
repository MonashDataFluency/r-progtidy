## ---- Libraries ----
library(tidyverse)

## ---- SourceFiles ----

cellstatsfiles <- list.files(pattern=glob2rx("*.csv"), 
                             path="CellExperiment/", 
                             recursive = TRUE,
                             full.names = TRUE)

head(cellstatsfiles)
length(cellstatsfiles)
## ---- SourceFilesAlternative ----
## save the filenames so we can repeat later on

writeLines(cellstatsfiles, "cellfiles.lst")
cellstatsfiles <- readLines("cellfiles.lst")

## Load one for testing purposes

testdf <- read_csv(cellstatsfiles[10])

## ---- LoadFunction ----
# Notice that there is no date, field or treatment. That information is in the file 
# path
# Lets develop the idiom from the fastqc example - write a special function
# to transform the input data
# Points - tools for manipulating file paths
# tools for pulling apart words - reference regular expressions.
# Special date objects - lubridate
#
loadCellExp <- function(filename) {
  if (!file.exists(filename)) {
    warning(paste("Missing", filename))
    return(NULL)
  }
  ## pull the filename apart with bash style processing
  pathA <- dirname(filename)
  folder1 <- basename(pathA)
  folder2 <- basename(dirname(pathA))
  
  ## Two ways of doing much the same thing
  folder1split <- stringr::str_split(folder1, pattern="--")
  field <- folder1split[[1]][2]
  treatment <- folder1split[[1]][3]
  
  filedate <- stringr::word(folder2, 2, sep="_")
  
  df <- read_csv(filename, col_types=cols(.default=col_double()))
  ## Add in our new fields
  df <- mutate(df, sourcefile=filename, treatment=treatment, 
               field=field, datestamp=as.Date(filedate, format="%Y%m%d"))
  df <- select(df, sourcefile, datestamp, treatment, field, everything())
  return(df)
}
## ---- Testing ----
#loadCellExp(cellstatsfiles[10])


## Now we have it working, instantly apply to everything

celldflist <- lapply(cellstatsfiles, loadCellExp) 
celldf <- bind_rows(celldflist)
## Doesn't work - why not?
## Can't guess the column types all the time - change
## the spec
a <- read_csv(cellstatsfiles[10], col_types=cols(.default=col_double()))

## tidyverse way:
## ---- LoadData ----
celldf <- map_df(cellstatsfiles, loadCellExp)

## ---- SummaryStats ----
count(celldf, datestamp, treatment)

## ---- Plot ----
ggplot(celldf, aes(x=datestamp, y=num_ATUB_orig_cell_mean_intensity)) + 
  geom_point(aes(colour=field), position="jitter") + 
  facet_wrap(~treatment)
