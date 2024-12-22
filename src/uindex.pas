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

unit uindex;

{$mode objfpc}{$H+}


interface

uses
  LResources, Forms,
  ExtCtrls, StdCtrls, urstrrings;

type

  TIndexModes = (imNewIndex,imEdit);

  { TIndexForm }

  TIndexForm = class(TForm)
    cbUnique: TCheckBox;
    cbMaintained: TCheckBox;
    cbDescending: TCheckBox;
    CheckGroup1: TCheckGroup;
    Label1: TLabel;
    FieldsListBox: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  mode     : TIndexModes;
  IndexForm: TIndexForm;

implementation
  uses umain;
{ TIndexForm }

procedure TIndexForm.FormActivate(Sender: TObject);
 var i : Integer;
begin
 for i:=0 to FormMain.DbfTable.FieldCount-1 do FieldsListBox.Items.Add(FormMain.DbfTable.Fields[i].FieldName);
end;

procedure TIndexForm.FormCreate(Sender: TObject);
begin
  Caption:=rsIndexes;
  mode:=imNewIndex;
end;

initialization
  {$I uindex.lrs}

end.

