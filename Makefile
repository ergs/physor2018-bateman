manuscript = physor2018-scopatz
references = physor
latexopt   = -halt-on-error -file-line-error

all: all-via-pdf

$(manuscript).tex: diff-hist.pdf

diff-hist.pdf: decay_analysis.ipynb
	ipython nbconvert --ExecutePreprocessor.timeout=6000 --execute decay_analysis.ipynb

all-via-pdf: $(manuscript).tex $(references).bib
	pdflatex $(latexopt) $(manuscript)
	bibtex $(manuscript).aux
	pdflatex $(latexopt) $(manuscript)
	pdflatex $(latexopt) $(manuscript)

all-via-dvi:
	latex $(latexopt) $(manuscript)
	bibtex $(manuscript).aux
	latex $(latexopt) $(manuscript)
	latex $(latexopt) $(manuscript)
	dvipdf $(manuscript)

epub:
	latex $(latexopt) $(manuscript)
	bibtex $(manuscript).aux
	mk4ht htlatex $(manuscript).tex 'xhtml,charset=utf-8,pmathml' ' -cunihtf -utf8 -cvalidate'
	ebook-convert $(manuscript).html $(manuscript).epub

clean:
	rm -f physor2018-scopatz.pdf *.dvi *.toc *.aux *.out *.log *.bbl *.blg *.log *.spl *~ *.spl *.zip *.acn *.glo *.ist *.epub

realclean: clean
	rm -rf $(manuscript).dvi
	rm -f $(manuscript).pdf

%.ps :%.eps
	convert $< $@

%.png :%.eps
	convert $< $@

zip:
	zip paper.zip *.tex *.eps *.bib

.PHONY: all clean
