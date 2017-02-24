# A template Makefile. Clone and own.

# see these links:
# http://geosoft.no/development/javamake.html
# http://www.cs.swarthmore.edu/~newhall/unixhelp/javamakefiles.html

.SUFFIXES: .pdf .tex .dot
.PHONY : classes clean 

TEX = $(shell find . -type f -name '*.tex' | sort)
DOT = $(shell find . -type f -name '*.dot' | sort)
BIB = $(shell find . -type f -name '*.bib' | sort)
#INC = $(shell find -name '*.tex' | xargs grep 'includegraphics.*{.*}' | sed -e 's/.*{//' -e 's/}.*//')


main.pdf: $(TEX) $(DOT) $(BIB)
	pdflatex -shell-escape main.tex > /dev/null
	bibtex -min-crossrefs=9000 main
	pdflatex -shell-escape main.tex > /dev/null
	@# pipe to cat so the exit code is 0 even if no lines selected
	@# grep usually exits with 1 if no lines selected
	@# non-zero exits cause Make to terminate with an error
	@grep 'LaTeX Warning:' main.log | cat
	@grep 'Output written' main.log | cat

# delete all the files that we've set the version control to ignore
# except for OSX system files, comment lines, and blank lines
CLEANEXCLUDES = -e '^\#' -e '^$$' -e .DS_Store* -e .Spotlight* -e .Trashes
clean:
	# extract raw list from version control system to .makeignore
	if [ -f .gitignore ] ; then cat .gitignore; else svn pg svn:ignore; fi > .makeignore
	# remove identified patterns
	rm -f `grep -v $(CLEANEXCLUDES) .makeignore`
	# remove our tmp file
	rm -f .makeignore
