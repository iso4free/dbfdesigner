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
unit uftype;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, Dialogs, StdCtrls,
  Spin, Buttons, urstrrings;

type

  { TFormFT }

  TFormFT = class(TForm)
    CancelBitBtn: TBitBtn;
    CreateBitBtn: TBitBtn;
    NameEdit: TEdit;
    ftComboBox: TComboBox;
    FieldTypeLabel: TLabel;
    SizeLabel: TLabel;
    PrecisionLabel: TLabel;
    FieldNameLabel: TLabel;
    SizeSpinEdit: TSpinEdit;
    PreSpinEdit: TSpinEdit;
    procedure CancelBitBtnClick(Sender: TObject);
    procedure CreateBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure ftComboBoxKeyPress(Sender: TObject; var Key: char);
    procedure NameEditKeyPress(Sender: TObject; var Key: char);
    procedure PreSpinEditKeyPress(Sender: TObject; var Key: char);
    procedure SizeSpinEditKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormFT: TFormFT;
  appendfield : Boolean;
  ft          : String;
implementation

{ TFormFT }

procedure TFormFT.CreateBitBtnClick(Sender: TObject);
begin
 ft := ftComboBox.Text;
 if NameEdit.Text='' then begin
  ShowMessage(rsNeedFieldNam);
  NameEdit.SetFocus; //is need there?
  Exit;
 end;
 NameEdit.SetFocus; //is need there?
 appendfield := true;
 Close;
end;

procedure TFormFT.FormCreate(Sender: TObject);
begin
  Caption:=rsFieldType;
  FieldNameLabel.Caption:=rsFieldName;
  FieldTypeLabel.Caption:=rsFieldType;
  SizeLabel.Caption:=rsSize;
  PrecisionLabel.Caption:=rsPrecision;
  CreateBitBtn.Caption:=rsCreate;
  CancelBitBtn.Caption:=rsCancel;
end;

procedure TFormFT.CancelBitBtnClick(Sender: TObject);
begin
  appendfield:=false;
  Close;
end;

procedure TFormFT.FormKeyPress(Sender: TObject; var Key: char);
begin
 if Key=#27 then Close;//on Esc
end;

procedure TFormFT.ftComboBoxKeyPress(Sender: TObject; var Key: char);
begin
 if Key=#13 then SizeSpinEdit.SetFocus;
end;

procedure TFormFT.NameEditKeyPress(Sender: TObject; var Key: char);
begin
  case Key of
  #8:;//Backspace
  #13: ftComboBox.SetFocus;//enter
  #48..#57:if NameEdit.Text='' then Key := #0;//0..9 if not first char
  #65..#90:;//A..Z
  #95:; //_
  #97..#122:;//a..z
  else Key := #0;
  end;//case
end;

procedure TFormFT.PreSpinEditKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then CreateBitBtn.SetFocus;
end;

procedure TFormFT.SizeSpinEditKeyPress(Sender: TObject; var Key: char);
begin
 if Key=#13 then PreSpinEdit.SetFocus;
end;

initialization
  {$I uftype.lrs}

end.

