#!/bin/sh

# BEREND, after setting the release name
# CHECK THE NEXT THINGS AS WELL!!!

releasename=xplain2sql-beta-4.1.0
#releasename=xplain2sql-beta-3.9.0

# CHECK THIS TO!!
# 1. check XPLAIN2SQL.Version!
# 2. change pkg/xplain2sql.spec too!
# 3. test if src/system.xace assertion is ok for your release
#    - for beta's assertion should be all.
#    - for official releases it should be none.
# 4. check NEWS

# make sure documentation is up-to-date
cd doc
make
if [ $? -gt 0 ]; then exit 1; fi
cd ..

# make sure the created classes are there
cd src
make xplain_scanner.e
if [ $? -gt 0 ]; then exit 1; fi
make xplain_parser.e
if [ $? -gt 0 ]; then exit 1; fi
cd ..

# we want an i386 version only, so make sure we have the default CFLAGS.
unset CFLAGS

# build .tar.gz release
cd ..
tar -czf $releasename.tar.gz xplain2sql/README xplain2sql/NEWS xplain2sql/INSTALL xplain2sql/LICENSE xplain2sql/ChangeLog xplain2sql/Makefile `find xplain2sql/src -name "*.e"` xplain2sql/src/*.y xplain2sql/src/*.l xplain2sql/src/Makefile xplain2sql/src/system.xace xplain2sql/src/build.eant xplain2sql/src/*.bat xplain2sql/samples/bank.ddl xplain2sql/samples/employee.ddl  xplain2sql/samples/sales.ddl xplain2sql/samples/supplier.ddl xplain2sql/samples/test.ddl xplain2sql/samples/include.ddl xplain2sql/samples/testuse.ddl xplain2sql/samples/testused.ddl xplain2sql/samples/testtsql.ddl xplain2sql/middleware/*.pas xplain2sql/doc/xplain2sql.pdf xplain2sql/doc/*.tex xplain2sql/doc/*.mp xplain2sql/doc/*.png xplain2sql/doc/Makefile xplain2sql/xslt/delphi_ado_class.xsl xplain2sql/xslt/delphi_makefile.xsl xplain2sql/man/xplain2sql.1
cd xplain2sql
mv -f ../$releasename.tar.gz .

# extract to temporary directory
rm -rf builddir
mkdir builddir
cd builddir
tar -xvzf ../$releasename.tar.gz

# build .zip file
zip -r $releasename.zip xplain2sql
if [ $? -gt 0 ]; then exit 1; fi
mv $releasename.zip ..
cd ..
rm -rf builddir
mkdir builddir
cd builddir
unzip ../$releasename.zip
if [ $? -gt 0 ]; then exit 1; fi

# test release
# make with .y and .l
cd xplain2sql
make
if [ $? -gt 0 ]; then exit 1; fi

# make without .y and .l
# also produce production code
make clean
if [ $? -gt 0 ]; then exit 1; fi
make
if [ $? -gt 0 ]; then exit 1; fi

# build the examples
make examples
if [ $? -gt 0 ]; then exit 1; fi


# make C source release
# test it by renaming xplain2sql, making and reverting rename
cd ..
mkdir $releasename
cd $releasename
cp ../xplain2sql/src/xplain2sql.[ch] .
cp ../../Makefile.csrc Makefile
cp ../../README.csrc README
cp ../../NEWS .
cp ../../ChangeLog .
cp ../../LICENSE .
cp ../../pkg/xplain2sql.spec .
cp ../../man/xplain2sql.1 .
make
if [ $? -gt 0 ]; then exit 1; fi
rm xplain2sql
cd ..
rm ../$releasename-csrc.*
tar -czf ../$releasename-csrc.tar.gz $releasename
zip -r ../$releasename-csrc.zip $releasename

# build the RPM
#rpmbuild -ta ../$releasename-csrc.tar.gz
#if [ $? -gt 0 ]; then exit 1; fi
#cp /usr/src/redhat/RPMS/i386/$releasename-1.i386.rpm ..
cd $releasename
make
cd ..
mkdir -p debian/usr/bin debian/usr/share/man/man1 debian/DEBIAN
cp $releasename/xplain2sql debian/usr/bin/
cp $releasename/xplain2sql.1 debian/usr/share/man/man1
cp ../pkg/control debian/DEBIAN/control
dpkg --build debian ../$releasename-1_i386.deb

# ready
cd ..
