<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- Emit middleware code for Delphi + ADO given an Xplain type -->


<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml">

<xsl:output
  method="text"
  version="1.0"
  encoding="ISO-8859-1"/>


<xsl:param name="table"/>


<xsl:template match="/sql">
<xsl:if test="not($table)"><xsl:message terminate="yes">Parameter table is required.</xsl:message></xsl:if>
<xsl:if test="not(/sql/table[@xplainName=$table])"><xsl:message terminate="yes">Parameter table does not refer to an existing table.</xsl:message></xsl:if>
<xsl:apply-templates select="/sql/table[@xplainName=$table]"/>
</xsl:template>


<xsl:template match="table">
<xsl:variable name="class-name">
  <xsl:apply-templates select="." mode="delphi-class"/>
</xsl:variable>
<xsl:text/>{ Low level Delphi middleware layer for type <xsl:value-of select="@xplainName"/>. }

unit <xsl:apply-templates select="." mode="unit-name"/>;

interface

uses
  ADOInt,
  mw_custom;

type
  <xsl:value-of select="$class-name"/> = class(TmwCustom)
  protected
    function  DoCreateEmptyRecordset: Recordset; override;
    procedure DoDelete(rs: Recordset); override;
    procedure DoDeleteId(id: integer; const ts: OleVariant); override;
    function  DoInsert(rs: Recordset): integer; override;
    procedure DoUpdate(rs: Recordset); override;
  end;

implementation

{$IFNDEF VER130}
uses
  Variants;
{$ENDIF}

{ <xsl:value-of select="$class-name"/> }

function <xsl:value-of select="$class-name"/>.DoCreateEmptyRecordset: Recordset;
begin
  Result := CoRecordset.Create;
<xsl:apply-templates select="column" mode="empty-recordset"/>
<xsl:text/>  Result.Open(EmptyParam, EmptyParam, adOpenStatic, adLockBatchOptimistic, Integer(adCmdUnspecified));
end;


procedure <xsl:value-of select="$class-name"/>.DoDelete(rs: Recordset);
begin
  DoDeleteId(rs.Fields['<xsl:value-of select="column/@sqlName"/>'].OriginalValue, Null);
end;


procedure <xsl:value-of select="$class-name"/>.DoDeleteId(id: integer; const ts: OleVariant);
var
  Param: Parameter;
begin
  if not Assigned(spDelete) then
  begin
    spDelete:= CoCommand.Create;
    spDelete.Set_CommandText('<xsl:value-of select="@spDelete"/>');
    Param := spDelete.CreateParameter('<xsl:value-of select="column/@sqlParamName"/>', <xsl:apply-templates select="column[1]/@xplainDomain" mode="ADO-type"/>, adParamInput, 0, id);
    spDelete.Parameters.Append(Param);
  end
  else begin
    spDelete.Parameters.Item['<xsl:value-of select="column/@sqlParamName"/>'].Value := id;
  end;
  ExecuteSP(spDelete);
end;


function <xsl:value-of select="$class-name"/>.DoInsert(rs: Recordset): integer;
var
  Param: Parameter;
begin
  if not Assigned(spInsert) then
  begin
    spInsert := CoCommand.Create;
    spInsert.Set_CommandText('<xsl:value-of select="@spInsert"/>');
<xsl:apply-templates select="column[position()>1]" mode="create-param">
  <xsl:with-param name="sp-name" select="'spInsert'"/>
</xsl:apply-templates>
<xsl:text/>    Param := spInsert.CreateParameter('<xsl:value-of select="column[1]/@sqlParamName"/>', <xsl:apply-templates select="column[1]/@xplainDomain" mode="ADO-type"/>, adParamOutput, <xsl:apply-templates select="column[1]/@xplainDomain" mode="ADO-size"/>, Null);
    spInsert.Parameters.Append(Param);
  end
  else begin
<xsl:apply-templates select="column[position()>1]" mode="set-param">
  <xsl:with-param name="sp-name" select="'spInsert'"/>
</xsl:apply-templates>
<xsl:text/>  end;
  ExecuteSP(spInsert);
  Result := spInsert.Parameters.Item['<xsl:value-of select="column[1]/@sqlParamName"/>'].Value;
end;


procedure <xsl:value-of select="$class-name"/>.DoUpdate(rs: Recordset);
var
  Param: Parameter;
begin
  if not Assigned(spUpdate) then
  begin
    spUpdate := CoCommand.Create;
    spUpdate.Set_CommandText('<xsl:value-of select="@spUpdate"/>');
<xsl:apply-templates select="column" mode="create-param">
  <xsl:with-param name="sp-name" select="'spUpdate'"/>
</xsl:apply-templates>
<xsl:text/>  end
  else begin
<xsl:apply-templates select="column" mode="set-param">
  <xsl:with-param name="sp-name" select="'spUpdate'"/>
</xsl:apply-templates>
<xsl:text/>  end;
  ExecuteSP(spUpdate);
end;


end.
</xsl:template>


<!-- Parts -->

