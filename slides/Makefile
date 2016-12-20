# Makefile per compilare documenti con LaTeX.

MAIN     = [PRES]-main
TEXDIR   = tex
IMGDIR   = img
PGFDIR   = pgf
MAINDIR  = PhD-Defense

PDFLATEX=lualatex

SERVER   =

TEX_INCLUDE =  [PRES]-intro.tex

IMG_INC_PDF =

IMG_INC_PGF =

IMG_GENERAL := $(shell find "img" -iname '*.png' -o -iname '*.pdf') # EPFL-logo.pdf EPFL-logo-notext.pdf LCMD-logo2.pdf img/intro/nano_solved.png

#IMG_INC_EPS = Newman_IDS-1C4.eps Newman_IDS-4C1.eps

BIB_INCLUDE =


SERVRDIR = $(SERVER):$(BASDIR)
MAIN_TEX = $(MAIN).tex
MAIN_AUX = $(MAIN).aux
MAIN_PDF = $(MAIN).pdf

SHELL = /bin/bash


###########################################################################

vpath %.png $(IMGDIR)
vpath %.pdf $(IMGDIR)
vpath %.eps $(IMGDIR)
vpath %.pgf $(PGFDIR)
vpath %.tex $(TEXDIR)
vpath %.bib $(TEXDIR)

ALL_TEX = $(MAIN_TEX) $(TEX_INCLUDE)
ALL_FILES = $(ALL_TEX)  $(IMG_INC_PDF) $(IMG_INC_EPS) Makefile
CLEAN_FILES = *~ *.dvi *.log *.aux *.toc *.lof *.lot \
	*.bbl *.blg *.idx *.ind *.ilg *.nav *.out *.snm \
	*.stamp *gnuplottex* *.vrb *.xml *.bcf
DISTCLEAN_FILES = $(MAIN_PDF)
TODAY = `date +%Y%m%d.%H%M`

###########################################################################

#%.eps : %.agr
#	gracebat $< $@
#	mv $@ $(IMGDIR)

%.pdf : %.pgf
	pdflatex $<
	mv $@ $(IMGDIR)/
	rm *.aux *.log

%.pdf : %.eps
	epstool --bbox --copy   $< --output asd.eps
	ps2pdf -dEPSCrop  asd.eps   $@; \
	rm asd.eps; \
	mv $@ $(IMGDIR)

# Low resolution
#%.pdf : %.eps
#	gs -r300 -dEPSCrop -dTextAlphaBits=4 -sDEVICE=png16m -sOutputFile=asd.png -dBATCH -dNOPAUSE $<
#	convert asd.png eps3:asd.eps
#	epstool --bbox --copy   asd.eps --output asd1.eps
#	ps2pdf -dEPSCrop  asd1.eps   $@; \
	rm asd.eps asd1.eps asd.png; \
	mv $@ $(IMGDIR)


#%.eps : %.fig
#	fig2dev -L eps $? $@

#%.eps : %.jpg
#	convert  $<  $@


###########################################################################

.PHONY: all pdf compress bib clean fullclean

all: $(MAIN_PDF)

pdf: $(MAIN_PDF)
	xpdf $(MAIN_PDF)

compress: fullclean
	cd .. ;tar cvfzps $(MAINDIR).$(TODAY).tar.gz $(MAINDIR)/ ; cd -

clean:
	cd tex;                \
	rm -f $(CLEAN_FILES);  \
	cd ..
	cd pgf;                \
	rm -f $(CLEAN_FILES);  \
	cd ..
	rm -f $(CLEAN_FILES)

fullclean: clean
	rm -f $(DISTCLEAN_FILES)
#	cd img; rm  -f $(IMG_INC_PDF); cd ..
#	cd ..;rm -f $(MAINDIR)*.tar.gz; cd -

$(MAIN_PDF): $(ALL_TEX) $(IMG_INC_PDF) $(IMG_GENERAL) Makefile
	cd $(TEXDIR); \
	$(PDFLATEX) -interaction=batchmode  -shell-escape $(MAIN_TEX); \
	for a in *gnuplottex.eps; do echo $$a; epspdf $$a; done; \
	$(PDFLATEX) $(MAIN_TEX); \
	mv -f $(MAIN_PDF) ..; \
	cd ..

bib: $(ALL_TEX) $(IMG_INC_PDF) $(BIB_INCLUDE)
	cd $(TEXDIR);           \
	lualatex $(MAIN_TEX);   \
	biber $(MAIN);     \
	lualatex $(MAIN_TEX);   \
	lualatex $(MAIN_TEX);   \
	mv -f $(MAIN_PDF) ..;   \
	cd ..


bibonly: $(ALL_TEX) $(IMG_INC_PDF) $(BIB_INCLUDE)
	cd $(TEXDIR);           \
	pdflatex $(MAIN_TEX);   \
	bibtex $(MAIN_AUX)
