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
	@grep 'LaTeX Warning:' main.log
	@grep 'Output written' main.log

# clean all the files that we've set svn to ignore
# which is roughly equivalent to the list below
clean:
	# remove all ignored files identified by wildcards + main.pdf
	# do not want to remove .DS_Store, which might be listed in ignores
	rm -f main.pdf `grep -v '^#' .gitignore | grep '\*'`
	#rm -f main.pdf `svn pg svn:ignore`
	#rm -f main.pdf *.aux *.bak *.bbl *.blg *.brf *.drv *.dvi *.glo *.gls *.idx *.ilg *.ind *.lof *.lot *.log *.nav *.nlo *.out *.snm *.tdo *.toc *.vrb
