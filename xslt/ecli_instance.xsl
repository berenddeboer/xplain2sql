<?xml version="1.0" encoding="ISO-8859-1" ?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

<!-- Example style sheet to generate an Eiffel class to access
     instances for a given Xplain type for use with XPLAIN_INSTANCE
     and ECLI. -->


<xsl:param name="type"/>
<xsl:param name="dialect"/>

<xsl:output
  method="text"
  encoding="ISO-8859-1"/>


<xsl:template match="/">
  <xsl:if test="not($type)">
    <xsl:message terminate="yes">Parameter type is required.</xsl:message>
  </xsl:if>
  <xsl:if test="not($dialect)">
    <xsl:message terminate="yes">Parameter dialect is required. Values: cli|pgsql|mysql</xsl:message>
  </xsl:if>
  <xsl:variable name="table" select="sql/table[@xplainName=$type]"/>
  <xsl:if test="not($table)">
    <xsl:message terminate="yes">Xplain type "<xsl:value-of select="$type"/>" not found.</xsl:message>
  </xsl:if>
  <xsl:if test="not($table/@spDeleteAsEiffelString)">
    <xsl:message terminate="yes">No insert, update or delete procedure present.</xsl:message>
  </xsl:if>
  <xsl:apply-templates select="$table" />
</xsl:template>


<xsl:template match="table">
<xsl:variable name="class-name">
  <xsl:apply-templates select="." mode="class-name"/>
</xsl:variable>
<xsl:text/>indexing

	description: "Generated middleware code for Xplain type <xsl:value-of select="@xplainName"/> to be used with ECLI."


class

	<xsl:value-of select="$class-name"/>


inherit

	XPLAIN_INSTANCE


create

	make


feature -- Access

	instance_name: STRING is "<xsl:value-of select="@xplainName"/>"
			-- Xplain instance name

	table_name: STRING is "<xsl:apply-templates select="." mode="string"/>"
			-- SQL table name

	pk_column_name: STRING is "<xsl:apply-templates select="column[1]" mode="string"/>"
			-- Name of primary key column


feature -- Set instance id

	clear_instance_id is
		do
			its_<xsl:value-of select="column/@identifier"/>.set_item (0)
		end

	set_instance_id (new_id: INTEGER) is
		do
			its_<xsl:value-of select="column/@identifier"/>.set_item (new_id)
		end


feature -- Attribute names
<xsl:apply-templates select="column[position()!=1]" mode="definition"/>


feature {NONE} -- Hidden instance column
<xsl:apply-templates select="column[position()=1]" mode="definition"/>


feature {NONE} -- Parameter support

	add_delete_parameters (a_procedure: ECLI_STORED_PROCEDURE) is
			-- Create the parameters used to communicate with the delete
			-- stored procedure.
		do
<xsl:apply-templates select="column[1]" mode="add_delete_param"/>
		end

	add_insert_parameters (a_procedure: ECLI_STORED_PROCEDURE) is
			-- Create the parameters used to communicate with the insert
			-- stored procedure.
		do
<xsl:apply-templates select="column[position()!=1 and @init!='always']" mode="add_insert_param"/>
<xsl:text/>			-- a_procedure.put_output_parameter (return_instance_id_value, "id")
		end

	add_update_parameters (a_procedure: ECLI_STORED_PROCEDURE) is
			-- Create the parameters used to communicate with the update
			-- stored procedure.
		do
<xsl:apply-templates select="column" mode="add_update_param"/>
<xsl:text/>		end

	-- insert_parameters_string: STRING is "<xsl:apply-templates select="column[position()!=1 and @init!='always']" mode="insert_parameters_string"/>, ?id"
	insert_parameters_string: STRING is "<xsl:apply-templates select="column[position()!=1 and @init!='always']" mode="insert_parameters_string"/>"

	delete_parameters_string: STRING is "<xsl:apply-templates select="column[1]" mode="delete_parameters_string"/>"

	insert_values: ARRAY [ECLI_VALUE] is
		do
			if my_insert_values = Void then
