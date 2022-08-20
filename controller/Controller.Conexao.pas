unit Controller.Conexao;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.DApt;

type
  TControllerConexao = class
  public
    class function CreateData : Boolean;
    class function VerificaBanco : Boolean;
  end;

implementation

uses
  uDmPrincipal, Utils.Geral;

{ TControllerConexao }
class function TControllerConexao.CreateData: Boolean;
var
  query : TFDQuery;
begin
  try
    query := TFDQuery.Create(nil);
    try
      query.Connection := TdmPrincipal.GetConnection.Conexao;

      query.SQL.Clear;
      query.SQL.Add('CREATE TABLE IF NOT EXISTS PESSOA ( ');
      query.SQL.Add('ID INTEGER PRIMARY KEY AUTOINCREMENT, ');
      query.SQL.Add('NOME STRING(100) NOT NULL, ');
      query.SQL.Add('CPF STRING(11) NOT NULL, ');
      query.SQL.Add('RG STRING(20), ');
      query.SQL.Add('PAI STRING(100), ');
      query.SQL.Add('MAE STRING(100)) ');
      query.ExecSQL;

      query.SQL.Clear;
      query.SQL.Add('CREATE TABLE IF NOT EXISTS ENDERECO ( ');
      query.SQL.Add('ID INTEGER PRIMARY KEY AUTOINCREMENT, ');
      query.SQL.Add('ID_PESSOA INTEGER NOT NULL, ');
      query.SQL.Add('TIPO_ENDERECO STRING(15) NOT NULL, ');
      query.SQL.Add('CEP STRING(8) NOT NULL, ');
      query.SQL.Add('LOGRADOURO STRING(100) NOT NULL, ');
      query.SQL.Add('NUMERO STRING(15), ');
      query.SQL.Add('COMPLEMENTO STRING(75), ');
      query.SQL.Add('BAIRRO STRING(75), ');
      query.SQL.Add('CIDADE STRING(75), ');
      query.SQL.Add('UF STRING(2), ');
      query.SQL.Add('FOREIGN KEY (ID_PESSOA) REFERENCES PESSOA(ID))');
      query.ExecSQL;
      Result := True;
    finally
      FreeAndNil(query);
    end;
  except
    on e : Exception do
    begin
      Result := False;
      raise Exception.Create('Erro ao criar as tabelas do Sistema!' + sLineBreak +
                             'Descrição do Erro: ' + e.Message);
    end;
  end;
end;

class function TControllerConexao.VerificaBanco: Boolean;
begin
  Result := FileExists(ExtractFileDir(GetCurrentDir) + '\database\dados.db');
end;

end.
