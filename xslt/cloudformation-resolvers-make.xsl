<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

<!--

Example style sheet to create a makefile to create resolvers for all procedures.

-->

<xsl:output
  method="text"
  version="1.0"
  encoding="UTF-8"/>


<xsl:param name="request-transformation"/>
<xsl:param name="response-transformation"/>
<xsl:param name="target-directory"/>


<xsl:template match="/sql">
<xsl:text/># Auto-generated makefile to generate CloudFormation resolvers

RESOLVERS = \
<xsl:apply-templates select="storedProcedure" mode="list"/>

all: $(RESOLVERS)

clean:
&#x09;rm -f $(RESOLVERS)

Query.%.req.vtl: <xsl:value-of select="$request-transformation"/> xplain2sql.xml
&#x09;xsltproc -stringparam procedure-identifier "$(*F)" $^ > $@.tmp
&#x09;mv $@.tmp $@

Mutation.%.req.vtl: <xsl:value-of select="$request-transformation"/> xplain2sql.xml
&#x09;xsltproc -stringparam procedure-identifier "$(*F)" $^ > $@.tmp
&#x09;mv $@.tmp $@

Query.%.res.vtl: <xsl:value-of select="$response-transformation"/> xplain2sql.xml
&#x09;xsltproc -stringparam procedure-identifier "$(*F)" $^ > $@.tmp
&#x09;mv $@.tmp $@

Mutation.%.res.vtl: <xsl:value-of select="$response-transformation"/> xplain2sql.xml
&#x09;xsltproc -stringparam procedure-identifier "$(*F)" $^ > $@.tmp
&#x09;mv $@.tmp $@
</xsl:template>


<xsl:template match="storedProcedure" mode="list">
  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="insert | update | delete">
        <xsl:text>Mutation</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Query</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
<xsl:text>&#x09;</xsl:text><xsl:value-of select="$target-directory"/><xsl:value-of select="$type"/>.<xsl:value-of select="@identifier"/>.req.vtl \
<xsl:text>&#x09;</xsl:text><xsl:value-of select="$target-directory"/><xsl:value-of select="$type"/>.<xsl:value-of select="@identifier"/>.res.vtl<xsl:text/>
<xsl:if test="position()!=last()">
  <xsl:text> \&#x0a;</xsl:text>
</xsl:if>
</xsl:template>


</xsl:stylesheet>
