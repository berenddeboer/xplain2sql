<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- With the new -nospprefix switch, stored procedures must be
     renamed if you want to use an existing database.
     This script emits the rename SQL for Microsoft SQL Server.

     As input it expects xplain2sql.xml, and for every stored procedure
     mentioned, it emits a rename command.
-->


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
<xsl:text/>-- rename stored procedures without 'sp_' prefix.

-- rename insert/update/delete stored procedures
<xsl:apply-templates select="table"/>

-- rename user procedures
<xsl:apply-templates select="storedProcedure"/>
go
</xsl:template>


<xsl:template match="table">
<xsl:if test="@spInsert">
exec sp_rename <xsl:call-template name="sp-old-name"><xsl:with-param name="name" select="@spInsert"/></xsl:call-template>, <xsl:call-template name="sp-new-name"><xsl:with-param name="name" select="@spInsert"/></xsl:call-template>
</xsl:if>
<xsl:if test="@spUpdate">
exec sp_rename <xsl:call-template name="sp-old-name"><xsl:with-param name="name" select="@spUpdate"/></xsl:call-template>, <xsl:call-template name="sp-new-name"><xsl:with-param name="name" select="@spUpdate"/></xsl:call-template>
</xsl:if>
<xsl:if test="@spDelete">
exec sp_rename <xsl:call-template name="sp-old-name"><xsl:with-param name="name" select="@spDelete"/></xsl:call-template>, <xsl:call-template name="sp-new-name"><xsl:with-param name="name" select="@spDelete"/></xsl:call-template>
</xsl:if>
go
</xsl:template>


<xsl:template match="storedProcedure">
exec sp_rename <xsl:call-template name="sp-old-name"><xsl:with-param name="name" select="@sqlName"/></xsl:call-template>, <xsl:call-template name="sp-new-name"><xsl:with-param name="name" select="@sqlName"/></xsl:call-template>
</xsl:template>


<!-- determine old or new name, and return renamed name -->

<xsl:template name="sp-old-name">
<xsl:param name="name"/>
<xsl:choose>
  <xsl:when test="string-length ($name) - string-length (substring-after ($name, 'sp_')) &lt; 5">
    <xsl:value-of select="$name"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="concat (substring-before ($name, 'sp_'), substring-after ($name, 'sp_'))"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template name="sp-new-name">
<xsl:param name="name"/>
<xsl:choose>
  <xsl:when test="string-length ($name) - string-length (substring-after ($name, 'sp_')) &lt; 5">
    <xsl:value-of select="concat (substring-before ($name, 'sp_'), substring-after ($name, 'sp_'))"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$name"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>


</xsl:stylesheet>