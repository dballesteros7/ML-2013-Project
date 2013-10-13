all: validationPreds.csv

analysis.md:analysis.Rmd
	Rscript -e "require(knitr); knit('analysis.Rmd')"

analysis.html:analysis.md
	markdown analysis.md > analysis.html

validationPreds.csv:analysis.md
