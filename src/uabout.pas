{
***************************************************************************
*                                                                         *
*   Lazarus DBF Designer About form unit                                  *
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
unit uabout;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, ExtCtrls,
  StdCtrls, ComCtrls, urstrrings;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    AboutPageControl: TPageControl;
    Memo1: TMemo;
    Memo2: TMemo;
    PoweredImage: TImage;
    AboutTabSheet: TTabSheet;
    GPLTabSheet: TTabSheet;
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  AboutForm: TAboutForm;

implementation

{ TAboutForm }

procedure TAboutForm.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  Caption:=rsAboutDBFDesi;
  AboutTabSheet.Caption:=rsAbout;
  GPLTabSheet.Caption:=rsLicense;
end;


initialization
  {$I uabout.lrs}

end.

