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
unit ustruct;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Dialogs, Grids,
  StdCtrls, ExtCtrls, Buttons, dbf, dbf_fields,
  Menus, ComCtrls, urstrrings;

type

  { TFormDBSructureDesigner }

  TFormDBSructureDesigner = class(TForm)
    AddButton: TButton;
    BorrowButton: TButton;
    AddIndexButton: TButton;
    ListBox1: TListBox;
    ModifyIndexButton: TButton;
    RemoveIndexButton: TButton;
    ClearIndexesButton: TButton;
    IndexComboBox: TComboBox;
    GroupBox1: TGroupBox;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    BorrowOpenDialog: TOpenDialog;
    PropertiesPageControl: TPageControl;
    PopupMenu1: TPopupMenu;
    MoveTopSpeedButton: TSpeedButton;
    MoveUpSpeedButton: TSpeedButton;
    MoveDownSpeedButton: TSpeedButton;
    MoveBottomSpeedButton: TSpeedButton;
    PackCheckBox: TCheckBox;
    InfoLabel: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    SaveButton: TButton;
    DeleteButton: TButton;
    ChangeButton: TButton;
    FieldDescLabel: TLabel;
    DBFSaveDialog: TSaveDialog;
    StructureStringGrid: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure AddButtonClick(Sender: TObject);
    procedure AddIndexButtonClick(Sender: TObject);
    procedure BorrowButtonClick(Sender: TObject);
    procedure ChangeButtonClick(Sender: TObject);
    procedure ClearIndexesButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure LanguageComboBoxChange(Sender: TObject);
    procedure ModifyIndexButtonClick(Sender: TObject);
    procedure RemoveIndexButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure MoveTopSpeedButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormDBSructureDesigner: TFormDBSructureDesigner;
  var fcnt : Integer; //total fields count
  modify   : Boolean; //if table was modified, true
  isNew    : Boolean; //if new table creation
  
implementation
uses db, umain, useltype, uftype, uindex;
{ TFormDBSructureDesigner }

procedure CheckStructure;
begin
 //TODO: check table sructure and show LOG with errors
 if not modify then Exit;
end;

procedure TFormDBSructureDesigner.FormActivate(Sender: TObject);
begin
 StructureStringGrid.Cells[1, 0] := rsFIELDNAME2;
 StructureStringGrid.Cells[2, 0] := rsTYPE;
 StructureStringGrid.Cells[3, 0] := rsSIZE2;
 StructureStringGrid.Cells[4, 0] := rsDEC;
 StructureStringGrid.Cells[5, 0] := rsMODE;
 StructureStringGrid.Cells[0,0] := '';
 //if changed, StructureStringGrid.Cells[0,0] := '*';
 modify := false;
 //TODO: if open table for editing, set current field count
 fcnt := 0;
end;

procedure TFormDBSructureDesigner.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if StructureStringGrid.Cells[0,0]='*' then begin
   ShowMessage(rsDataNotSaved);
   CanClose:=false;
   StructureStringGrid.Cells[0,0]:='';
  end;
end;

