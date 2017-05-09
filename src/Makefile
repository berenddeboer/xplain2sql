# Makefile for xplain parser

SHELL=/bin/sh
.SUFFIXES:
.SUFFIXES: .l .y .e .ddl .sql

# Eiffel vendor
GOBO_EIFFEL=ise

# Where are GOBO's lex and yacc?
GELEX=gelex
GEYACC=geyacc

# xplain2sql sources
CREATED_SOURCES=xplain_scanner.e xplain_parser.e
E_SOURCES=$(shell find . -name "*.e")
SOURCES=system.xace build.eant $(CREATED_SOURCES) $(E_SOURCES)

W_code=${GOBO_BUILD_PREFIX}/EIFGENs/xplain2sql/W_code
F_code=${GOBO_BUILD_PREFIX}/EIFGENs/xplain2sql/F_code

# binary
# Windows platform:
#BINARIES=xplain2sql.exe
# Unix platforms:
BINARY=xplain2sql

all: build

build: $(BINARY)

$(BINARY): $(SOURCES)
	ec -project_path ${GOBO_BUILD_PREFIX} -config xplain2sql.ecf
	cd ${W_code} && finish_freezing
	cp -p ${W_code}/xplain2sql ${W_code}/xplain2sql.melted .
	rm -f $(SAMPLEFILES) $(SAMPLEFILE).sql

final_binary: $(SOURCES)
	ec -project_path ${GOBO_BUILD_PREFIX} -config xplain2sql.ecf -finalize
	cd ${F_code} && finish_freezing
	cp -p ${F_code}/xplain2sql .

TAGS: $(SOURCES)
	ctags -e *.e

xplain_parser.e: xplain_parser.y
	$(GEYACC) -t XPLAIN_TOKENS -v verbose.txt -o $@ $<

xplain_scanner.e: xplain_scanner.l
	$(GELEX) $<

docs: xplain2sql.pdf

xplain2sql.pdf: doc/xplain2sql.tex
	cd doc
	texexec -interface=en xplain2sql
	cd ..

clean:
	geant clean
	rm -f $(BINARY)
	rm -f $(CREATED_SOURCES)
	rm -f loadpath.se
	rm -f *.obj

# Below generation of test/example code
# Usually not needed by deployers

# MySQL settings
#MYSQL_HOST=bmach
#MYSQL_HOST=berend
MYSQL_HOST=localhost
MYSQL_USER=berend

# FireBird
#ISQL_FB=isql-fb
ISQL_FB=/opt/firebird/bin/isql

SAMPLEFILES=../samples/test.sql \
	../samples/testuse.sql \
	../samples/bank.sql \
	../samples/employee.sql \
	../samples/sales.sql \
	../samples/supplier.sql

SAMPLENAME=test2
#SAMPLENAME=graph
SAMPLEDIR=../samples/
SAMPLEFILE=$(SAMPLEDIR)$(SAMPLENAME)
#SAMPLEFILE=~/src/business-process/src/Xplain/call-center
#SAMPLEFILE=~/src/automatem/nakedbus/tools/Xplain/nakedbus_prices

SQLOPTIONS=-nosp
SQLDIALECT=-pgsql
#SQLOPTIONS=-nosp -pkformat '$$s_id' -sequenceformat '$$s_seq'

# Runs the test script and attempts
# to create an interbase database

createdb-interbase: build $(SAMPLEFILE).sql
	rm -f $(SAMPLENAME).gdb $(SAMPLEFILE).out
	echo 'create database "$(SAMPLENAME).gdb";' > createdb.sql
	/opt/interbase/bin/isql -i createdb.sql
	/opt/interbase/bin/isql -i $(SAMPLEFILE).sql -e -o $(SAMPLEFILE).out

createdb-firebird: build $(SAMPLEFILE).sql
	rm -f $(SAMPLENAME).gdb $(SAMPLEFILE).out
	echo 'create database "$(SAMPLENAME).gdb";' > createdb.sql
	$(ISQL_FB) -u sysdba -p masterkey -i createdb.sql
	$(ISQL_FB) -u sysdba -p masterkey -i $(SAMPLEFILE).sql -e -o $(SAMPLEFILE).out

