# This file is generated from the corresponding .Rmd file



# install.packages("tidyverse")


library(tidyverse) # Load all "tidyverse" libraries.
# OR
# library(readr)   # Read tabular data.
# library(tidyr)   # Data frame tidying functions.
# library(dplyr)   # General data frame manipulation.
# library(ggplot2) # Flexible plotting.


vignette()
vignette(package="dplyr")
vignette("dplyr", package="dplyr")


bigtab <- read_csv("r-progtidy-files/fastqc.csv")


# ___________________________
# ==== ggplot2 revisited ====

ggplot(bigtab, aes(x=file,y=test,color=grade)) +
    geom_point()


ggplot(bigtab, aes(x=file,y=test,fill=grade)) +
    geom_tile()


## _____________________________________
## ----> Publication quality images ----

y_order <- sort(unique(bigtab$test), decreasing=T)  # y axis plots from bottom to top, so reverse
bigtab$test <- factor(bigtab$test, levels=y_order)

x_order <- unique(bigtab$file)
bigtab$file <- factor(bigtab$file, levels=x_order)

# Only necessary if not continuing from previous lesson on programming!
color_order <- c("FAIL", "WARN", "PASS")
bigtab$grade <- factor(bigtab$grade, levels=color_order)

myplot <- ggplot(bigtab, aes(x=file, y=test, fill=grade)) +
    geom_tile(color="black", size=0.5) +           # Black border on tiles
    scale_fill_manual(                             # Colors, as color hex codes
        values=c("#ee0000","#ffee00","#00aa00")) +
    labs(x="", y="", fill="") +                    # Remove axis labels
    coord_fixed() +                                # Square tiles
    theme_minimal() +                              # Minimal theme, no grey background
    theme(panel.grid=element_blank(),              # No underlying grid lines
          axis.text.x=element_text(                # Vertical text on x axis
              angle=90,vjust=0.5,hjust=0))
myplot


ggsave("plot1.png", myplot, width=5,  height=5,  dpi=600)
ggsave("plot2.png", myplot, width=10, height=10, dpi=300)


# _______________
# ==== dplyr ====

# input         +--------+        +--------+        +--------+      result
#  data   %>%   |  verb  |  %>%   |  verb  |  %>%   |  verb  |  ->   data
#   frame       +--------+        +--------+        +--------+        frame


## __________________
## ----> Tibbles ----

bigtab


as.data.frame(bigtab)
View(bigtab)


print(bigtab, n=100, width=1000)


## ____________________
## ----> filter( ) ----

filter(bigtab, grade == "FAIL")


## _____________________
## ----> arrange( ) ----

arrange(bigtab, grade)

# desc( ) can be used to reverse the sort order
arrange(bigtab, desc(grade))


## ________________
## ----> Joins ----

fwp <- c("FAIL","WARN","PASS")
scoring <- tibble(grade=factor(fwp,levels=fwp), score=c(0,0.5,1))

# Or:
# scoring <- data.frame(grade=factor(fwp,levels=fwp), score=c(0,0.5,1))

scoring


scoretab <- left_join(bigtab, scoring, by="grade")
scoretab


## _______________________
## ----> summarize( ) ----

summarize(scoretab, average_score=mean(score))


group_by(scoretab, file)

summarize(group_by(scoretab, file), average_score=mean(score))


summarize(group_by(scoretab, grade), count=n())


## _______________________
## ----> The pipe %>% ----

scoretab %>% group_by(grade) %>% summarize(count=n())


rep(paste("hello", "world"), 5)

"hello" %>% paste("world") %>% rep(5)


scoretab %>%
    group_by(grade) %>%
    summarize(count=n())


### _____________________
### ---->> Challenge ----
# 
# Write a pipeline using `%>%`s that starts with `bigtab`, joins the
# `scoring` table, and then calculates average scores for each file.
# 
# 
# 
#
## ____________________
## ----> mutate( ) ----

mutate(scoretab, doublescore = score*2)


scoretab %>%
    mutate(doublescore = score*2)


scoretab2 <- scoretab
scoretab2$doublescore <- scoretab2$score * 2


## ____________________
## ----> select( ) ----

select(bigtab, test,grade)
select(bigtab, 2,1)
select(bigtab, foo=file, bar=test, baz=grade)


select(bigtab, -file)


# _______________
# ==== tidyr ====