<!-- 				my_insert_values := &lt;&lt;<xsl:apply-templates select="column[position()!=1 and @init!='always']" mode="insert_values"/>, return_instance_id_value&gt;&gt; -->
				my_insert_values := &lt;&lt;<xsl:apply-templates select="column[position()!=1 and @init!='always']" mode="insert_values"/>&gt;&gt;
			end
			Result := my_insert_values
		end

	number_of_attributes: INTEGER is <xsl:value-of select="count(column)-1"/>

	update_parameters_string: STRING is "<xsl:apply-templates select="column" mode="update_parameters_string"/>"

	update_values: ARRAY [ECLI_VALUE] is
		do
			if my_update_values = Void then
				create my_update_values.make (1, <xsl:value-of select="count(column)"/>)
<xsl:apply-templates select="column" mode="update_values"/>
<xsl:text/>			end
			Result := my_update_values
		end


feature {NONE} -- Result set support

	attribute_names: ARRAY [STRING] is
		once
			Result := &lt;&lt;<xsl:apply-templates select="column" mode="attribute-name"/>&gt;&gt;
		end

	instance_cursor: ARRAY [ECLI_VALUE] is
		do
			if my_instance_cursor = Void then
				create my_instance_cursor.make (1, number_of_attributes + 1)
<xsl:apply-templates select="column" mode="cursor"/>
<xsl:text/>			end
			Result := my_instance_cursor
		end

	make_values is
			-- Create the individual value objects used to hold returned
			-- values.
		do
<xsl:apply-templates select="column" mode="create"/>
<xsl:text/>		end

	select_column_names: STRING is "<xsl:apply-templates select="column" mode="select-column"/>"


feature {NONE} -- Names of stored procedures

	sp_delete_name: STRING is "<xsl:value-of select="@spDeleteAsEiffelString"/>"

	sp_insert_name: STRING is "<xsl:value-of select="@spInsertAsEiffelString"/>"

	sp_update_name: STRING is "<xsl:value-of select="@spUpdateAsEiffelString"/>"


feature {NONE} -- SQL dialect

	dialect: INTEGER is <xsl:choose>
<xsl:when test="$dialect='cli'">1</xsl:when>
<xsl:when test="$dialect='mysql'">2</xsl:when>
<xsl:when test="$dialect='pgsql'">3</xsl:when>
<xsl:otherwise>
  <xsl:message terminate="yes">Unrecognized dialect <xsl:value-of select="$dialect"/></xsl:message>
</xsl:otherwise>
</xsl:choose>

feature {NONE} -- Implementation

	my_instance_id: INTEGER is
			-- Value of current instance.
		do
			Result := its_<xsl:value-of select="column/@identifier"/>.item.item
		end


invariant

	its_attributes_not_void:<xsl:apply-templates select="column" mode="invariant"/>
end
</xsl:template>


<xsl:template match="column" mode="create">
<xsl:text/>			create its_<xsl:value-of select="@identifier"/>.make<xsl:choose>
<xsl:when test="substring(@xplainDomain,2,1)='A'"> (<xsl:value-of select="substring-before(substring(@xplainDomain, 3), ')')"/>)</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='D'">_default</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='R'">
  <xsl:variable name="before" select="substring-before(substring-after(@xplainDomain, '(R'), ',')"/>
  <xsl:variable name="after" select="substring-before(substring-after(@xplainDomain, ','), ')')"/>
  <xsl:text/>(<xsl:value-of select="$before+$after"/>, <xsl:value-of select="$after"/>)<xsl:text/>
</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='T'"> (16384)</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='V'"> (<xsl:value-of select="substring-before(substring(@xplainDomain, 3), ')')"/>)</xsl:when>
</xsl:choose>
<xsl:text>
</xsl:text>
</xsl:template>


<xsl:template match="column" mode="add_delete_param">
<xsl:text/>			a_procedure.put_input_parameter (its_<xsl:value-of select="@identifier"/>, "<xsl:value-of select="@identifier"/>")
</xsl:template>


<xsl:template match="column" mode="add_insert_param">
<xsl:text/>			a_procedure.put_input_parameter (its_<xsl:value-of select="@identifier"/>, "<xsl:value-of select="@identifier"/>")
</xsl:template>


<xsl:template match="column" mode="add_update_param">
<xsl:text/>			a_procedure.put_input_parameter (its_<xsl:value-of select="@identifier"/>, "<xsl:value-of select="@identifier"/>")
</xsl:template>


<xsl:template match="column" mode="definition">
	its_<xsl:value-of select="@identifier"/>: <xsl:choose>
