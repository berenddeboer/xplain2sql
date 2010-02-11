# test generated makefile

test/Makefile: ../src/xplain2sql.xml delphi_makefile.xsl
	cd test && Xalan -o temp.mak ../../src/xplain2sql.xml ../delphi_makefile.xsl
	mv test/temp.mak $@
