# make xplain2sql documentation

SHELL=/bin/sh
.SUFFIXES:
.SUFFIXES: .mp .tex .pdf

SCHEMES= aggregation.mp \
	bank.mp \
	classification.mp \
	employee.mp \
	generalization.mp

PICTURES=*.png

SOURCES=xplain2sql.tex ${SCHEMES} ${PICTURES}

all: build

build: xplain2sql.pdf

xplain2sql.pdf: ${SOURCES}

clean:
	rm -f xplain2sql.pdf xplain2sql.log xplain2sql.tuo xplain2sql.tui xplain2sql.aux xplain2sql.bbl xplain2sql.blg temp.tuc temp.log

.tex.pdf:
	context --result=temp.pdf $<
	mv temp.pdf $@
