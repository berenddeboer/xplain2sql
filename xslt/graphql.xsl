<?xml version="1.0" encoding="UTF-8" ?>

<!-- Emit GraphQL Schema Definition. Specific for AWS AppSync. -->


<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
  method="text"
  version="1.0"
  encoding="UTF-8"/>


<xsl:template match="/sql">
<xsl:text/># GraphSQL schema generated by xplain2sql and graphql.xsl.
#
# DO NOT EDIT
#

<xsl:apply-templates select="table/column[enum]" mode="enum"/>

<xsl:apply-templates select="table | storedProcedure[select/column]" mode="type"/>


type Query {<xsl:text/>
<xsl:apply-templates select="storedProcedure" mode="query"/>
}


<xsl:if test="storedProcedure[insert | update | delete]">
type Mutation {<xsl:text/>
<xsl:apply-templates select="storedProcedure" mode="mutation"/>
}
</xsl:if>


schema {
  query: Query<xsl:text/>
<xsl:if test="storedProcedure[insert | update | delete]">
  mutation: Mutation
</xsl:if>
}
</xsl:template>


<!-- Emit an enum -->

<xsl:template match="column" mode="enum">
<xsl:text/>enum <xsl:value-of select="@identifier"/> {
<xsl:apply-templates select="enum"/>
}
</xsl:template>


<xsl:template match="enum">
  <xsl:text>  </xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>
</xsl:text>
</xsl:template>



<!-- Emit a type -->

<xsl:template match="table" mode="type">
type <xsl:value-of select="@identifier"/> {
<xsl:apply-templates select="column" mode="field"/>
<xsl:text/>}
</xsl:template>


<xsl:template match="storedProcedure" mode="type">
type <xsl:value-of select="@identifier"/>Columns {
<xsl:apply-templates select="select/column" mode="field"/>
<xsl:text/>}
</xsl:template>


<xsl:template match="storedProcedure[select/@attributes = 'all' or @returns]" mode="type">
  <!-- skip -->
</xsl:template>


<!-- Emit a field -->

<xsl:template match="column" mode="field">
  <xsl:text>  </xsl:text><xsl:value-of select="@identifier"/>: <xsl:apply-templates select="." mode="type"/><xsl:if test="not(@optional)">!</xsl:if>
  <xsl:text>
</xsl:text>
</xsl:template>


<xsl:template match="column[1]" mode="field">
  <xsl:text/>  id: <xsl:apply-templates select="." mode="type"/>!<xsl:text>
</xsl:text>
</xsl:template>


<!-- scalar types with AWS AppSync support -->

<xsl:template match="column | parameter" mode="type">
  <xsl:text>String</xsl:text>
</xsl:template>

<xsl:template match="*[@xsd = 'boolean']" mode="type">
  <xsl:text>Boolean</xsl:text>
</xsl:template>

<xsl:template match="*[@xsd = 'dateTime']" mode="type">
  <xsl:text>AWSDateTime</xsl:text>
</xsl:template>

<xsl:template match="*[@xsd = 'decimal']" mode="type">
  <xsl:text>Float</xsl:text>
</xsl:template>

<xsl:template match="column[@xsd = 'positiveInteger'] | parameter[@xsd = 'positiveInteger'] | column[@xsd = 'int'] | parameter[@xsd = 'int']" mode="type">
  <!-- TODO: need to take length into account, only 32-bit integers accepted!! -->
  <xsl:text>Int</xsl:text>
</xsl:template>

<xsl:template match="*[@references]" mode="type">
  <xsl:value-of select="@identifier"/>
</xsl:template>

<xsl:template match="column[enum][@xsd = 'string']" mode="type">
  <xsl:value-of select="@identifier"/>
</xsl:template>

<xsl:template match="parameter[@xsd = 'string']" mode="type">
  <xsl:choose>
    <xsl:when test="/sql/table/column[@xplainName = current()/@xplainName][enum]">
      <xsl:value-of select="@identifier"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>String</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- Emit a query -->

<xsl:template match="storedProcedure[select]" mode="query">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="storedProcedure[insert | update | delete]" mode="query">
  <!-- skip -->
</xsl:template>



<!-- Emit a mutation -->

<xsl:template match="storedProcedure" mode="mutation">
  <!-- skip -->
</xsl:template>

<xsl:template match="storedProcedure[insert | update | delete]" mode="mutation">
  <xsl:apply-templates select="."/>
</xsl:template>


<!-- Emit procedure -->

<xsl:template match="storedProcedure">
  <xsl:variable name="name" select="select/@xplainName"/>
  <xsl:variable name="max-one-row" select="select/@instance = true() or select/@value = true()"/>
  <xsl:text>
  </xsl:text><xsl:value-of select="@identifier"/><xsl:if test="parameter">(<xsl:apply-templates select="parameter" mode="parameter"/>)</xsl:if>: <xsl:if test="not($max-one-row)">[</xsl:if>
  <xsl:choose>
    <xsl:when test="select/column">
      <xsl:choose>
        <xsl:when test="@returns">
          <xsl:apply-templates select="select/column[1]" mode="type"/>
        </xsl:when>
        <xsl:when test="select/@attributes = 'all'">
          <xsl:value-of select="/sql/table[@xplainName = $name]/@identifier"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@identifier"/>Columns<xsl:text/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="select/@instance = false()">!</xsl:if>
    </xsl:when>
    <xsl:otherwise>Boolean</xsl:otherwise>
  </xsl:choose>
  <xsl:if test="not($max-one-row)">]</xsl:if>
</xsl:template>

<xsl:template match="parameter" mode="parameter">
  <xsl:apply-templates select="." mode="name"/>: <xsl:apply-templates select="." mode="type"/><xsl:if test="not(@optional)">!</xsl:if>
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
