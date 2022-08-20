unit DAO.Pessoa;

interface

uses
  System.SysUtils, DTO.Pessoa, FireDAC.Comp.Client, FireDAC.DApt, uDmPrincipal, Data.DB;

type
  TDAOPessoa = class
  private
    FQuery : TFDQuery;
    function GetMaxID : Integer;
  public
    function Insert(Pessoa : TDTOPessoa) : Integer;
    function Update(Pessoa : TDTOPessoa) : Integer;
    function Select(SqlWhere : string = ''): TDataSet;
    function Delete(id : Integer) : Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

const
   SQL_INSERT = 'INSERT INTO PESSOA(NOME, CPF, RG, PAI, MAE) VALUES '+
                '(:NOME, :CPF, :RG, :PAI, :MAE)';
   SQL_UPDATE = 'UPDATE PESSOA SET NOME = :NOME, CPF = :CPF, RG = :RG, '+
                'PAI = :PAI, MAE = :MAE WHERE ID = :ID';
   SQL_SELECT = 'SELECT * FROM PESSOA ';
   SQL_LAST_ID = 'SELECT MAX(ID) FROM PESSOA';
   SQL_DELETE = 'DELETE FROM PESSOA WHERE ID = :ID';

implementation

{ TDAOPessoa }

constructor TDAOPessoa.Create;
begin
  inherited Create;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TdmPrincipal.GetConnection.Conexao;
end;

function TDAOPessoa.Delete(id: Integer): Boolean;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(SQL_DELETE);
  FQuery.Params.ParamByName('ID').AsInteger := id;
  FQuery.ExecSQL;
  Result := FQuery.RowsAffected > 0;
end;

destructor TDAOPessoa.Destroy;
begin
  FreeAndNil(FQuery);
  inherited Destroy;
end;

function TDAOPessoa.GetMaxID: Integer;
begin
  FQuery.SQL.Clear;
  FQuery.Open(SQL_LAST_ID);
  Result := FQuery.Fields[0].AsInteger;
end;

function TDAOPessoa.Insert(Pessoa: TDTOPessoa) : Integer;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(SQL_INSERT);
  FQuery.Params.ParamByName('NOME').AsString := Pessoa.Nome;
  FQuery.Params.ParamByName('CPF').AsString := Pessoa.CPF;
  FQuery.Params.ParamByName('RG').AsString := Pessoa.RG;
  FQuery.Params.ParamByName('PAI').AsString := Pessoa.Pai;
  FQuery.Params.ParamByName('MAE').AsString := Pessoa.Mae;
  FQuery.Prepare;
  FQuery.ExecSQL;
  Result := GetMaxID;
end;

function TDAOPessoa.Select(SqlWhere: string): TDataSet;
begin
  FQuery.SQL.Clear;
  FQuery.Open(SQL_SELECT + SqlWhere);

  Result := (FQuery as TDataSet);
end;

function TDAOPessoa.Update(Pessoa: TDTOPessoa) : Integer;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(SQL_UPDATE);
  FQuery.Params.ParamByName('NOME').AsString := Pessoa.Nome;
  FQuery.Params.ParamByName('CPF').AsString := Pessoa.CPF;
  FQuery.Params.ParamByName('RG').AsString := Pessoa.RG;
  FQuery.Params.ParamByName('PAI').AsString := Pessoa.Pai;
  FQuery.Params.ParamByName('MAE').AsString := Pessoa.Mae;
  FQuery.Params.ParamByName('ID').AsInteger := Pessoa.ID;
  FQuery.Prepare;
  FQuery.ExecSQL;
  Result := Pessoa.ID;
end;

end.
