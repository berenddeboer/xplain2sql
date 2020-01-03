# xplain2sql global Makefile

SHELL=/bin/sh

all: build

build:
	cd src; geant compile_release

install:
	cp src/xplain2sql /usr/local/bin

documentation:
	cd doc; make

examples:
	-rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-basic"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-ansi"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-interbase6"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-db26"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-db2"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-tsql65"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-tsql70"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-tsql"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-pgsql"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-mysql322"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-mysql"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-msql"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-oracle"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-sqlite"
	rm samples/*.sql
	cd src; make samples "SQLOPTIONS=" "SQLDIALECT=-pgsql -iso8601date"
	rm samples/*.sql

clean:
	cd src; make clean
	cd doc; make clean