<xsl:template match="column" mode="empty-recordset">
<xsl:text/>  Result.Fields.Append('<xsl:value-of select="@sqlName"/>', <xsl:apply-templates select="@xplainDomain" mode="ADO-type"/>, <xsl:apply-templates select="@xplainDomain" mode="ADO-size"/>, adFldUpdatable + adFldIsNullable + adFldMayBeNull);
<xsl:if test="substring(@xplainDomain, 2, 1)='R'">
<xsl:variable name="part1" select="substring(@xplainDomain, 3)"/>
<xsl:variable name="part-num" select="substring-before($part1, ')')"/>
<xsl:text/>  Result.Fields['<xsl:value-of select="@sqlParamName"/>'].Set_Precision(<xsl:value-of select="substring-before($part-num, ',')"/> + <xsl:value-of select="substring-after($part-num, ',')"/>);
  Result.Fields['<xsl:value-of select="@sqlParamName"/>'].Set_NumericScale(<xsl:value-of select="substring-after($part-num, ',')"/>);
</xsl:if>
</xsl:template>


<xsl:template match="column" mode="create-param">
<xsl:param name="sp-name"/>
<xsl:variable name="domain" select="substring(@xplainDomain, 2, 1)"/>
<xsl:text/>    Param := <xsl:value-of select="$sp-name"/>.CreateParameter('<xsl:value-of select="@sqlParamName"/>', <xsl:apply-templates select="@xplainDomain" mode="ADO-type"/>, adParamInput, <xsl:apply-templates select="@xplainDomain" mode="ADO-size"/>, <xsl:if test="$domain='A' or $domain='C' or $domain='V'">VarToStr(</xsl:if>rs.Fields['<xsl:value-of select="@sqlName"/>'].Value<xsl:if test="$domain='A' or $domain='C' or $domain='V'">)</xsl:if>);
    <xsl:value-of select="$sp-name"/>.Parameters.Append(Param);
<xsl:if test="$domain='R'">
<xsl:variable name="part1" select="substring(@xplainDomain, 3)"/>
<xsl:variable name="part-num" select="substring-before($part1, ')')"/>
<xsl:text/>    Param.Precision := <xsl:value-of select="substring-before($part-num, ',')"/> + <xsl:value-of select="substring-after($part-num, ',')"/>;
    Param.NumericScale := <xsl:value-of select="substring-after($part-num, ',')"/>;
</xsl:if>
</xsl:template>


<xsl:template match="column" mode="set-param">
<xsl:param name="sp-name"/>
<xsl:variable name="domain" select="substring(@xplainDomain, 2, 1)"/>
<xsl:text>    </xsl:text><xsl:value-of select="$sp-name"/>.Parameters.Item['<xsl:value-of select="@sqlParamName"/>'].Value := <xsl:if test="$domain='A' or $domain='C' or $domain='V'">VarToStr(</xsl:if>rs.Fields['<xsl:value-of select="@sqlName"/>'].Value<xsl:if test="$domain='A' or $domain='C' or $domain='V'">)</xsl:if>;
</xsl:template>


<!-- ADO types for Xplain types -->

<xsl:template match="attribute::xplainDomain" mode="ADO-type">
<xsl:variable name="domain" select="substring(current(), 2, 1)"/>
<xsl:choose>
<xsl:when test="$domain='A'">adVarChar</xsl:when>
<xsl:when test="$domain='B'">adBoolean</xsl:when>
<xsl:when test="$domain='C'">adChar</xsl:when>
<xsl:when test="$domain='D'">adDBTimestamp</xsl:when>
<xsl:when test="$domain='F'">adDouble</xsl:when>
<xsl:when test="$domain='I'">adInteger</xsl:when>
<xsl:when test="$domain='M'">adCurrency</xsl:when>
<xsl:when test="$domain='P'">adLongVarBinary</xsl:when>
<xsl:when test="$domain='R'">adNumeric</xsl:when>
<xsl:when test="$domain='T'">adLongVarChar</xsl:when>
<xsl:when test="$domain='V'">adVarChar</xsl:when>
<xsl:otherwise>unhandled Xplain type <xsl:value-of select="$domain"/>.</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="attribute::xplainDomain" mode="ADO-size">
<xsl:variable name="domain" select="substring(current(), 2, 1)"/>
<xsl:choose>
<xsl:when test="$domain='A'"><xsl:value-of select="substring(current(), 3, 2)"/></xsl:when>
<xsl:when test="$domain='V'"><xsl:value-of select="substring(current(), 3, 2)"/></xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- Delphi names -->

<xsl:template match="table" mode="unit-name">
<xsl:text/>mw_<xsl:apply-templates select="." mode="delphi-identifier"/>
</xsl:template>


<xsl:template match="table" mode="delphi-class">
<xsl:text/>Tmw<xsl:apply-templates select="." mode="delphi-identifier"/>
</xsl:template>


<xsl:template match="table" mode="delphi-identifier">
<xsl:value-of select="translate(@xplainName, ' ', '_')"/>
</xsl:template>

</xsl:stylesheet>
