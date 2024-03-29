{
***************************************************************************
*                                                                         *
*   Lazarus DBF Designer                                                  *
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
program dbdesigner;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Forms, Interfaces
  { add your units here },
  umain, useltype, ustruct, uftype, uabout, uindex, translations, urstrrings, sysutils, LCLProc, LazUTF8;

{$IFDEF MSWINDOWS}
{$R *.res}
{$ENDIF}

 function GetAppName : String;
 begin
   Result := 'dbfdesigner';
 end;

procedure TranslateLCL;
var poDidectory, lang, fallbacklang : String;
begin
  poDidectory:=ExtractFilePath(GetAppName)+'languages';
  lang:='';
  fallbacklang:='';
  LazGetLanguageIDs(lang,fallbacklang);
  translations.TranslateUnitResourceStrings('urstrrings',poDidectory+'dbfdesigner.%.po',lang,fallbacklang);
end;

begin
  OnGetApplicationName:=@GetAppName;
  Application.Initialize;
  Application.Title:='';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormSelectDbType, FormSelectDbType);
  Application.CreateForm(TFormDBSructureDesigner, FormDBSructureDesigner);
  Application.CreateForm(TFormFT, FormFT);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TIndexForm, IndexForm);
  Application.Run;
end.

