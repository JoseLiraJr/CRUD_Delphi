unit DAO.Endereco;

interface

uses
  System.SysUtils, DTO.Endereco, FireDAC.Comp.Client, FireDAC.DApt, uDmPrincipal,
  Data.DB;

type
  TDAOEndereco = class
  private
    FQuery : TFDQuery;
    function GetMaxID : Integer;
  public
    function Insert(Endereco : TDTOEndereco) : Integer;
    function Update(Endereco : TDTOEndereco) : Integer;
    function Delete(id : Integer) : Boolean;
    function Select(id : Integer) : TDataSet;
    constructor Create;
    destructor Destroy; override;
  end;

const
   SQL_INSERT = 'INSERT INTO ENDERECO(TIPO_ENDERECO, CEP, LOGRADOURO, NUMERO, COMPLEMENTO, ' +
                'BAIRRO, CIDADE, UF, ID_PESSOA) VALUES (:TIPO, :CEP, :LOGRADOURO, :NUMERO, ' +
                ':COMPLEMENTO, :BAIRRO, :CIDADE, :UF, :ID_PESSOA)';
   SQL_UPDATE = 'UPDATE ENDERECO SET TIPO_ENDERECO = :TIPO, CEP = :CEP, LOGRADOURO = :LOGRADOURO, '+
                'BAIRRO = :BAIRRO, CIDADE = :CIDADE, UF = :UF, ID_PESSOA = :ID_PESSOA WHERE ID = :ID';
   SQL_LAST_ID = 'SELECT MAX(ID) FROM ENDERECO';
   SQL_DELETE = 'DELETE FROM ENDERECO WHERE ID_PESSOA = :ID';
   SQL_SELECT = 'SELECT TIPO_ENDERECO, CEP, LOGRADOURO, NUMERO, COMPLEMENTO, BAIRRO, ' +
                'CIDADE, UF FROM ENDERECO WHERE ID_PESSOA = :ID';

implementation

{ TDAOEndereco }

constructor TDAOEndereco.Create;
begin
  inherited Create;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TdmPrincipal.GetConnection.Conexao;
end;

function TDAOEndereco.Delete(id: Integer): Boolean;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(SQL_DELETE);
  FQuery.Params.ParamByName('ID').AsInteger := id;
  FQuery.ExecSQL;
  Result := FQuery.RowsAffected > 0;
end;

destructor TDAOEndereco.Destroy;
begin
  FreeAndNil(FQuery);
  inherited Destroy;
end;

function TDAOEndereco.GetMaxID: Integer;
begin
  FQuery.SQL.Clear;
  FQuery.Open(SQL_LAST_ID);
  Result := FQuery.Fields[0].AsInteger;
end;

function TDAOEndereco.Insert(Endereco: TDTOEndereco): Integer;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(SQL_INSERT);
  FQuery.Params.ParamByName('TIPO').AsString := Endereco.TipoEndereco;
  FQuery.Params.ParamByName('CEP').AsString := Endereco.CEP;
  FQuery.Params.ParamByName('LOGRADOURO').AsString := Endereco.Logradouro;
  FQuery.Params.ParamByName('NUMERO').AsString := Endereco.Numero;
  FQuery.Params.ParamByName('COMPLEMENTO').AsString := Endereco.Complemento;
  FQuery.Params.ParamByName('BAIRRO').AsString := Endereco.Bairro;
  FQuery.Params.ParamByName('CIDADE').AsString := Endereco.Cidade;
  FQuery.Params.ParamByName('UF').AsString := Endereco.Estado;
  FQuery.Params.ParamByName('ID_PESSOA').AsInteger := Endereco.ID_Pessoa;
  FQuery.Prepare;
  FQuery.ExecSQL;
  Result := GetMaxID;
end;

function TDAOEndereco.Select(id: Integer): TDataSet;
begin
  FQuery.SQL.Clear;
  FQuery.Open(SQL_SELECT, [id]);

  Result := (FQuery as TDataSet);
end;

function TDAOEndereco.Update(Endereco: TDTOEndereco): Integer;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(SQL_UPDATE);
  FQuery.Params.ParamByName('TIPO').AsString := Endereco.TipoEndereco;
  FQuery.Params.ParamByName('CEP').AsString := Endereco.CEP;
  FQuery.Params.ParamByName('LOGRADOURO').AsString := Endereco.Logradouro;
  FQuery.Params.ParamByName('NUMERO').AsString := Endereco.Numero;
  FQuery.Params.ParamByName('COMPLEMENTO').AsString := Endereco.Complemento;
  FQuery.Params.ParamByName('BAIRRO').AsString := Endereco.Bairro;
  FQuery.Params.ParamByName('CIDADE').AsString := Endereco.Cidade;
  FQuery.Params.ParamByName('UF').AsString := Endereco.Estado;
  FQuery.Params.ParamByName('ID_PESSOA').AsInteger := Endereco.ID_Pessoa;
  FQuery.Params.ParamByName('ID').AsInteger := Endereco.ID;
  FQuery.Prepare;
  FQuery.ExecSQL;
  Result := Endereco.ID;
end;

end.
