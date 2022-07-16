

# This short section looks at a couple of topics to do with
# professionally communicating your results with others: making nice
# looking plots, and producing documents including R output and code.

# Let's continue our examination of the FastQC output. If you're
# starting fresh for this lesson, you can load the necessary data frame
# with:

library(tidyverse)

bigtab <- read_csv("r-progtidy-files/fastqc.csv")


# _____________________________________
# ==== Publication quality ggplot2 ====

# With `ggplot2` we can view the whole data set.

ggplot(bigtab, aes(x=file,y=test,color=grade)) +
    geom_point()


ggplot(bigtab, aes(x=file,y=test,fill=grade)) +
    geom_tile()


# `ggplot2` offers a very wide variety of ways to adjust a plot. For
# categorical aesthetics, usually the first step is ensuring the
# relevant column is a factor with a meaningful level order.

# Put x axis in order first found in data frame
x_order <- unique(bigtab$file)
bigtab$file <- factor(bigtab$file, levels=x_order)

# Only necessary if not continuing from previous lesson on programming!
color_order <- c("FAIL", "WARN", "PASS")
bigtab$grade <- factor(bigtab$grade, levels=color_order)

myplot <- ggplot(bigtab, aes(x=file, y=test, fill=grade)) +
    geom_tile(color="black", size=0.5) +           # Black border on tiles
    scale_y_discrete(limits=rev) +                 # Flip the y axis
    scale_fill_manual(                             # Colors, as color hex codes
        values=c("#D81B60","#FFC107","#1E88E5")) +
    labs(x="", y="", fill="") +                    # Remove axis labels
    coord_fixed() +                                # Square tiles
    theme_minimal() +                              # Minimal theme, no grey background
    theme(panel.grid=element_blank(),              # No underlying grid lines
          axis.text.x=element_text(                # Vertical text on x axis
              angle=90,vjust=0.5,hjust=0))
myplot


## _____________________________________
## ----> Publication quality images ----

# Plots can be saved with ``ggsave``. Width and height are given in
# inches, and an image resolution in Dots Per Inch should also be given.
# The width and height will determine the relative size of text and
# graphics, so increasing the resolution is best done by adjusting the
# DPI. Compare the files produced by:

ggsave("plot-bad.png",  myplot, width=10, height=10, dpi=300)
ggsave("plot-good.png", myplot, width=5,  height=5,  dpi=600)


# It may be necessary to edit a plot further in a program such as
# Inkscape or Adobe Illustrator. To allow this, the image needs to be
# saved in a "vector" format such as SVG, EPS, or PDF. In this case, the
# DPI argument isn't needed.

# ______________________________
# ==== R Markdown documents ====

# This is a *very* brief introduction to a large topic.

# Use R Markdown to:

# * Make a record of results for yourself.

# * Communicate with your colleagues or supervisor.

# * Write a thesis, book, or journal article (but also consider using
# LaTeX for these).

# Create a file called `report.Rmd` containing:

---
title: Report
---

This is the result from running FastQC.

```{r}
library(tidyverse)

bigtab <- read_csv("r-progtidy-files/fastqc.csv")
bigtab
```


# Press the "knit" button or type:

rmarkdown::render("report.Rmd")


## ______________________
## ----> Code chunks ----

```{r}
# ...your code here...
```


# Code chunks can have options included in the curly brackets. In
# RStudio, click on the gear icon in the upper right of the code chunk
# to seem some options.

### ____________________
### ---->> Exercise ----
# 
# 1. Add a code chunk to produce the plot from the previous section.
# 
# 2. Adjust output of messages and warnings, and whether the code is
# shown.
# 
# 
#
## ___________________
## ----> Markdown ----

# R Markdown is built on Markdown, a concise way of formatting text
# documents with headings, formatting, links, tables, etc.

# Try including some of the following in your report:

# Heading

## Subheading

Some *italic* and **bold** text.

A [link](https://zombo.com/) to a website.


# Further reading:
# https://bookdown.org/yihui/rmarkdown/markdown-syntax.html

## ______________________
## ----> Mathematics ----

# R Markdown documents can include LaTeX-style mathematics.

# Try including this in your document:

$$
c = \sqrt{a^2+b^2}
$$


# More on math in rmarkdown:
# https://bookdown.org/yihui/rmarkdown/markdown-syntax.html#math-expressions

# More on LaTeX math: https://en.wikibooks.org/wiki/LaTeX/Mathematics

# A nice web editor: https://latexeditor.lagrida.com/

## _____________________
## ----> References ----

# References can included, with details given in a BibTeX file.

# BibTeX format is a little quirky. Sometimes you need to surround text
# in { } to prevent it being converted to lower case.

---
bibliography: r-progtidy-files/bibliography.bib
---

An experiment by @cleveland1984 compared different types of visual information.


# Citations in R Markdown:
# https://bookdown.org/yihui/rmarkdown-cookbook/bibliography.html

# About the BibTeX format: https://www.bibtex.com/format/

# Get BibTeX entry from a DOI:
# https://www.bibtex.com/c/doi-to-bibtex-converter/

## _________________________
## ----> Output formats ----

# By default `rmarkdown` produces HTML outputs. It can also produce PDF
# and Word documents. To output PDF, you will need to install TeX. It's
# also possible to produce slideshows.

# In RStudio, click on the gear icon and select "Output options..." or
# go to "File/New File/Rmarkdown..." and try a few of the template
# documents.

# The output format is determined by the `output: ...` line in the YAML
# header at the top of the document.

### ____________________________________
### ---->> I don't like R Notebooks ----

---
output: html_notebook
---


# RStudio also offers "R Notebooks". These are like R Markdown, but
# output can be produced chunk by chunk rather than all at once.

# You can get in a muddle with R Notebooks by running code in an odd
# order or using results from code that you then alter.

# R Notebooks may be appealing for long running computations. Consider
# instead putting long computations in a .R script. Save results with
# `saveRDS()` and load them in an R Markdown file with `readRDS()`. Your
# R Markdown documents should knit quickly.

## _______________________________________
## ----> More control over the output ----

# R Markdown has layers, like an onion. To really understand what is
# going on and fully control the appearance of the output, you may need
# to understand these underlying layers.

           rmarkdown and knitr                   pandoc
.Rmd input --------------------> .md (markdown) --------> .html output


            rmarkdown and knitr                 pandox and latex
.Rmd input ---------------------> .tex (latex) ------------------> .pdf output


# For HTML output, you can directly include HTML tags.

# For HTML output, CSS can be used to customize the look of the output.

# For larger documents, `bookdown` or `quarto` can be used.

# If your aim is to produce a PDF document such as a thesis or journal
# article, you may prefer to write LaTeX directly. R can still be used
# to produce plots!
