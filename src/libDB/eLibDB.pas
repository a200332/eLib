(* GPL > 3.0
Copyright (C) 1996-2019 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
unit eLibDB;

{$IFDEF FPC}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  Controls, DB;

type
  DBUtil = class
    class procedure SetEdit(ds: TDataSource); static;
    class procedure _SetEdit(ds: TDataSet); static;
    class function  CheckAbort(ds: TDataSource): boolean; static;
    class function  GetFldIndex(tb: TDataSet; const Fld: string): integer; static;
    class function  DataTypeToStr(FT: TFieldType): string; static;
    class function  StrToDataType(S: string): TFieldType; static;
  end;

implementation

uses
  SysUtils, Dialogs;

resourcestring
  msgCheckAbort = 'Sei sicuro di voler abbandonare le modifiche?';

class procedure DBUtil.SetEdit(ds: TDataSource);
begin
  if not (ds.State in [dsEdit, dsInsert]) then begin
    ds.DataSet.Edit;
  end;
end;

class procedure DBUtil._SetEdit(ds: TDataSet);
begin
  if not (ds.State in [dsEdit, dsInsert]) then begin
    ds.Edit;
  end;
end;

class function DBUtil.CheckAbort(ds: TDataSource): boolean;
begin
  Result:= true;
  if not (ds.State in [dsEdit, dsInsert]) then exit;
  if MessageDlg(msgCheckAbort, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    ds.DataSet.Cancel;
    exit;
  end;
  Result:= false;
end;

class function DBUtil.GetFldIndex(tb: TDataSet; const Fld: string): integer;
var
  F: TField;
begin
  with tb do begin
    F:= FindField(Fld);
    if F = nil then Result:= -1
    else Result:= F.Index;
  end;
end;

class function DBUtil.DataTypeToStr(FT: TFieldType): string;
begin
  case FT of
    ftBCD     : Result:= 'BCD';
    ftBlob    : Result:= 'Blob';
    ftBoolean : Result:= 'Boolean';
    ftBytes   : Result:= 'Bytes';
    ftCurrency: Result:= 'Currency';
    ftDate    : Result:= 'Date';
    ftDateTime: Result:= 'DateTime';
    ftFloat   : Result:= 'Float';
    ftGraphic : Result:= 'Graphic';
    ftInteger : Result:= 'Integer';
    ftMemo    : Result:= 'Memo';
    ftSmallInt: Result:= 'Smallint';
    ftString  : Result:= 'String';
    ftTime    : Result:= 'Time';
    ftVarBytes: Result:= 'VarBytes';
    ftWord    : Result:= 'Word';
  else Result:= 'Unknown';
  end;
end;

class function DBUtil.StrToDataType(S: string): TFieldType;
begin
  S:= lowercase(S);
  Result:= ftUnknown;
  if S='bcd'      then Result:= ftBCD;
  if S='blob'     then Result:= ftBlob;
  if S='boolean'  then Result:= ftBoolean;
  if S='bytes'    then Result:= ftBytes;
  if S='currency' then Result:= ftCurrency;
  if S='date'     then Result:= ftDate;
  if S='datetime' then Result:= ftDateTime;
  if S='float'    then Result:= ftFloat;
  if S='graphic'  then Result:= ftGraphic;
  if S='integer'  then Result:= ftInteger;
  if S='memo'     then Result:= ftMemo;
  if S='smallint' then Result:= ftSmallInt;
  if S='string'   then Result:= ftString;
  if S='time'     then Result:= ftTime;
  if S='varbytes' then Result:= ftVarBytes;
  if S='word'     then Result:= ftWord;
end;

end.
