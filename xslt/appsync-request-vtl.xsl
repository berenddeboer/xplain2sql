<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

<!--

Example style sheet to generate an AppSync Apache Velocity Request template.

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
  <xsl:apply-templates select="parameter" mode="quoted-string"/>
<xsltext/>{
  "version": "2018-05-29",
  "statements":   ["select <xsl:apply-templates select="select/column" mode="list"/> from <xsl:value-of select="@sqlNameAsCString"/>(<xsl:apply-templates select="parameter" mode="value"/>)"]
}
</xsl:template>


<xsl:template match="parameter" mode="quoted-string">
  <!-- skip -->
</xsl:template>

<xsl:template match="parameter[@xsd = 'string']" mode="quoted-string">
  <xsl:text/>#set($<xsl:value-of select="@identifier"/> = $context.args.<xsl:value-of select="@identifier"/>.toString().replace("'", "''"))
</xsl:template>


<xsl:template match="column" mode="list">
  <xsl:value-of select="@sqlNameAsCString"/>
  <xsl:if test="position() = 1"> as id</xsl:if>
  <xsl:if test="position() != last()">, </xsl:if>
</xsl:template>


<xsl:template match="parameter" mode="value">
  <xsl:variable name="quote" select="@xsd = 'string'"/>
  <xsl:choose>
    <xsl:when test="$quote">'$<xsl:value-of select="@identifier"/>'</xsl:when>
    <xsl:otherwise>
      <xsl:text>$context.args.</xsl:text><xsl:value-of select="@identifier"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="position() != last()">, </xsl:if>
</xsl:template>


</xsl:stylesheet>
