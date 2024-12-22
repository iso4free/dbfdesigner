{
***************************************************************************
*                                                                         *
*   This file is part of Lazarus DBF Designer                             *
*                                                                         *
*   Copyright (C) 2012 Vadim Vitomsky                                     *
*                                                                         *
*   This source is free software; you can redistribute it and/or modify   *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
*   This code is distributed in the hope that it will be useful, but      *
*   WITHOUT ANY WARRANTY; without even the implied warranty of            *
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *
*   General Public License for more details.                              *
*                                                                         *
*   A copy of the GNU General Public License is available on the World    *
*   Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also      *
*   obtain it by writing to the Free Software Foundation,                 *
*   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.        *
*                                                                         *
***************************************************************************}
unit useltype;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, StdCtrls, Buttons, urstrrings;

type

  { TFormSelectDbType }

  TFormSelectDbType = class(TForm)
    CancelBitBtn: TBitBtn;
    CreateBitBtn: TBitBtn;
    cbTableTypeComboBox: TComboBox;
    TableTypeLabel: TLabel;
    procedure CreateBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
  end; 

var
  FormSelectDbType: TFormSelectDbType;
  tl              : Integer; //TableLevel property for new table
implementation

uses ustruct;
{ TFormSelectDbType }

procedure TFormSelectDbType.CreateBitBtnClick(Sender: TObject);
begin
  tl := 4;// for default LableLevel
  case cbTableTypeComboBox.ItemIndex of
0 : tl := 3;
1 : tl := 4;
2 : tl := 7;
3 : tl := 25;
  end;//case
  isNew := true;
  FormDBSructureDesigner.ShowModal;
end;

procedure TFormSelectDbType.FormCreate(Sender: TObject);
begin
  Caption:=rsCreateTable;
  TableTypeLabel.Caption:=rsTableType;
  CreateBitBtn.Caption:=rsCreate;
  CancelBitBtn.Caption:=rsCancel;
end;

initialization
  {$I useltype.lrs}

end.

