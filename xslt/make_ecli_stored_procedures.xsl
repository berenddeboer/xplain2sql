<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

<!--

Example style sheet to create a makefile to turn all procedures into
Eiffel classes.

-->

<xsl:output method="text"/>


<xsl:param name="xplain2sql-file-name"/>
<xsl:param name="make-procedure-file-name"/>
<xsl:param name="dialect"/>


<xsl:template match="/sql">
<xsl:if test="not($dialect)">
  <xsl:message terminate="yes">Parameter dialect is required.</xsl:message>
</xsl:if>
<xsl:text/># auto-generated makefile by make_ecli_stored_procedures.xsl

CLASSES = \
<xsl:apply-templates select="storedProcedure" mode="list"/>

all: $(CLASSES)

<xsl:apply-templates select="storedProcedure" mode="rule"/>
</xsl:template>


<xsl:template match="storedProcedure" mode="list">
<xsl:text>&#x09;</xsl:text><xsl:apply-templates select="." mode="file-name"/>
<xsl:if test="position()!=last()">
  <xsl:text> \&#x0a;</xsl:text>
</xsl:if>
</xsl:template>


<xsl:template match="storedProcedure" mode="rule">
<xsl:apply-templates select="." mode="file-name"/>: <xsl:value-of select="$xplain2sql-file-name"/><xsl:text> </xsl:text><xsl:value-of select="$make-procedure-file-name"/>
&#x09;xsltproc -o temp.e -stringparam procedureName "<xsl:value-of select="@xplainName"/>" -stringparam dialect <xsl:value-of select="$dialect"/><xsl:text> </xsl:text><xsl:value-of select="$make-procedure-file-name"/><xsl:text> </xsl:text><xsl:value-of select="$xplain2sql-file-name"/>
&#x09;mv temp.e $@

</xsl:template>


<!-- class name -->
<xsl:template match="storedProcedure" mode="file-name">
  <xsl:text/>mw_<xsl:value-of select="translate(@xplainName, ' -ABCDEFGHIJKLMNOPQRSTUVWXYZ', '__abcdefghijklmnopqrstuvwxyz')"/>.e<xsl:text/>
</xsl:template>


</xsl:stylesheet>
