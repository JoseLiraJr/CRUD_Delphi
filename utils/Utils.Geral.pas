unit Utils.Geral;

interface

uses
  System.SysUtils, System.DateUtils, Data.DB, VCL.Controls, Vcl.StdCtrls,
  Vcl.ComCtrls, VCl.DBCtrls, VCl.Buttons;

type
  TUtilsGeral = class
    class function dayOfWeek : string;
    class function dataExtenso : string;
    class procedure EnableControls(control: TWinControl; enable: Boolean);
    class function CharNumbers(Key : Char) : Boolean;
    class procedure ClearEditors(control: TWinControl);
    class function ifthen<T>(condition : Boolean; t1, t2 : T) : T;
  end;

const
  SOBRE_TECNOLOGIAS = 'Object Pascal, Delphi Embarcadero  10.3  Community Edition e SQLite.';
  SOBRE_ARQUITETURA = 'Implemntado a arquiterura MVC, para execução do CRUD.';
  SOBRE_DESENVOLVEDOR = 'Júnior Lira / Tel: (16) 99117-9898';

implementation

{ TUtilsGeral }

class procedure TUtilsGeral.EnableControls(control: TWinControl;
  enable: Boolean);
var
  i : Integer;
begin
  //Habilitando e desabilitando controles
  for i := 0 to control.ControlCount - 1 do
  begin
    if (control.Controls[i] is TEdit) then
      (control.Controls[i] as TEdit).Enabled := enable;
    if (control.Controls[i] is TDBLookupComboBox) then
      (control.Controls[i] as TDBLookupComboBox).Enabled := enable;
    if (control.Controls[i] is TSpeedButton) then
      (control.Controls[i] as TSpeedButton).Enabled := enable;
    if (control.Controls[i] is TBitBtn) then
      (control.Controls[i] as TBitBtn).Enabled := enable;
    if (control.Controls[i] is TDateTimePicker) then
      (control.Controls[i] as TDateTimePicker).Enabled := enable;
  end;
end;

class function TUtilsGeral.ifthen<T>(condition: Boolean; t1, t2: T): T;
begin
  if condition then
    Result := t1
  else
    Result := t2;
end;

class function TUtilsGeral.CharNumbers(Key: Char): Boolean;
begin
  Result := True;
  if not(CharInSet(Key,['0'..'9',#8])) then
    Result := False;
end;

class procedure TUtilsGeral.ClearEditors(control: TWinControl);
var
  i : Integer;
begin
  for i := 0 to control.ControlCount - 1 do
   begin
     if (control.Controls[i] is TEdit) then
       (control.Controls[i] as TEdit).Text := '';
     if (control.Controls[i] is TDBLookupComboBox) then
       (control.Controls[i] as TDBLookupComboBox).KeyValue := -1;
     if (control.Controls[i] is TComboBox) then
       (control.Controls[i] as TComboBox).ItemIndex := -1;
   end;
end;

class function TUtilsGeral.dataExtenso: string;
var
  mes : string;
begin
  case MonthOfTheYear(now) of
    1  : mes := 'Janeiro';
    2  : mes := 'Fevereiro';
    3  : mes := 'Março';
    4  : mes := 'Abril';
    5  : mes := 'Maio';
    6  : mes := 'Junho';
    7  : mes := 'Julho';
    8  : mes := 'Agosto';
    9  : mes := 'Setembro';
    10 : mes := 'Outubro';
    11 : mes := 'Novembro';
    12 : mes := 'Dezembro';
  end;

  Result := FormatDateTime('dd', now) + ' de ' + mes + ' de ' + FormatDateTime('yyyy', now);
end;

class function TUtilsGeral.dayOfWeek: string;
begin
  case DayOfTheWeek(now) of
    1 : Result := 'Segunda';
    2 : Result := 'Terça';
    3 : Result := 'Quarta';
    4 : Result := 'Quinta';
    5 : Result := 'Sexta';
    6 : Result := 'Sábado';
    7 : Result := 'Domingo';
  end;
end;

end.
