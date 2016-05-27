# make xplain2sql documentation

SHELL=/bin/sh
.SUFFIXES:
.SUFFIXES: .mp .1 .tex .pdf

SCHEMES= aggregation.1 \
	bank.1 \
	classification.1 \
	employee.1 \
	generalization.1

PICTURES=*.png

SOURCES=xplain2sql.tex ${SCHEMES} ${PICTURES}

all: build

build: xplain2sql.pdf

xplain2sql.pdf: ${SOURCES}

clean:
	rm -f xplain2sql.pdf xplain2sql.log xplain2sql.tuo xplain2sql.tui
	rm -f mpgraph.* *.1 *.mpx

.tex.pdf:
	context --result=temp.pdf $<
	mv temp.pdf $@

.mp.1:
	mpost -mem=metafun.mem $<
