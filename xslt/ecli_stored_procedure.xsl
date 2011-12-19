<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- Example style sheet to generate an Eiffel class that can call a
     stored procedure through ECLI. -->


<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">


<xsl:param name="procedureName"/>
<xsl:param name="dialect"/>

<xsl:output
  method="text"
  encoding="ISO-8859-1"/>


<xsl:template match="/">
  <xsl:if test="not($procedureName)">
    <xsl:message terminate="yes">Parameter procedureName is required.</xsl:message>
  </xsl:if>
  <xsl:if test="not($dialect)">
    <xsl:message terminate="yes">Parameter dialect is required. Values: cli|pgsql|mysql</xsl:message>
  </xsl:if>
  <xsl:apply-templates select="sql/storedProcedure[@xplainName=$procedureName]"/>
</xsl:template>


<xsl:template match="storedProcedure">
<xsl:variable name="class-name">
  <xsl:apply-templates select="." mode="class-name"/>
</xsl:variable>
<xsl:text/>indexing

	description: "Generated middleware code for Xplain procedure <xsl:value-of select="@xplainName"/> to be used with ECLI."
  bugs: "PostgreSQL specific code right now."

class

	<xsl:value-of select="$class-name"/>

inherit

	XPLAIN_PROCEDURE


create

	make,
	make_start


feature -- Access

	expected_columns_count: INTEGER is <xsl:value-of select="count(select/column)"/>
			-- Expected number of columns returned by `execute'

	name: STRING is "<xsl:value-of select="$procedureName"/>"

	sql_name: STRING is "<xsl:value-of select="@sqlNameAsEiffelString"/>"


feature -- Columns
<xsl:apply-templates select="select/column" mode="define"/>

feature -- Parameters
<xsl:apply-templates select="parameter" mode="define"/>


feature {NONE} -- Implementation

	bind_columns is
			-- Bind column names to returned columns and check results.
		local
			v: ARRAY [ECLI_VALUE]
		do
			create v.make (1, result_columns_count)
<xsl:apply-templates select="select/column" mode="bind"/>
<xsl:text/>			set_results (v)
		end

	bind_input_parameters	is
			-- Create `parameters' and put them in `directed_parameters'.
		do
<xsl:apply-templates select="parameter" mode="create"/>
<xsl:text/>		end

	sql_stored_procedure_call: STRING is
			-- SQL to call a procedure
		do
			Result := "<xsl:choose>
<xsl:when test="$dialect='cli'">{call " + sql_name + " <xsl:if test="count(parameter)&gt;0">(<xsl:apply-templates select="parameter" mode="list"/>)</xsl:if>}</xsl:when>
<xsl:when test="$dialect='pgsql'">select * from " + sql_name + " (<xsl:apply-templates select="parameter" mode="list"/>)</xsl:when>
<xsl:when test="$dialect='mysql'">call " + sql_name + " (<xsl:apply-templates select="parameter" mode="list"/>)</xsl:when>
<xsl:otherwise>
  <xsl:message terminate="yes">Unrecognized dialect <xsl:value-of select="$dialect"/></xsl:message>
</xsl:otherwise>
</xsl:choose>"
		end

end
</xsl:template>


<xsl:template match="parameter" mode="list">?<xsl:value-of select="@identifier"/><xsl:if test="position()!=last()">, </xsl:if></xsl:template>


<xsl:template match="parameter" mode="define">
	param_<xsl:value-of select="@identifier"/>: ECLI_<xsl:apply-templates select="." mode="ecli-value-class"/>
</xsl:template>


<xsl:template match="parameter" mode="create">
<xsl:variable name="domain" select="substring(@xplainDomain, 2, 1)"/>
<xsl:text/>			create param_<xsl:value-of select="@identifier"/>.make<xsl:apply-templates select="." mode="create-parameters"/>
<xsl:if test="$domain='R'">
&#x09;&#x09;&#x09;param_<xsl:value-of select="@identifier"/>.set_item (decimal_zero)<xsl:text/>
</xsl:if>
			put_input_parameter (param_<xsl:value-of select="@identifier"/>, "<xsl:value-of select="@identifier"/>")
</xsl:template>


<xsl:template match="column" mode="define">
	its_<xsl:value-of select="@identifier"/>: ECLI_<xsl:apply-templates select="." mode="ecli-value-class"/>
</xsl:template>


<xsl:template match="column" mode="bind">
<xsl:text/>			create its_<xsl:value-of select="@identifier"/>.make<xsl:apply-templates select="." mode="create-parameters"/>
			v.put (its_<xsl:value-of select="@identifier"/>, <xsl:value-of select="position()"/>)
</xsl:template>


<xsl:template match="column|parameter" mode="create-parameters">
<xsl:variable name="domain" select="substring(@xplainDomain, 2, 1)"/>
<xsl:choose>
  <xsl:when test="$domain='A' or $domain='V'"> (<xsl:value-of select="substring-before(substring(@xplainDomain, 3), ')')"/>)</xsl:when>
  <xsl:when test="$domain='D'">_default</xsl:when>
  <xsl:when test="$domain='R'">
    <xsl:variable name="before" select="substring-before(substring(@xplainDomain, 3), ',')"/>
    <xsl:variable name="after" select="substring-before(substring-after(@xplainDomain, ','), ')')"/>
    <xsl:text/> (<xsl:value-of select="$before+$after"/>, <xsl:value-of select="$after"/>)</xsl:when>
  <xsl:when test="$domain='T'"> (65536)</xsl:when>
</xsl:choose>
</xsl:template>


<xsl:template match="column|parameter" mode="ecli-value-class">
<xsl:variable name="domain" select="substring(@xplainDomain, 2, 1)"/>
<xsl:choose>
  <xsl:when test="$domain='A'">UTF8_STRING</xsl:when>
  <xsl:when test="$domain='B'">BOOLEAN</xsl:when>
  <xsl:when test="$domain='D'">DATE_TIME</xsl:when>
  <xsl:when test="$domain='F'">DOUBLE</xsl:when>
  <xsl:when test="$domain='I'">INTEGER</xsl:when>
  <xsl:when test="$domain='R'">DECIMAL</xsl:when>
  <xsl:when test="$domain='T'">UTF8_STRING</xsl:when>
  <xsl:otherwise><xsl:message terminate="yes">UNHANDLED DOMAIN <xsl:value-of select="$domain"/></xsl:message></xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- class name -->
<xsl:template match="storedProcedure" mode="class-name">
  <xsl:text/>MW_<xsl:value-of select="translate(@xplainName, ' -abcdefghijklmnopqrstuvwxyz', '__ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:template>

</xsl:stylesheet>
