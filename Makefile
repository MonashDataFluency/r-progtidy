
RMDS=index.Rmd \
     slides/introduction.Rmd \
     topics/programming.Rmd \
	 topics/communication.Rmd \
     topics/tidyverse.Rmd

HTMLS=$(patsubst %.Rmd,%.html,$(RMDS))

# Create stripped down versions of .Rmd files
RS=r-progtidy-files/programming.R \
   r-progtidy-files/communication.R \
   r-progtidy-files/tidyverse.R

# Create unevaluated versions (compact teacher's notes)
UNEVALS=topics/programming_uneval.html \
        topics/communication_uneval.html \
        topics/tidyverse_uneval.html


all : $(RS) $(HTMLS) $(UNEVALS) r-progtidy-files.zip

%.html : %.Rmd
	Rscript -e 'rmarkdown::render("$<", "all")'

%_uneval.html : %.Rmd Makefile
	python3 unevalify.py <$< >topics/temp.Rmd
	Rscript -e 'rmarkdown::render("topics/temp.Rmd", "all")'
	mv topics/temp.html $@
	rm topics/temp.Rmd

r-progtidy-files/%.R : topics/%.Rmd purify.py
	python3 purify.py <$< >$@

r-progtidy-files.zip : r-progtidy-files/* r-progtidy-files/fastqc-output/* $(RS)
	zip -FSr r-progtidy-files.zip r-progtidy-files

clean :
	rm -f $(HTMLS) $(RS) $(UNEVALS) r-progtidy-files.zip
	rm -rf topics/sequences_and_features_cache
	rm -rf topics/programming_cache