procedure TFormDBSructureDesigner.FormCreate(Sender: TObject);
begin
  Caption:=rsTableSructur;
  FieldDescLabel.Caption:=rsFieldDesript;
  ChangeButton.Caption:=rsEditCurrent;
  DeleteButton.Caption:=rsDeleteCurren;
  SaveButton.Caption:=rsSaveAndClose;
  InfoLabel.Caption:=Format(rsEnterFieldNa, [#13]);
  PackCheckBox.Caption:=rsPackTable;
end;

procedure TFormDBSructureDesigner.AddButtonClick(Sender: TObject);
 var rcnt : Integer;
begin
 appendfield := false;
 //reset form
 FormFT.NameEdit.Clear;
 FormFT.SizeSpinEdit.Enabled := true;
 FormFT.PreSpinEdit.Enabled := true;
 FormFT.ShowModal;
 if not appendfield then exit;
  rcnt := StructureStringGrid.RowCount;
  Inc(rcnt);
  StructureStringGrid.RowCount := rcnt;
  StructureStringGrid.Cells[0,rcnt-1] := IntToStr(rcnt-1);
  StructureStringGrid.Cells[1,rcnt-1] := FormFT.NameEdit.Text;
  StructureStringGrid.Cells[2,rcnt-1] := ft;
  if FormFT.SizeSpinEdit.Enabled
     then StructureStringGrid.Cells[3,rcnt-1] := FormFT.SizeSpinEdit.Text;
  if FormFT.PreSpinEdit.Enabled
     then StructureStringGrid.Cells[4,rcnt-1] := FormFT.PreSpinEdit.Text;
  modify := true;
 StructureStringGrid.Cells[0,0] := '*';
 if not isNew then StructureStringGrid.Cells[5,rcnt-1] := '+';
end;

procedure TFormDBSructureDesigner.AddIndexButtonClick(Sender: TObject);
begin
  //TODO: add new index like in DBD
  mode:=imNewIndex;
  IndexForm.ShowModal;
end;

procedure TFormDBSructureDesigner.BorrowButtonClick(Sender: TObject);
 var borrowdbf : TDbf;
     i         : Integer;
begin
  if BorrowOpenDialog.Execute then begin
   borrowdbf:=Tdbf.Create(self);
   borrowdbf.FilePathFull:=ExtractFilePath(BorrowOpenDialog.FileName);
   borrowdbf.TableName:=ExtractFileName(BorrowOpenDialog.FileName);
   borrowdbf.Active:=true;
   with borrowdbf do begin
    StructureStringGrid.RowCount := dbffielddefs.Count+1;
      for i := 0 to borrowdbf.DbfFieldDefs.Count-1 do begin
        StructureStringGrid.Cells[0,i+1]:= IntToStr(i+1);
        StructureStringGrid.Cells[1,i+1]:= borrowdbf.DbfFieldDefs.Items[i].FieldName;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftString then begin
           StructureStringGrid.Cells[2, i+1]:=rsCharacter;
           StructureStringGrid.Cells[3,i+1]:= IntToStr(borrowdbf.DbfFieldDefs.Items[i].Size);
        end;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType= ftSmallint then begin
           StructureStringGrid.Cells[2, i+1]:=rsNumber;
           StructureStringGrid.Cells[3,i+1]:= IntToStr(borrowdbf.DbfFieldDefs.Items[i].Size);
        end;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftInteger then begin
           StructureStringGrid.Cells[2, i+1]:=rsNumber;
           StructureStringGrid.Cells[3,i+1]:= IntToStr(borrowdbf.DbfFieldDefs.Items[i].Size);
        end;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftWord then begin
           StructureStringGrid.Cells[2, i+1]:=rsNumber;
           StructureStringGrid.Cells[3,i+1]:= IntToStr(borrowdbf.DbfFieldDefs.Items[i].Size);
           end;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftBoolean then StructureStringGrid.Cells[2, i
          +1]:=rsLogical;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftFloat then begin
           StructureStringGrid.Cells[2, i+1]:=rsFloat;
           StructureStringGrid.Cells[3,i+1]:= IntToStr(borrowdbf.DbfFieldDefs.Items[i].Size);
           StructureStringGrid.Cells[4,i+1]:= IntToStr(borrowdbf.DbfFieldDefs.Items[i].Precision);
        end;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftCurrency then StructureStringGrid.Cells[2,i+1]:=rsFloat;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftBCD then StructureStringGrid.Cells[2, i+1]:=rsBinary;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftDate then StructureStringGrid.Cells[2, i+1]:=rsDate;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftDateTime then StructureStringGrid.Cells[2,i+1]:=rsDate;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftBytes then StructureStringGrid.Cells[2, i+1]:=rsBinary;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftAutoInc then StructureStringGrid.Cells[2, i+1]:=rsAutoinc;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftBlob then StructureStringGrid.Cells[2, i+1]:=rsFtBlob;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftMemo then StructureStringGrid.Cells[2, i+1]:=rsFtMemo;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftDBaseOle then StructureStringGrid.Cells[2,i+1]:=rsFtDBaseOle;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftFixedChar then StructureStringGrid.Cells[2, i+1]:=rsFtFixedChar;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftWideString then StructureStringGrid.Cells[2, i+1]:=rsFtWideString;
        if borrowdbf.DbfFieldDefs.Items[i].FieldType=ftLargeint then StructureStringGrid.Cells[2,i+1]:=rsFtLargeint;
      end;//for i
   end;//with
   borrowdbf.Active:=false;
   borrowdbf.Destroy;
   StructureStringGrid.Cells[0,0]:='*';
  end;
end;

procedure TFormDBSructureDesigner.ChangeButtonClick(Sender: TObject);
var r : Integer;
begin
appendfield := false;
 //reset form
 r := StructureStringGrid.Row;
 FormFT.NameEdit.Text := StructureStringGrid.Cells[1,r];
 FormFT.ftComboBox.ItemIndex := FormFT.ftComboBox.Items.IndexOf(StructureStringGrid.Cells[2,r]);
 FormFT.SizeSpinEdit.Enabled := true;
 if (StructureStringGrid.Cells[3,r]<>'') then
 FormFT.SizeSpinEdit.Value := StrToInt(StructureStringGrid.Cells[3,r])
 else FormFT.SizeSpinEdit.Value:=0;
 FormFT.PreSpinEdit.Enabled := true;
 if (StructureStringGrid.Cells[4,r]<>'') then
 FormFT.PreSpinEdit.Value := StrToInt(StructureStringGrid.Cells[4,r])
 else FormFT.PreSpinEdit.Value:=0;
 FormFT.ShowModal;
 if appendfield then begin
  StructureStringGrid.Cells[1,r] := FormFT.NameEdit.Text;
  StructureStringGrid.Cells[2,r] := ft;
  if FormFT.SizeSpinEdit.Enabled
     then StructureStringGrid.Cells[3,r] := FormFT.SizeSpinEdit.Text;
  if FormFT.PreSpinEdit.Enabled
     then StructureStringGrid.Cells[4,r] := FormFT.PreSpinEdit.Text;
  modify := true;
 end; //if
 StructureStringGrid.Cells[0,0] := '*';
 if not isNew then StructureStringGrid.Cells[5,r] := '*';
end;

procedure TFormDBSructureDesigner.ClearIndexesButtonClick(Sender: TObject);
 var i : Integer;
begin
  FormMain.DbfTable.TryExclusive;
  if IndexComboBox.Items.Count<>0 then for i:=IndexComboBox.Items.Count-1 downto 0 do begin
   IndexComboBox.ItemIndex:=i;
   FormMain.DbfTable.DeleteIndex(IndexComboBox.Text);
  end;
  IndexComboBox.Clear;
  FormMain.DbfTable.EndExclusive;
end;

procedure TFormDBSructureDesigner.DeleteButtonClick(Sender: TObject);
var i : Integer;
begin
 if isNew then  if StructureStringGrid.RowCount>1 then begin
   StructureStringGrid.DeleteColRow(false,StructureStringGrid.Row);
   for i := 1 to StructureStringGrid.RowCount-1 do StructureStringGrid.Cells[0,i] := IntToStr(i);
  end else begin
   //if RowCount
  end;
  StructureStringGrid.Cells[5,StructureStringGrid.Row] := '-';
end;

procedure TFormDBSructureDesigner.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#27 then Close;
end;

procedure TFormDBSructureDesigner.LanguageComboBoxChange(Sender: TObject);
begin
  //TODO: set TableLanguage value
 FormMain.DbfTable.Active:=false;
end;

procedure TFormDBSructureDesigner.ModifyIndexButtonClick(Sender: TObject);
begin
  //TODO: modify selected index like dbd
 mode:=imEdit;
end;

procedure TFormDBSructureDesigner.RemoveIndexButtonClick(Sender: TObject);
begin
 if IndexComboBox.Text<>'' then begin
  FormMain.DbfTable.TryExclusive;
  FormMain.DbfTable.DeleteIndex(IndexComboBox.Text);
  IndexComboBox.Items.Delete(IndexComboBox.ItemIndex);
  IndexComboBox.Items.Clear;
  FormMain.DbfTable.GetIndexNames(IndexComboBox.Items)
 end;
end;

procedure TFormDBSructureDesigner.SaveButtonClick(Sender: TObject);
var i     : Integer;
    fldtp : TFieldType; //field type
    NewFieldDefs : TDbfFieldDefs;
begin
//TODO: після збереження закрити файл, відкрити фізично і по зміщенню заголовка записати кодову сторінку
//винести в окрему процедуру
  if not modify then Close;
  if IsNew then with FormMain do begin
   if DBFSaveDialog.Execute then begin
    DbfTable.Active := false;
    DbfTable.TableLevel := useltype.tl;
    DbfTable.FilePathFull := ExtractFilePath(DBFSaveDialog.FileName);
    DbfTable.TableName := ExtractFileName(DBFSaveDialog.FileName);
    //TODO: if need, insert TableLanguage
    for i := 1 to StructureStringGrid.RowCount-1 do begin
     if StructureStringGrid.Cells[2, i]=rsCharacter then fldtp := ftString;
     if StructureStringGrid.Cells[2, i]=rsNumber then fldtp := ftInteger;
     if StructureStringGrid.Cells[2, i]=rsLogical then fldtp := ftBoolean;
     if StructureStringGrid.Cells[2, i]=rsFloat then fldtp := ftFloat;
     if StructureStringGrid.Cells[2, i]=rsDate then fldtp := ftDate;
     if StructureStringGrid.Cells[2, i]=rsBinary then fldtp := ftBlob;
     if StructureStringGrid.Cells[2, i]=rsMemo then fldtp := ftMemo;
     if StructureStringGrid.Cells[2, i]=rsOLE then fldtp := ftDBaseOle;
     case fldtp of
     ftString,ftInteger: DbfTable.FieldDefs.Add(StructureStringGrid.Cells[1,i],fldtp,StrToInt(StructureStringGrid.Cells[3,i]));
     ftFloat: begin
              DbfTable.FieldDefs.Add(StructureStringGrid.Cells[1,i],fldtp,StrToInt(StructureStringGrid.Cells[3,i]));
              DbfTable.FieldDefs[DbfTable.FieldDefs.Count-1].Precision := StrToInt(StructureStringGrid.Cells[4,i]);
              end else DbfTable.FieldDefs.Add(StructureStringGrid.Cells[1,i],fldtp);
     end;//case
    end;//for i
    DbfTable.CreateTable;
    DbfTable.Active := True;
   end;//if with
  end else with FormMain do begin // restructure table
    NewFieldDefs := TDbfFieldDefs.Create(Self);
    NewFieldDefs.Assign(DbfTable.DbfFieldDefs);
    for i := 1 to StructureStringGrid.RowCount-1 do begin
     if StructureStringGrid.Cells[5,i]='*' then begin//modify
      if StructureStringGrid.Cells[2, i]=rsCharacter then fldtp := ftString;
      if StructureStringGrid.Cells[2, i]=rsNumber then fldtp := ftInteger;
      if StructureStringGrid.Cells[2, i]=rsLogical then fldtp := ftBoolean;
      if StructureStringGrid.Cells[2, i]=rsFloat then fldtp := ftFloat;
      if StructureStringGrid.Cells[2, i]=rsDate then fldtp := ftDate;
      if StructureStringGrid.Cells[2, i]=rsBinary then fldtp := ftBlob;
      if StructureStringGrid.Cells[2, i]=rsMemo then fldtp := ftMemo;
      if StructureStringGrid.Cells[2, i]=rsOLE then fldtp := ftDBaseOle;
      NewFieldDefs.Items[i-1].FieldName:= StructureStringGrid.Cells[1,i];
      NewFieldDefs.Items[i-1].FieldType:=fldtp;
      case fldtp of
      ftString,ftInteger: NewFieldDefs.Items[i-1].Size:=StrToInt(StructureStringGrid.Cells[3,i]);
      ftFloat: begin
               NewFieldDefs.Items[i-1].Size:=StrToInt(StructureStringGrid.Cells[3,i]);
               NewFieldDefs.Items[i-1].Precision := StrToInt(StructureStringGrid.Cells[4,i]);
               end;
      end;//case
     end;
    end;//for i
    for i := 1 to StructureStringGrid.RowCount-1 do begin
     if StructureStringGrid.Cells[5,i]='-' then begin//delete
        NewFieldDefs.Delete(i-1);
     end;
    end;//for i
    for i := 1 to StructureStringGrid.RowCount-1 do begin
     if StructureStringGrid.Cells[5,i]='+' then begin//add
      if StructureStringGrid.Cells[2, i]=rsCharacter then fldtp := ftString;
      if StructureStringGrid.Cells[2, i]=rsNumber then fldtp := ftInteger;
      if StructureStringGrid.Cells[2, i]=rsLogical then fldtp := ftBoolean;
      if StructureStringGrid.Cells[2, i]=rsFloat then fldtp := ftFloat;
      if StructureStringGrid.Cells[2, i]=rsDate then fldtp := ftDate;
      if StructureStringGrid.Cells[2, i]=rsBinary then fldtp := ftBlob;
      if StructureStringGrid.Cells[2, i]=rsMemo then fldtp := ftMemo;
      if StructureStringGrid.Cells[2, i]=rsOLE then fldtp := ftDBaseOle;
      case fldtp of
      ftString,ftInteger: NewFieldDefs.Add(StructureStringGrid.Cells[1,i],fldtp,StrToInt(StructureStringGrid.Cells[3,i]));
      ftFloat: begin
               NewFieldDefs.Add(StructureStringGrid.Cells[1,i],fldtp,StrToInt(StructureStringGrid.Cells[3,i]));
               NewFieldDefs.Items[NewFieldDefs.Count-1].Precision := StrToInt(StructureStringGrid.Cells[4,i]);
               end else NewFieldDefs.Add(StructureStringGrid.Cells[1,i],fldtp);
      end;//case
     end;
    end;//for i
    DbfTable.Active:=false;
    DbfTable.RestructureTable(NewFieldDefs,PackCheckBox.Checked);
    DbfTable.Active:=true;
    NewFieldDefs.Free;
   end;
   //clear all panels on main form statusbar
   FormMain.MainStatusBar.Panels.Clear;
   FormMain.DbfDBGrid.Visible := true;
   FormMain.SetStatusBarInfo;
   StructureStringGrid.Cells[0,0]:='';
   Close;
end;

procedure TFormDBSructureDesigner.MoveTopSpeedButtonClick(Sender: TObject);
begin
 case (Sender as TComponent).Tag of
1:if StructureStringGrid.Row>1 then StructureStringGrid.MoveColRow(false,StructureStringGrid.Row,1);
2:if StructureStringGrid.Row>1 then StructureStringGrid.MoveColRow(false,StructureStringGrid.Row,StructureStringGrid.Row-1);
3:if (StructureStringGrid.Row<StructureStringGrid.RowCount) and ((StructureStringGrid.Row+1)<>StructureStringGrid.RowCount) then StructureStringGrid.MoveColRow(false,StructureStringGrid.Row,StructureStringGrid.Row+1);
4:if (StructureStringGrid.Row<StructureStringGrid.RowCount)and ((StructureStringGrid.Row+1)<>StructureStringGrid.RowCount) then StructureStringGrid.MoveColRow(false,StructureStringGrid.Row,StructureStringGrid.RowCount);
 end;
end;

initialization
  {$I ustruct.lrs}

end.

