all: template.pdf

%.pdf : %.tex
	latexmk -pdf -pdflatex=lualatex $(basename $@)

%.tex: %.lhs
	lhs2TeX $< > $@
