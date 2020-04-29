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
unit umain;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, FileUtil, SynHighlighterPas, SynMemo, SynHighlighterSQL,
  LResources, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls, ExtCtrls,
  ActnList, DBGrids, Buttons, db, dbf, dbf_fields, StdCtrls, Grids,
  DbCtrls, inifiles, Classes, urstrrings, LConvEncoding, Translations, DefaultTranslator,
  GetText, LazUTF8;

type

  { TFormMain }

  TFormMain = class(TForm)
    actFileOpen: TAction;
    actFileExit: TAction;
    actCreateDBF: TAction;
    acrRestructureDBF: TAction;
    actEditData: TAction;
    actCSVExport: TAction;
    actCloseDbf: TAction;
    Action1: TAction;
    Action2: TAction;
    actSearch: TAction;
    actSQLExport: TAction;
    actPasExport: TAction;
    actMemoAssign: TAction;
    ImageList1: TImageList;
    MenuItem14: TMenuItem;
    ShowDeletedCheckBox: TCheckBox;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    ShowSourceCheckBox: TCheckBox;
    DbfDBGrid: TDBGrid;
    DbfLocaleComboBox: TComboBox;
    DBMemo1: TDBMemo;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    SearchLabel: TLabel;
    SearchEdit: TEdit;
    LocaleLabel: TLabel;
    DbGridPopupMenu: TPopupMenu;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    SearchPanel: TPanel;
    ExportDialog: TSaveDialog;
    SearchSpeedButton: TSpeedButton;
    sbFilterButton: TSpeedButton;
    CloseSpeedButton: TSpeedButton;
    SQLMenuExport: TMenuItem;
    PascalMenuExport: TMenuItem;
    sbCreateBitBtn: TSpeedButton;
    DbfTable: TDbf;
    DbfDatasource: TDatasource;
    MainActionList: TActionList;
    MainMenu1: TMainMenu;
    FileMenuItem: TMenuItem;
    FileOpenMenuItem: TMenuItem;
    FileCreateMenuItem: TMenuItem;
    FileExportMenuItem: TMenuItem;
    FileExitMenuItem: TMenuItem;
    EditMenuItem: TMenuItem;
    EditFieldListMenuItem: TMenuItem;
    HelpMenuItem: TMenuItem;
    HelpManualMenuItem: TMenuItem;
    HelpAboutMenuItem: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    EditSettingsMenuItem: TMenuItem;
    EditDataEditMenuItem: TMenuItem;
    sbOpenSpeedButton: TSpeedButton;
    sbEditDataSpeedButton: TSpeedButton;
    SynFreePascalSyn1: TSynFreePascalSyn;
    SynMemo1: TSynMemo;
    SynPasSyn1: TSynPasSyn;
    SynSQLSyn1: TSynSQLSyn;
    TableOpenDialog: TOpenDialog;
    MainStatusBar: TStatusBar;
    ToolPanel: TPanel;
    ToolsJoinMenuItem: TMenuItem;
    ToolsSortMenuItem: TMenuItem;
    ToolsCompareMenuItem: TMenuItem;
    ToolsEmptyMenuItem: TMenuItem;
    ToolsPackMenuItem: TMenuItem;
    ToolsRecodeMenuItem: TMenuItem;
    ToolsMenuItem: TMenuItem;
    procedure acrRestructureDBFExecute(Sender: TObject);
    procedure actCloseDbfExecute(Sender: TObject);
    procedure actCreateDBFExecute(Sender: TObject);
    procedure actCSVExportExecute(Sender: TObject);
    procedure actEditDataExecute(Sender: TObject);
    procedure actFileExitExecute(Sender: TObject);
    procedure actFileOpenExecute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure actPascalMenuExportClick(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure actSQLExportExecute(Sender: TObject);
    procedure DbfTableAfterClose(DataSet: TDataSet);
    procedure DbfTableAfterOpen(DataSet: TDataSet);
    procedure DbfTableIndexMissing(var DeleteLink: Boolean);
    procedure MenuItem13Click(Sender: TObject);
    procedure ShowDeletedCheckBoxClick(Sender: TObject);
    procedure DbfDBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure ShowSourceCheckBoxClick(Sender: TObject);
    procedure DbfDBGridColEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure HelpAboutMenuItemClick(Sender: TObject);
    procedure LocaleComboBoxExit(Sender: TObject);
    procedure SearchEditChange(Sender: TObject);
    procedure SearchEditKeyPress(Sender: TObject; var Key: char);
    procedure ToolsEmptyMenuItemClick(Sender: TObject);
    procedure ToolsPackMenuItemClick(Sender: TObject);
    procedure DbFieldGetText(Sender : TField; var aText : String; DisplayText : Boolean);
    procedure DbFieldSetText(Sender : TField; const aText : String);
    procedure DbAfterOpen(Dataset : TDataset);
    procedure SetStatusBarInfo;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormMain: TFormMain;
  settingsini : TINIFile;
  langfile    : TINIFile;
  defaultlang : TINIFile;
  settingspath: String;

implementation

uses useltype, ustruct, uabout;

var DbfSearchBookmark: TBookmark;

procedure TFormMain.SetStatusBarInfo;
var tl : String;
begin
 //Adding information about opened table in main statusbar
 Caption := rsDBDesigner+DbfTable.TableName;
 MainStatusBar.Panels.Add;
 MainStatusBar.Panels[0].Width := 200;
 MainStatusBar.Panels[0].Text := rsTable+DbfTable.TableName;
 MainStatusBar.Panels.Add;
 MainStatusBar.Panels[1].Width := 200;
 case DbfTable.TableLevel of
 3: tl := rsDBaseIII;
 4: tl := rsDBaseIV;
 7: tl := rsVisualDBaseV;
 25: tl := rsFoxPro
 else tl := rsUnknown; //is this really needed?
 end;//case
     MainStatusBar.Panels[1].Text := rsTableLevel+IntToStr(DbfTable.TableLevel)+
       ' ('+tl+')';
     MainStatusBar.Panels.Add;
     MainStatusBar.Panels[2].Width := 150;
     MainStatusBar.Panels[2].Text := rsRecords+IntToStr(DbfTable.RecordCount);
     MainStatusBar.Panels.Add;
     MainStatusBar.Panels[3].Width := 160;
     MainStatusBar.Panels[3].Text := rsCodepage+IntToStr(DbfTable.CodePage);
     MainStatusBar.Panels.Add;
     MainStatusBar.Panels[4].Width := 120;
     MainStatusBar.Panels[4].Text := rsWaiting;
     case DbfTable.CodePage of
  866: DbfLocaleComboBox.ItemIndex:=0;
  1251,1252: DbfLocaleComboBox.ItemIndex:=1;
     else DbfLocaleComboBox.ItemIndex:=2;
     end;//case
 if DbfTable.TableLevel=3 then begin
  DbfLocaleComboBox.ItemIndex:=0; //for DBase III+ cp866
  MainStatusBar.Panels[3].Text := rsCodepage866;
 end;
end;

{ TFormMain }

procedure TFormMain.FormKeyPress(Sender: TObject; var Key: char);
begin
  case Key of
#27:if not SearchPanel.Visible then actFileExitExecute(nil);
#6:actSearchExecute(nil);
  end;
end;

procedure TFormMain.HelpAboutMenuItemClick(Sender: TObject);
begin
 AboutForm.ShowModal;
end;

procedure TFormMain.LocaleComboBoxExit(Sender: TObject);
begin
 DbfDBGrid.Refresh;
end;

procedure TFormMain.SearchEditChange(Sender: TObject);
begin
 case DbfLocaleComboBox.ItemIndex of
     0:DbfTable.Locate(DbfDBGrid.SelectedColumn.FieldName,UTF8ToConsole(SearchEdit.Text),[loCaseInsensitive,loPartialKey]);
     1:DbfTable.Locate(DbfDBGrid.SelectedColumn.FieldName,Utf8ToAnsi(SearchEdit.Text),[loCaseInsensitive,loPartialKey]);
     2:DbfTable.Locate(DbfDBGrid.SelectedColumn.FieldName,SearchEdit.Text,[loCaseInsensitive,loPartialKey]);
 end;
end;

procedure TFormMain.SearchEditKeyPress(Sender: TObject; var Key: char);
begin
  if SearchEdit.Text='' then exit;
  case Key of
#13:Begin
 case DbfLocaleComboBox.ItemIndex of
 0:DbfTable.Locate(DbfDBGrid.SelectedColumn.FieldName,UTF8ToConsole(SearchEdit.Text),[loCaseInsensitive,loPartialKey]);
 1:DbfTable.Locate(DbfDBGrid.SelectedColumn.FieldName,Utf8ToAnsi(SearchEdit.Text),[loCaseInsensitive,loPartialKey]);
 2:DbfTable.Locate(DbfDBGrid.SelectedColumn.FieldName,SearchEdit.Text,[loCaseInsensitive,loPartialKey]);
 end;
     DbfTable.FreeBookmark(DbfSearchBookmark);
     SearchPanel.Visible:=false;
   end;
#27: begin
      DbfTable.GotoBookmark(DbfSearchBookmark);
      DbfTable.FreeBookmark(DbfSearchBookmark);
      SearchEdit.Clear;
      SearchPanel.Visible:=false;
    end else begin
     case DbfLocaleComboBox.ItemIndex of
     0:DbfTable.Locate(DbfDBGrid.SelectedColumn.FieldName,UTF8ToConsole(SearchEdit.Text),[loCaseInsensitive,loPartialKey]);
     1:DbfTable.Locate(DbfDBGrid.SelectedColumn.FieldName,Utf8ToAnsi(SearchEdit.Text),[loCaseInsensitive,loPartialKey]);
     2:DbfTable.Locate(DbfDBGrid.SelectedColumn.FieldName,SearchEdit.Text,[loCaseInsensitive,loPartialKey]);
     end;
    end;
  end;
end;

procedure TFormMain.actPascalMenuExportClick(Sender: TObject);
var i : Integer;
    _rcnt : Integer;
    paslist : TStringList;
begin
 ExportDialog.Filter:=rsPascalInclud;
 ExportDialog.DefaultExt:='.inc';
 ExportDialog.InitialDir:='';
 ExportDialog.FileName:=LowerCase(Copy(DbfTable.TableName,1,Pos('.',DbfTable.TableName)-1));
 if not ExportDialog.Execute then exit;
 paslist:=TStringList.Create;
 //export as Pascal source
 SynMemo1.Visible:=true;
 SynMemo1.Clear;
 SynMemo1.Lines.Add('procedure CreateDbf(var _fname: String);');
 SynMemo1.Lines.Add('var Dbf1 : Tdbf;');
 SynMemo1.Lines.Add('Begin');
 SynMemo1.Lines.Add(' Dbf1:=Tdbf.Create(nil);');
 SynMemo1.Lines.Add(' Dbf1.FilePathFull:='''';');
 SynMemo1.Lines.Add(' Dbf1.Tablename:=_fname;');
 SynMemo1.Lines.Add(' Dbf1.TableLevel:='+IntToStr(DbfTable.TableLevel)+';');
 SynMemo1.Lines.Add(' Dbf1.LanguageId:='+IntToStr(DbfTable.LanguageID)+';//test this');
 for i := 0 to DbfTable.FieldCount-1 do begin
  case DbfTable.DbfFieldDefs.Items[i].FieldType of
ftString:SynMemo1.Lines.Add(' Dbf1.FieldDefs.Add('''+DbfTable.DbfFieldDefs.Items[i].FieldName+''',ftString,'+IntToStr(DbfTable.DbfFieldDefs.Items[i].Size)+');');
ftSmallint:SynMemo1.Lines.Add(' Dbf1.FieldDefs.Add('''+DbfTable.DbfFieldDefs.Items[i].FieldName+''',ftSmallint,'+IntToStr(DbfTable.DbfFieldDefs.Items[i].Size)+');');
ftAutoInc:SynMemo1.Lines.Add(' Dbf1.FieldDefs.Add('''+DbfTable.DbfFieldDefs.Items[i].FieldName+''',ftAutoInc);');
ftInteger:SynMemo1.Lines.Add(' Dbf1.FieldDefs.Add('''+DbfTable.DbfFieldDefs.Items[i].FieldName+''',ftInteger,'+IntToStr(DbfTable.DbfFieldDefs.Items[i].Size)+');');
ftBoolean:SynMemo1.Lines.Add(' Dbf1.FieldDefs.Add('''+DbfTable.DbfFieldDefs.Items[i].FieldName+''',ftBoolean);');
ftDate:SynMemo1.Lines.Add(' Dbf1.FieldDefs.Add('''+DbfTable.DbfFieldDefs.Items[i].FieldName+''',ftDate);');
ftFloat:SynMemo1.Lines.Add(' Dbf1.FieldDefs.Add('''+DbfTable.DbfFieldDefs.Items[i].FieldName+''',ftFloat,'+IntToStr(DbfTable.DbfFieldDefs.Items[i].Size)+','+IntToStr(DbfTable.DbfFieldDefs.Items[i].Precision)+');');
  end;//case
 end;
 SynMemo1.Lines.Add(' Dbf1.CreateTable;');
 //data export
 SynMemo1.Lines.Add('   //export all data as text fields');
 DbfTable.First;
 for _rcnt:=1 to DbfTable.ExactRecordCount do begin
  SynMemo1.Lines.Add('   Dbf1.Append;');
     MainStatusBar.Panels[4].Text := Format(rsExportingRec, [IntToStr(_rcnt),
       IntToStr(DbfTable.ExactRecordCount)]);
  for i:=0 to DbfTable.Fields.Count-1 do begin
   case DbfLocaleComboBox.ItemIndex of
    0:SynMemo1.Lines.Add('   Dbf1.FieldByName('''+DbfTable.Fields[i].FieldName+''').AsString:='''+ConsoleToUtf8(DbfTable.Fields[i].AsString)+''';');
    1:SynMemo1.Lines.Add('   Dbf1.FieldByName('''+DbfTable.Fields[i].FieldName+''').AsString:='''+AnsiToUtf8(DbfTable.Fields[i].AsString)+''';');
    2:SynMemo1.Lines.Add('   Dbf1.FieldByName('''+DbfTable.Fields[i].FieldName+''').AsString:='''+DbfTable.Fields[i].AsString+''';');
    end;
   Application.ProcessMessages;
  end;
  SynMemo1.Lines.Add('   Dbf1.Post;');
  DbfTable.Next;
 end;
 SynMemo1.Lines.Add('End;');
 paslist.Assign(SynMemo1.Lines);
 paslist.SaveToFile(ExportDialog.FileName);
 paslist.Free;
 ShowMessage(Format(rsSavedAs, [ExportDialog.FileName]));
 ShowSourceCheckBox.Enabled:=true;
 ShowSourceCheckBox.Checked:=false;
 ShowSourceCheckBoxClick(self);
 MainStatusBar.Panels[4].Text := rsWaiting;
end;

procedure TFormMain.actSearchExecute(Sender: TObject);
begin
 //show search dialog
 if not DbfTable.Active then Exit;
 DbfSearchBookmark:=DbfTable.GetBookmark;
 SearchPanel.Parent:=DbfDBGrid as TWinControl;
 SearchPanel.Left:=DbfDBGrid.SelectedFieldRect.Left+20;
 SearchPanel.Top:=DbfDBGrid.SelectedFieldRect.Top+20;
// SearchEdit.Clear;
 SearchPanel.Visible:=true;
 SearchEdit.SetFocus;
end;

procedure TFormMain.actSQLExportExecute(Sender: TObject);
var i,j : Integer;
   _s_,_ss_: String;
   sqllist : TStringList;
begin
 ExportDialog.Filter:=rsSQLQueryFile;
 ExportDialog.DefaultExt:='.sql';
 ExportDialog.InitialDir:='';
 ExportDialog.FileName:=LowerCase(Copy(DbfTable.TableName,1,Pos('.',DbfTable.TableName)-1));
 if not ExportDialog.Execute then exit;
 DbfTable.DisableControls;
 sqllist:=TStringList.Create;
 ShowSourceCheckBox.Enabled:=true;
 ShowSourceCheckBox.Checked:=true;
 SynMemo1.Visible:=true;
 SynMemo1.Highlighter:=SynSQLSyn1;
 SynMemo1.Clear;
 _s_:='CREATE TABLE '+UpperCase(Copy(DbfTable.TableName,1,Pos('.',DbfTable.TableName)-1))+' (';
 for i := 0 to DbfTable.DbfFieldDefs.Count-1 do begin
  _s_:=_s_+DbfTable.DbfFieldDefs.Items[i].FieldName;
  case DbfTable.DbfFieldDefs.Items[i].FieldType of
ftString,ftDate:_s_:=_s_+' VARCHAR, ';
ftSmallint,ftInteger,ftLargeint:_s_:=_s_+' NUMERIC, ';
ftFloat:_s_:=_s_+' FLOAT, ';
ftBoolean:_s_:=_s_+' BOOLEAN, ';
ftMemo:_s_:=_s_+' BLOB, '
  else _s_:=_s_+' VARCHAR, ';
  END;//case
 end;
 Delete(_s_,Length(_s_)-1,2);
 sqllist.Add(_s_+');');
 DbfTable.First;
 for j:=1 to DbfTable.ExactRecordCount do begin
  _s_:='INSERT INTO '+UpperCase(Copy(DbfTable.TableName,1,Pos('.',DbfTable.TableName)-1))+' VALUES(';
  _ss_:='';
  for i:=0 to DbfTable.FieldCount-1 do begin
    case DbfLocaleComboBox.ItemIndex of
        0:if DbfTable.Fields[i].AsString='' then _ss_:=_ss_+'NULL,' else _ss_:=_ss_+StringReplace(QuotedStr(Cp866ToUTF8(DbfTable.Fields[i].AsString)),',','.',[rfReplaceAll])+',';
        1:if DbfTable.Fields[i].AsString='' then _ss_:=_ss_+'NULL,' else _ss_:=_ss_+StringReplace(QuotedStr(CP1251ToUtf8(DbfTable.Fields[i].AsString)),',','.',[rfReplaceAll])+',';
        2:if DbfTable.Fields[i].AsString='' then _ss_:=_ss_+'NULL,' else _ss_:=_ss_+StringReplace(QuotedStr(KOI8ToUTF8(DbfTable.Fields[i].AsString)),',','.',[rfReplaceAll])+',';
        3:if DbfTable.Fields[i].AsString='' then _ss_:=_ss_+'NULL,' else _ss_:=_ss_+StringReplace(QuotedStr(ISO_8859_15ToUTF8(DbfTable.Fields[i].AsString)),',','.',[rfReplaceAll])+',';
        4:if DbfTable.Fields[i].AsString='' then _ss_:=_ss_+'NULL,' else _ss_:=_ss_+StringReplace(QuotedStr(DbfTable.Fields[i].AsString),',','.',[rfReplaceAll])+',';
     end;
  end;
  _s_:=_s_+_ss_;
  Delete(_s_,Length(_s_),1);
  sqllist.Add(_s_+');');
  MainStatusBar.Panels[4].Text := Format(rsExportingRec, [IntToStr(j), IntToStr(DbfTable.ExactRecordCount)]);
  DbfTable.Next;
  Application.ProcessMessages;
 end;
 DbfTable.EnableControls;
 SynMemo1.Visible:=true;
 sqllist.SaveToFile(ExportDialog.FileName);
 SynMemo1.Lines.Assign(sqllist);
 ShowMessage(Format(rsSavedAs, [ExportDialog.FileName]));
 MainStatusBar.Panels[4].Text := rsWaiting;
 sqllist.Free;
end;

procedure TFormMain.DbfTableAfterClose(DataSet: TDataSet);
begin
 actSearch.Enabled:=False;
 actEditData.Enabled:=False;
 actSQLExport.Enabled:=False;
 actCSVExport.Enabled:=False;
 actPasExport.Enabled:=False;
 acrRestructureDBF.Enabled:=False;
 actCloseDbf.Enabled:=True;
end;

procedure TFormMain.DbfTableAfterOpen(DataSet: TDataSet);
var i,j : Integer;
   mask : String;
begin
 actSearch.Enabled:=True;
 actEditData.Enabled:=True;
 actSQLExport.Enabled:=True;
 actCSVExport.Enabled:=True;
 actPasExport.Enabled:=True;
 acrRestructureDBF.Enabled:=True;
 actCloseDbf.Enabled:=false;
 //fields display format settings
 for i:=0 to DataSet.FieldCount-1 do begin
  if DataSet.FieldDefs.Items[i].Precision <>0 then begin
   mask:='#0.';
   for j:=0 to DataSet.FieldDefs.Items[i].Precision-1 do mask:=mask+'0';
   DbfDBGrid.Columns.Items[i].DisplayFormat:=mask;
  end;
 end;
end;

procedure TFormMain.DbfTableIndexMissing(var DeleteLink: Boolean);
begin
  ShowMessage(rsIndexMissing);
end;

procedure TFormMain.MenuItem13Click(Sender: TObject);
begin
  DbfTable.ClearFields;
end;

procedure TFormMain.ShowDeletedCheckBoxClick(Sender: TObject);
begin
  DbfTable.ShowDeleted:=ShowDeletedCheckBox.Checked;
  MenuItem12.Enabled:=ShowDeletedCheckBox.Checked;
end;

procedure TFormMain.DbfDBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if not DbfTable.ShowDeleted then begin
   DbfDBGrid.DefaultDrawColumnCell(Rect,DataCol, Column, State);
   exit;
  end;
  if DbfTable.IsDeleted then begin
   DbfDBGrid.Canvas.Font.Color:=clRed;
   DbfDBGrid.DefaultDrawColumnCell(Rect,DataCol, Column, State);
  end;
end;

procedure TFormMain.MenuItem11Click(Sender: TObject);
begin
  DbfTable.Delete;
end;

procedure TFormMain.MenuItem12Click(Sender: TObject);
begin
 DbfTable.Undelete;
end;

procedure TFormMain.ToolsEmptyMenuItemClick(Sender: TObject);
begin
  DbfTable.Active:=false;
  DbfTable.Exclusive:=true;
  DbfTable.Active:=true;
  DbfTable.EmptyTable;
  DbfTable.Active:=false;
  DbfTable.Exclusive:=false;
  DbfTable.Active:=true;
end;

procedure TFormMain.ToolsPackMenuItemClick(Sender: TObject);
begin
  DbfTable.Active:=false;
  DbfTable.Exclusive:=true;
  DbfTable.Active:=true;
  DbfTable.PackTable;
  ShowMessage(rsTablePacked);
end;

procedure TFormMain.DbFieldGetText(Sender: TField; var aText: String;
  DisplayText: Boolean);
begin
 if not DisplayText then Exit;
 case DbfLocaleComboBox.ItemIndex of
 0:  aText:=CP866ToUTF8(Sender.AsString);// DOS
 1:  aText:=CP1251ToUTF8(Sender.AsString);   // Win1251
 2:  aText:=KOI8ToUTF8(Sender.AsString); //   Koi8
 3:  aText:=ISO_8859_2ToUTF8(Sender.AsString);//   ISO eastern europe
 //   UTF16
 //   MAC
 else  aText:=Sender.AsString;
 end;
end;

procedure TFormMain.DbFieldSetText(Sender: TField; const aText: String);
begin
 case DbfLocaleComboBox.ItemIndex of
 0:  Sender.AsString:=UTF8ToCP866(aText);// DOS
 1:  Sender.AsString:=UTF8ToCP1251(aText);   // Win1251
 2:  Sender.AsString:=UTF8ToKOI8(aText); //   Koi8
 3:  Sender.AsString:=UTF8ToISO_8859_2(aText);//   ISO eastern europe
 //   UTF16
 //   MAC
 else  Sender.AsString:=aText;
 end;
end;

procedure TFormMain.DbAfterOpen(Dataset: TDataset);
var i : Integer;
begin
 for i := 0 to Dataset.FieldCount-1 do
  if Dataset.Fields[i].DataType in [ftWideString, ftString,ftMemo,ftBlob,ftFixedChar] then begin
   Dataset.Fields[i].OnGetText:=@DbFieldGetText;
   Dataset.Fields[i].OnSetText:=@DbFieldSetText;
  end;
end;

procedure TFormMain.actFileOpenExecute(Sender: TObject);
var  i  : Integer;
begin
  for i:= 0 to ComponentCount-1 do
   if (Components[i] is TDataSet) then begin
    (Components[i] as TDataSet).AfterOpen :=@DbAfterOpen;
    if (Components[i] as TDataSet).Active then DbAfterOpen(Components[i] as TDataSet);
   end;
  //Close opened before table and hide dbgrid
  DbfDBGrid.Visible := false;
  DBMemo1.DataField:='';
  DbfTable.Active := False;
  //clear all panels on main statusbar
  MainStatusBar.Panels.Clear;
  Caption := 'DBDesigner';
  if TableOpenDialog.Execute then begin
   DbfTable.FilePathFull := ExtractFilePath(TableOpenDialog.FileName);
   DbfTable.TableName := ExtractFileName(TableOpenDialog.FileName);
   DbfTable.Active := true;
   DbfDBGrid.Visible := true;
   DbfDBGridColEnter(self);
   SetStatusBarInfo;
   DbfTableAfterOpen(DbfTable);
  end;
end;

procedure TFormMain.Action2Execute(Sender: TObject);
begin
  //TODO: show non-modal filter dialog with full field list and additional options
 if not DbfTable.Active then Exit;
end;

procedure TFormMain.ShowSourceCheckBoxClick(Sender: TObject);
begin
 SynMemo1.Visible:=ShowSourceCheckBox.Checked;
end;

procedure TFormMain.DbfDBGridColEnter(Sender: TObject);
begin
  DBMemo1.DataField:=DbfDBGrid.SelectedColumn.FieldName;
end;

procedure TFormMain.actFileExitExecute(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TFormMain.actCreateDBFExecute(Sender: TObject);
begin
 FormSelectDbType.ShowModal;
end;

procedure TFormMain.actCSVExportExecute(Sender: TObject);
var i,j : Integer;
   _s_: String;
   csvseparator : String;
   csvlist : TStringList;
begin
 ExportDialog.Filter:=rsCSVFilesCsvA;
 ExportDialog.DefaultExt:='.csv';
 ExportDialog.InitialDir:='';
 ExportDialog.FileName:=LowerCase(Copy(DbfTable.TableName,1,Pos('.',DbfTable.TableName)-1));
 if not ExportDialog.Execute then exit;
 csvlist:=TStringList.Create;
 csvseparator:=';';//TODO: settingsini.ReadString('EXPORT','CSVSEPARATOR',';');
 SynMemo1.Clear;
 _s_:='';
 for i := 0 to DbfTable.DbfFieldDefs.Count-1 do _s_:=_s_+DbfTable.DbfFieldDefs.Items[i].FieldName+csvseparator;
 Delete(_s_,Length(_s_),1);
 csvlist.Add(_s_);
 DbfTable.First;
 j:=0;
 while not DbfTable.EOF do begin
  _s_:=''; Inc(j);
  for i := 0 to DbfTable.FieldCount-1 do
    case DbfLocaleComboBox.ItemIndex of
        0:_s_:=_s_+QuotedStr(ConsoleToUTF8(DbfTable.Fields[i].AsString))+csvseparator;
        1:_s_:=_s_+QuotedStr(AnsiToUtf8(DbfTable.Fields[i].AsString))+csvseparator;
        2:_s_:=_s_+QuotedStr(DbfTable.Fields[i].AsString)+csvseparator;
     end;
  Delete(_s_,Length(_s_),1);
  csvlist.Add(_s_);
  MainStatusBar.Panels[4].Text := Format(rsExportingRec, [IntToStr(j), IntToStr(DbfTable.ExactRecordCount)]);
  DbfTable.Next;
  Application.ProcessMessages;
 end;
 csvlist.SaveToFile(ExportDialog.FileName);
 SynMemo1.Lines.Assign(csvlist);
 ShowMessage(Format(rsSavedAs, [ExportDialog.FileName]));
 SynMemo1.Clear;
 MainStatusBar.Panels[4].Text := rsWaiting;
 csvlist.Free;
end;

procedure TFormMain.actEditDataExecute(Sender: TObject);
begin
  if not DbfTable.Active then Exit;
  if DbfTable.State in dsEditModes then DbfTable.Post;
  DbfDatasource.AutoEdit := not DbfDatasource.AutoEdit;
  sbEditDataSpeedButton.Flat := DbfDatasource.AutoEdit;
  case DbfDatasource.AutoEdit of
false: ImageList1.GetBitmap(1,sbEditDataSpeedButton.Glyph);
true : ImageList1.GetBitmap(0,sbEditDataSpeedButton.Glyph);
  end;

end;

procedure TFormMain.acrRestructureDBFExecute(Sender: TObject);
var       I : Integer;
    flddefs : TDbfFieldDefs;
begin
  if not DbfTable.Active then exit;
  tl := DbfTable.TableLevel;
  //try open index files
  FormDBSructureDesigner.IndexComboBox.Items.Clear;
  if FileExists(DbfTable.FilePathFull+ChangeFileExt(DbfTable.TableName,'.IDX')) then begin
   FormDBSructureDesigner.IndexComboBox.Items.Add(ChangeFileExt(DbfTable.TableName,'.IDX'));
  end else DbfTable.GetIndexNames(FormDBSructureDesigner.IndexComboBox.Items);
  isNew := false;
  flddefs:=DbfTable.DbfFieldDefs;
  with FormDBSructureDesigner do begin
   StructureStringGrid.RowCount := flddefs.Count+1;
   for i := 0 to flddefs.Count-1 do begin
     StructureStringGrid.Cells[0,i+1]:= IntToStr(i+1);
     StructureStringGrid.Cells[1,i+1]:= flddefs.Items[i].FieldName;
     if flddefs.Items[i].FieldType=ftString then begin
        StructureStringGrid.Cells[2, i+1]:=rsCharacter;
        StructureStringGrid.Cells[3,i+1]:= IntToStr(flddefs.Items[i].Size);
     end;
     if flddefs.Items[i].FieldType= ftSmallint then begin
        StructureStringGrid.Cells[2, i+1]:=rsNumber;
        StructureStringGrid.Cells[3,i+1]:= IntToStr(flddefs.Items[i].Size);
     end;
     if flddefs.Items[i].FieldType=ftInteger then begin
        StructureStringGrid.Cells[2, i+1]:=rsNumber;
        StructureStringGrid.Cells[3,i+1]:= IntToStr(flddefs.Items[i].Size);
     end;
     if FldDefs.Items[i].FieldType=ftWord then begin
        StructureStringGrid.Cells[2, i+1]:=rsNumber;
        StructureStringGrid.Cells[3,i+1]:= IntToStr(flddefs.Items[i].Size);
        end;
     if FldDefs.Items[i].FieldType=ftBoolean then StructureStringGrid.Cells[2, i
       +1]:=rsLogical;
     if FldDefs.Items[i].FieldType=ftFloat then begin
        StructureStringGrid.Cells[2, i+1]:=rsFloat;
        StructureStringGrid.Cells[3,i+1]:= IntToStr(FldDefs.Items[i].Size);
        StructureStringGrid.Cells[4,i+1]:= IntToStr(FldDefs.Items[i].Precision);
     end;
     if FldDefs.Items[i].FieldType=ftCurrency then StructureStringGrid.Cells[2,i+1]:=rsFloat;
     if FldDefs.Items[i].FieldType=ftBCD then StructureStringGrid.Cells[2, i+1]:=rsBinary;
     if FldDefs.Items[i].FieldType=ftDate then StructureStringGrid.Cells[2, i+1]:=rsDate;
     if FldDefs.Items[i].FieldType=ftDateTime then StructureStringGrid.Cells[2,i+1]:=rsDate;
     if FldDefs.Items[i].FieldType=ftBytes then StructureStringGrid.Cells[2, i+1]:=rsBinary;
     if FldDefs.Items[i].FieldType=ftAutoInc then StructureStringGrid.Cells[2, i+1]:=rsAutoinc;
     if flddefs.Items[i].FieldType=ftBlob then StructureStringGrid.Cells[2, i+1]:=rsFtBlob;
     if flddefs.Items[i].FieldType=ftMemo then StructureStringGrid.Cells[2, i+1]:=rsFtMemo;
     if flddefs.Items[i].FieldType=ftDBaseOle then StructureStringGrid.Cells[2,i+1]:=rsFtDBaseOle;
     if flddefs.Items[i].FieldType=ftFixedChar then StructureStringGrid.Cells[2, i+1]:=rsFtFixedChar;
     if flddefs.Items[i].FieldType=ftWideString then StructureStringGrid.Cells[2, i+1]:=rsFtWideString;
     if flddefs.Items[i].FieldType=ftLargeint then StructureStringGrid.Cells[2,i+1]:=rsFtLargeint;
   end;//for i
  end;//with
  FormDBSructureDesigner.ShowModal;
end;

procedure TFormMain.actCloseDbfExecute(Sender: TObject);
begin
  DbfTable.Active:=false;
  DbfDBGrid.Visible := false;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var i : Integer;
begin
  DbfDBGrid.Visible := false;
  actCloseDbf.Enabled:=DbfDBGrid.Visible;
  DbfTableAfterClose(DbfTable);
  WindowState := wsMaximized;
  {$IFDEF MSWINDOWS}
  DbfLocaleComboBox.ItemIndex:=1;
  {$ENDIF}
  //clear all panels on main statusbar
  MainStatusBar.Panels.Clear;
  Caption := rsDBDesigner;
  LocaleLabel.Caption:=rsDBFLocale;
  ShowSourceCheckBox.Caption:=rsShowSource;
  ShowDeletedCheckBox.Caption:=rsShowDeleted;
  SearchLabel.Caption:=rsSearch;
  if Paramcount>0 then begin
   for i:= 0 to ComponentCount-1 do
    if (Components[i] is TDataSet) then begin
       (Components[i] as TDataSet).AfterOpen :=@DbAfterOpen;
    if (Components[i] as TDataSet).Active then DbAfterOpen(Components[i] as TDataSet);
    end;
    //Close opened before table and hide dbgrid
    DbfDBGrid.Visible := false;
    DBMemo1.DataField:='';
    DbfTable.Active := False;
    //check if no error open file
     DbfTable.FilePathFull := ExtractFilePath(ParamStr(1));
     DbfTable.TableName := ExtractFileName(ParamStr(1));
     try
      DbfTable.Active := true;
      //TODO: onError handler
     finally
      DbfDBGrid.Visible := true;
      DbfDBGridColEnter(self);
      SetStatusBarInfo;
      DbfTableAfterOpen(DbfTable);
     end;
  end;
end;

procedure TFormMain.FormDropFiles(Sender: TObject;
  const FileNames: array of String);
var i : Integer;
begin
 for i:= 0 to ComponentCount-1 do
   if (Components[i] is TDataSet) then begin
    (Components[i] as TDataSet).AfterOpen :=@DbAfterOpen;
    if (Components[i] as TDataSet).Active then DbAfterOpen(Components[i] as TDataSet);
   end;
  //Close opened before table and hide dbgrid
  DbfDBGrid.Visible := false;
  DBMemo1.DataField:='';
  DbfTable.Active := False;
  //clear all panels on main statusbar
  MainStatusBar.Panels.Clear;
  Caption := rsDBDesigner;
  //TODO: check if no error open file
  DbfTable.FilePathFull := ExtractFilePath(FileNames[0]);
  DbfTable.TableName := ExtractFileName(FileNames[0]);
  DbfTable.Active := true;
  DbfDBGrid.Visible := true;
  DbfDBGridColEnter(self);
  SetStatusBarInfo;
  DbfTableAfterOpen(DbfTable);
end;

initialization
  {$I umain.lrs}

end.

