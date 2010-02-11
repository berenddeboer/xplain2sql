<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- Emit Makefile to generate middleware code for Delphi + ADO given an Xplain type -->


<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml">

<xsl:output
  method="text"
  version="1.0"
  encoding="ISO-8859-1"/>


<xsl:template match="/sql">
<xsl:text/># Generated Makefile

TABLES = \
<xsl:apply-templates select="table" mode="list"/>

all: $(TABLES)

# Generate classes
<xsl:apply-templates select="table" mode="entry"/>

</xsl:template>


<xsl:template match="table" mode="list">
<xsl:text>	</xsl:text>mw_<xsl:value-of select="@identifier"/>.pas<xsl:text/>
<xsl:if test="position()!=last()"> \
</xsl:if>
</xsl:template>


<xsl:template match="table" mode="entry">
mw_<xsl:value-of select="@identifier"/>.pas: xplain2sql.xml delphi_ado_class.xsl
	Xalan -o temp.pas -p table "'<xsl:value-of select="@xplainName"/>'" xplain2sql.xml delphi_ado_class.xsl
	mv temp.pas $@
</xsl:template>


</xsl:stylesheet>