#/usr/bin/postmaster (as user postgres)
# or just /etc/rc.d/init.d/postgres start
# to work under my own name, create proper user. su postgres and next
# use the createuser shell script for that.
# I've added plpgsql to the template database with:
#   createlang -d template1 --pglib=/usr/lib/pgsql plpgsql
# So I don't have to create it for every database anymore
createdb-pgsql: build $(SAMPLEFILE).sql
	-dropdb $(SAMPLENAME)
	createdb $(SAMPLENAME)
	#createlang --pglib=/usr/lib/pgsql plpgsql $(SAMPLENAME)
	#createlang plpgsql $(SAMPLENAME)
	psql -d $(SAMPLENAME) -f $(SAMPLEFILE).sql -o $(SAMPLEFILE).out 2> tmp.err
	-cat tmp.err | grep -v implicit > $(SAMPLEFILE).err
	cat $(SAMPLEFILE).err

createdb-mysql: build $(SAMPLEFILE).sql
	#/etc/init.d/mysqld start
	# make sure berend is added as user:
	-mysqladmin -h $(MYSQL_HOST) -u $(MYSQL_USER) -f drop $(SAMPLENAME)
	mysqladmin -h $(MYSQL_HOST) -u $(MYSQL_USER) create $(SAMPLENAME)
	mysql -h $(MYSQL_HOST) -u $(MYSQL_USER) --database=$(SAMPLENAME) --batch < $(SAMPLEFILE).sql > $(SAMPLEFILE).out

createdb-db2: build $(SAMPLEFILE).sql
	-db2 disconnect $(SAMPLENAME) > /dev/null
	-db2 "drop database $(SAMPLENAME)" > /dev/null
	db2 "create database $(SAMPLENAME)"
	db2 connect to $(SAMPLENAME);	db2 "CREATE USER TEMPORARY TABLESPACE USR_TEMPSPC1 MANAGED BY SYSTEM USING ('usr_tempspc1')"
	if [ -f $(SAMPLEFILE).out ]; then rm $(SAMPLEFILE).out; fi
	-db2 -w -td@ -vf $(SAMPLEFILE).sql -z $(SAMPLEFILE).out > /dev/null
	-grep -ne \^SQL $(SAMPLEFILE).out

# Oracle
# Important: export ORACLE_SID=xplain
# Become oracle user (su -l oracle) and do sqlplus /nolog
# > connect / as sysdba
# this is you want to create a db:
# > startup nomount
# remove all files in /opt/oracle/oradata/xplain/
# > @oracle_createdb.sql
# extra scripts:
# > @/opt/oracle/product/9.0.1/rdbms/admin/catalog.sql
# > @/opt/oracle/product/9.0.1/rdbms/admin/catproc.sql
# > @/opt/oracle/product/9.0.1/sqlplus/admin/pupbld.sql
# > @oracle_users.sql
# Finished.
# Do this if you just want to test:
# > startup
# I've an empty database in backup.xplain. It's usually faster to copy that
# one, but make sure the permissions for the oracle.oinstall users are
# retained!
# When connected, I can create users with:
#   create user berend identified by test;
# Better is to use script oracle_createuser.sql.
# This is user berend, password test.
# And drop them with:
#   drop user berend cascade;
# Scripts can be run with:
#   sqlplus berend/test @../samples/bank.sql
# showing compilation errors in sp:
#   show errors procedure/function sp_test;
# name without double quotes!
# I dropped the database by
# > shutdown
# manually removing all files
# The following does not actually create the database, just run the scripts
createdb-oracle: build $(SAMPLEFILE).sql
	sqlplus berend/masterkey @$(SAMPLEFILE).sql > $(SAMPLEFILE).out
	-grep -ne \^ORA $(SAMPLEFILE).out | grep -v ORA-00942

createdb-sqlite: build $(SAMPLEFILE).sql
	rm -f $(SAMPLENAME).db $(SAMPLEFILE).out
	sqlite3 $(SAMPLENAME).db < $(SAMPLEFILE).sql

samples: build $(SAMPLEFILES)

bank: build ../samples/bank.sql

sales: build ../samples/sales.sql

supplier: build ../samples/supplier.sql

test: build $(SAMPLEFILE).sql

testuse: build ../samples/testuse.sql


# TSQL only
testtsql: ../samples/testtsql.sql

# show output
# useful when debugging output for a certain construct
show: build
	./xplain2sql $(SQLDIALECT) $(SQLOPTIONS) $(SAMPLEFILE).ddl 2> $(SAMPLEFILE).err || cat $(SAMPLEFILE).err

# general transform .ddl to .sql
.ddl.sql: build
	rm -f $@
	./xplain2sql $(SQLDIALECT) $(SQLOPTIONS) $< > $@.tmp 2> $*.err
	mv $@.tmp $@
	@echo "Compilation errors:"
	cat $*.err
