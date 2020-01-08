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


<xsl:param name="procedure-identifier"/>


<xsl:template match="/sql">
  <xsl:if test="$procedure-identifier = ''">
    <xsl:message terminate="yes">Parameter procedure-identifier is required.</xsl:message>
  </xsl:if>
  <xsl:if test="not(storedProcedure[@identifier = $procedure-identifier])">
    <xsl:message terminate="yes">No procedure with identifier <xsl:value-of select="@procedure-identifier"/> found.</xsl:message>
  </xsl:if>
  <xsl:apply-templates select="storedProcedure[@identifier = $procedure-identifier]"/>
</xsl:template>


<xsl:template match="storedProcedure">
  <xsl:apply-templates select="parameter" mode="validate"/>
<xsltext/>{
  "version": "2018-05-29",
  "statements": [
    "select <xsl:if test="not(@returns)"><xsl:apply-templates select="select/column" mode="list"/> from </xsl:if><xsl:value-of select="@sqlNameAsCString"/>(<xsl:apply-templates select="parameter" mode="value"/>)<xsl:if test="@returns"> as <xsl:value-of select="select/column[1]/@sqlNameAsCString"/></xsl:if>"
  ],
  "variableMap": {<xsl:text/>
    <xsl:apply-templates select="parameter" mode="variable-map"/>
  }
}
</xsl:template>


<xsl:template match="parameter" mode="validate">
</xsl:template>

<xsl:template match="parameter[@xsd = 'positiveInteger']" mode="validate">
<xsl:text/>#if ($context.args.<xsl:apply-templates select="." mode="name"/> &lt; 1)
  $util.error("Provided input '<xsl:apply-templates select="." mode="name"/>' is not valid.")
#end
</xsl:template>


<xsl:template match="parameter" mode="variable-map">
    ":<xsl:apply-templates select="." mode="name"/>": $util.toJson($context.args.<xsl:apply-templates select="." mode="name"/><xsl:if test="@xsd = 'string'">.replace("'", "''")</xsl:if>)<xsl:text/>
  <xsl:if test="position() != last()">,</xsl:if>
</xsl:template>


<xsl:template match="column" mode="list">
  <xsl:value-of select="@sqlNameAsCString"/>
  <xsl:if test="position() = 1"> as id</xsl:if>
  <xsl:if test="position() != last()">, </xsl:if>
</xsl:template>


<xsl:template match="parameter" mode="value">
  <xsl:text/>:<xsl:apply-templates select="." mode="name"/>
  <xsl:if test="position() != last()">, </xsl:if>
</xsl:template>


<xsl:template match="parameter" mode="name">
  <xsl:choose>
    <xsl:when test="@references and @xplainName = @references and (../delete[@xplainName = current()/@references] or ../update[@xplainName = current()/@references] or ../select[@xplainName = current()/@references])">id</xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@identifier"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
