.PHONY: all clean

all: handout.pdf 
	cp handout.pdf ../

clean:
	rm -f *.aux *.bbl *.log *.blg

distclean:
	clean
	rm -r handout.pdf

%.aux : %.tex 
	pdflatex $*

%.pdf : %.tex %.bbl style.tex
	while (pdflatex $* ; \
	grep -q "Rerun to get cross" $*.log ) do true ; \
	done

%.bbl : %.aux biblio.bib
	bibtex $*