untidy <- read_csv(
    "country,     male-young, male-old, female-young, female-old
     Australia,            1,        2,            3,          4
     New Zealand,          5,        6,            7,          8")
untidy


longer <- pivot_longer(untidy, cols=c(-country), names_to="group", values_to="cases")
longer


pivot_wider(longer, names_from=group, values_from=cases)
pivot_wider(bigtab, names_from=file, values_from=grade)


separate(longer, col=group, into=c("gender","age"))


tidied <- untidy %>%
    pivot_longer(cols=c(-country), names_to="group", values_to="cases") %>%
    separate(group, into=c("gender","age"))


pivot_longer(
    untidy, cols=c(-country),
    names_to=c("gender","age"), names_sep="-", values_to="cases")


# Advanced
nested <- nest(tidied, data=c(gender, age, cases))
nested
nested$data
unnest(nested, data)


### _____________________
### ---->> Challenge ----
# 
# You receive data on a set of points. The points are in two dimensions
# (`dim`), and each point has x and y coordinates. Unfortunately it
# looks like this:
# 

df <- read_csv(
    "dim, A_1, A_2, B_1, B_2, B_3, B_4, B_5
     x,   2,   4,   1,   2,   3,   4,   5
     y,   4,   4,   2,   1,   1,   1,   2")

# 
# 1. Tidy the data by pivoting longer all of the columns except `dim`.
# What what does each row now represent?
# 
# 2. We want to plot the points as a scatter-plot, using either `plot`
# or `ggplot`. Pivot the long data wider so that this is possible. Now
# what do the rows represent?
# 
# 3. What other tidying operation could be applied to this data?
# 
# 
#
# ____________________________
# ==== An RNA-Seq example ====

## ________________________________
## ----> Importing and tidying ----

# Use readr's read_csv function to load the file
counts_untidy <- read_csv("r-progtidy-files/read-counts.csv")

counts <- counts_untidy %>%
    pivot_longer(cols=c(-Feature), names_to="sample", values_to="count") %>%
    separate(sample, sep=":", into=c("strain","time"), convert=TRUE, remove=FALSE) %>%
    mutate(
        sample = factor(sample, unique(sample)),
        strain = factor(strain, levels=c("WT","SET1","RRP6","SET1-RRP6"))
    ) %>%
    filter(time >= 2) %>%
    select(sample, strain, time, gene=Feature, count)

summary(counts)


## ___________________________________________
## ----> Transformation and normalization ----

ggplot(counts, aes(x=sample, y=count)) +
    geom_boxplot() +
    coord_flip()


ggplot(counts, aes(x=sample, y=log2(count))) +
    geom_boxplot() +
    coord_flip()

ggplot(counts, aes(x=log2(count), group=sample)) +
    geom_line(stat="density")


normalizer <- counts %>%
    filter(gene == "SRP68") %>%
    select(sample, norm=count)

moderation <- 1/mean(normalizer$norm)

counts_norm <- counts %>%
    left_join(normalizer, by="sample") %>%
    mutate(
        norm_count = count/norm,
        log_norm_count = log2(norm_count+moderation)
    )

ggplot(counts_norm, aes(x=sample, y=log_norm_count)) +
    geom_boxplot() +
    coord_flip()


# For a full sized RNA-Seq dataset:
library(edgeR)
mat <- counts_untidy %>%
    column_to_rownames("Feature") %>%
    as.matrix()
adjusted_lib_sizes <- colSums(mat) * calcNormFactors(mat)
normalizer_by_tmm <- tibble(
    sample=names(adjusted_lib_sizes),
    norm=adjusted_lib_sizes)


## ________________________
## ----> Visualization ----

### _____________________
### ---->> Challenge ----
# 
# 1. Get all the rows in `counts_norm` relating to the histone gene
# "HHT1".
# 
# 2. Plot this data with ggplot2. Use `time` as the x-axis,
# `log_norm_count` as the y-axis, and color the data by `strain`. Try
# using geoms: `geom_point()`, `geom_line()`.
# 

ggplot( ... , aes(x= ... , y= ... , color= ... )) + ...

# 
# Extensions:
# 
# Compare plots of `log_norm_count`, `norm_count`, and `count`.
# 
# Experiment with other geoms and other ways to assign columns to
# aesthetics.
# 
# 
#
### _______________________________________
### ---->> Whole dataset visualization ----

ggplot(counts_norm, aes(x=sample, y=gene, fill=log_norm_count)) +
    geom_tile() +
    scale_fill_viridis_c() +
    theme_minimal() +
    theme(axis.text.x=element_text(           # Vertical text on x axis
              angle=90,vjust=0.5,hjust=1))


ggplot(counts_norm, aes(x=time, y=gene, fill=log_norm_count)) +
    geom_tile() +
    facet_grid(~ strain) +
    scale_fill_viridis_c() +
    theme_minimal()


ggplot(counts_norm, aes(x=time, y=strain, fill=log_norm_count)) +
    geom_tile() +
    facet_wrap(~ gene) +
    scale_fill_viridis_c() +
    theme_minimal()


ggplot(counts_norm, aes(x=time, y=log_norm_count, color=strain, group=strain)) +
    geom_line() +
    facet_wrap(~ gene, scale="free")


### _____________________
### ---->> Exercises ----
# 
# 1. Which are the three most variable genes?
# 
# Hint:
# `intToUtf8(utf8ToInt("xvh#jurxsbe|/#vxppdul}h/#vg/#dqg#duudqjh")-3)`
# 
# 2. Different genes have different average expression levels, but what
# we are interested in is how they change over time. Further normalize
# the data by subtracting the average for each gene from
# `log_norm_count`.
# 
#
### ____________
### ---->>  ----

sessionInfo()

