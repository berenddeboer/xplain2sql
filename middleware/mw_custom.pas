{ Created: 2000-01-12 by Berend  (c) NederWare

Low level middleware layer to apply changes to the current row in a
recordset. Implements TmwCustom, the customization level. All final code
should inherit from this one to make customization easy.

$Revision: 1.1 $
$Date: Wed, 26 Jul 2000 12:05:36 +0200 $

}

unit mw_custom;

interface

uses
  mw_ado;


type
  TmwCustom = class(TmwADO)
  end;



implementation

end.