<xsl:when test="substring(@xplainDomain,2,1)='A'">ECLI_LONGVARCHAR</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='C'">ECLI_CHAR</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='B'">ECLI_INTEGER</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='D'">ECLI_DATE_TIME</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='I'">
  <xsl:variable name="size" select="substring-before(substring-after(@xplainDomain, '(I'), ')')"/>
  <xsl:choose>
    <xsl:when test="$size&lt;5">ECLI_INTEGER_16</xsl:when>
    <xsl:otherwise>ECLI_INTEGER</xsl:otherwise>
  </xsl:choose>
</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='R'">ECLI_DECIMAL</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='T'">ECLI_LONGVARCHAR</xsl:when>
<xsl:when test="substring(@xplainDomain,2,1)='V'">ECLI_LONGVARCHAR</xsl:when>
<xsl:otherwise>
  <xsl:message terminate="yes">Unhandled data type <xsl:value-of select="@xplainDomain"/>.</xsl:message>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="column" mode="invariant">
		its_<xsl:value-of select="@identifier"/> /= Void<xsl:if test="position()!=last()"> and</xsl:if>
</xsl:template>


<xsl:template match="column" mode="attribute-name">
<xsl:text/>"<xsl:value-of select="@xplainName"/>"<xsl:text/>
<xsl:if test="position()!=last()">, </xsl:if>
</xsl:template>


<xsl:template match="column" mode="select-column">
<xsl:text/><xsl:apply-templates select="." mode="string"/><xsl:text/>
<xsl:if test="position()!=last()">, </xsl:if>
</xsl:template>


<xsl:template match="column" mode="cursor">
<xsl:text/>&#09;&#09;&#09;&#09;my_instance_cursor.put (its_<xsl:value-of select="@identifier"/>, <xsl:value-of select="position()"/>)
</xsl:template>


<xsl:template match="column" mode="parameters_string">
<xsl:if test="@xplainDomain='(B)' or @xplainDomain='(D)'">cast(</xsl:if>
<xsl:text/>?<xsl:value-of select="@identifier"/>
<xsl:if test="@xplainDomain='(B)' or @xplainDomain='(D)'"> as <xsl:value-of select="@sqlType"/>)</xsl:if>
</xsl:template>


<xsl:template match="column" mode="delete_parameters_string">
<xsl:apply-templates select="." mode="parameters_string"/>
<xsl:if test="position()!=last()">, </xsl:if>
</xsl:template>


<xsl:template match="column" mode="insert_parameters_string">
<xsl:apply-templates select="." mode="parameters_string"/>
<xsl:if test="position()!=last()">, </xsl:if>
</xsl:template>


<xsl:template match="column" mode="insert_values">
<xsl:text/>its_<xsl:value-of select="@identifier"/><xsl:if test="position()!=last()">, </xsl:if>
</xsl:template>


<xsl:template match="column" mode="update_parameters_string">
<xsl:apply-templates select="." mode="parameters_string"/>
<xsl:if test="position()!=last()">, </xsl:if>
</xsl:template>


<xsl:template match="column" mode="update_values">
<xsl:text/>				my_update_values.put (its_<xsl:value-of select="@identifier"/>, <xsl:value-of select="position()"/>)
</xsl:template>


<!-- to Eiffel functions -->

<!-- class name -->

<xsl:template match="*[@xplainName]" mode="class-name">
  <xsl:text/>MW_<xsl:value-of select="translate(@xplainName, ' -abcdefghijklmnopqrstuvwxyz', '__ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:template>

<!-- make a valid Eiffel string from something -->

<xsl:template match="*[@sqlName]" mode="string">
  <xsl:call-template name="string">
    <xsl:with-param name="s" select="@sqlName"/>
  </xsl:call-template>
</xsl:template>


<!-- utility functions -->

<xsl:template name="string">
  <xsl:param name="s"/>
  <xsl:if test="string-length($s)&gt;0">
    <xsl:variable name="first-char" select="substring($s, 1, 1)"/>
    <xsl:choose>
      <xsl:when test="$first-char='&quot;'">%</xsl:when>
    </xsl:choose>
    <xsl:value-of select="$first-char"/>
    <xsl:call-template name="string">
      <xsl:with-param name="s" select="substring($s, 2)"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>