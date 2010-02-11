{ Created: 2000-01-12 by Berend (c) NederWare

Low level middleware layer to apply changes to the current row in a
recordset.

}


unit mw_ado;

interface

uses
  SysUtils,
  ADOInt;


type
  EmwException = class(Exception);

  TmwADO = class
  protected { internal state }
    connection: Connection;
    spDelete,
    spInsert,
    spUpdate: Command;
  protected { override these in descendents, they do real action }
    procedure DoDelete(rs: Recordset); virtual; abstract;
    procedure DoDeleteId(id: integer; const ts: OleVariant); virtual; abstract;

    procedure DoExecuteSP(sp: Command); virtual;
      { default execution of a procedure }

    function  DoCreateEmptyRecordset: Recordset; virtual; abstract;

    function  DoInsert(rs: Recordset): integer; virtual; abstract;
    procedure DoUpdate(rs: Recordset); virtual; abstract;

  protected { actual stored procedure call }
    procedure ExecuteSP(sp: Command);

  public { creation }
    constructor Create(aconnection: Connection);

  public { external functions }

    RecordsAffected: OleVariant;
      { valid after calling one of the external functions }

    procedure Apply(rs: Recordset);
      { if current row has changed, that row is deleted/inserted/updates,
        whatever applies. }
    function  CreateEmptyRecordset: Recordset;
      { create a recordset with all fields }
    procedure Delete(rs: Recordset);
      { delete current row if it is deleted. }
    procedure DeleteId(id: integer; const ts: OleVariant);
      { delete row with this pk }
    function  Insert(rs: Recordset): integer;
      { insert current row if it is a new row }
    procedure Update(rs: Recordset);
      { update current row if it has been modified }

  { invariant: connection /= Void }
  end;

implementation


{ TmwADO }

constructor TmwADO.Create(aconnection: Connection);
begin
{require}
  Assert(Assigned(aconnection), 'require: aconnection is valid.');

  inherited Create;
  connection := aconnection;
end;


procedure TmwADO.Apply(rs: Recordset);
begin
{require}
  Assert(not (rs.EOF or rs.BOF), 'require: has current row.');

  case rs.Status of
    adRecNew: Insert(rs);
    adRecModified: Update(rs);
    adRecDeleted: Delete(rs);
  else
    RecordsAffected := 0;
  end;
end;


function TmwADO.CreateEmptyRecordset: Recordset;
begin
  Result := DoCreateEmptyRecordset;

{ensure}
  Assert(Result.RecordCount = 0, 'ensure: have no rows.');
end;


procedure TmwADO.Delete(rs: Recordset);
begin
{require}
  Assert(not (rs.EOF or rs.BOF), 'require: has current row.');

  RecordsAffected := 0;
  DoDelete(rs);
end;


procedure TmwADO.DeleteId(id: integer; const ts: OleVariant);
begin
{require}
  Assert(id > 0, 'require: valid primary key.');

  RecordsAffected := 0;
  DoDeleteId(id, ts);
end;


procedure TmwADO.DoExecuteSP(sp: Command);
begin
{require}
  Assert(connection.State = adStateOpen, 'require: connection is open.');

  if not Assigned(sp.Get_ActiveConnection) then
    sp.Set_ActiveConnection(connection);
  sp.Execute(RecordsAffected, EmptyParam, adCmdStoredProc + adExecuteNoRecords);
end;


procedure TmwADO.ExecuteSP(sp: Command);
begin
{require}
  Assert(Assigned(sp), 'require: valid sp.');

  DoExecuteSP(sp);
  if RecordsAffected <> 1 then
    raise EmwException.create('Expected one record to be affected.');
end;


function TmwADO.Insert(rs: Recordset): integer;
begin
{require}
  Assert(not (rs.EOF or rs.BOF), 'require: has current row.');

  RecordsAffected := 0;
  Result := DoInsert(rs);
end;


procedure TmwADO.Update(rs: Recordset);
begin
{require}
  Assert(not (rs.EOF or rs.BOF), 'require: has current row.');

  RecordsAffected := 0;
  DoUpdate(rs);
end;


end.
