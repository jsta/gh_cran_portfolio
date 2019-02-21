
all: static/projects.csv

static/projects.csv: scripts/scrape.R
	Rscript $<