<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

<!--

Example style sheet to generate an AppSync Apache Velocity Response template.

-->

<xsl:output
  method="text"
  version="1.0"
  encoding="UTF-8"/>


<xsl:param name="procedure-name"/>


<xsl:template match="/sql">
  <xsl:apply-templates select="storedProcedure[@xplainName = $procedure-name]"/>
</xsl:template>


<xsl:template match="storedProcedure">
  <xsl:text/>$utils.toJson($utils.rds.toJsonObject($ctx.result)[0])
</xsl:template>


<xsl:template match="storedProcedure[not(select/column)]">
  <xsl:text>[]</xsl:text>
</xsl:template>


</xsl:stylesheet>
