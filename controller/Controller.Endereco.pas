unit Controller.Endereco;

interface

uses
  DTO.Endereco, System.SysUtils, Data.DB, DAO.Endereco;

type
  TControllerEndereco = class
  private
    class var DaoEndereco : TDAOEndereco;
    class var Controller : TControllerEndereco;
  public
    constructor Create;
    destructor Destroy; override;

    class function ValidateInsert(Endereco : TDTOEndereco) : Boolean;
    class procedure InsertEnderecoDataset(Endereco : TDTOEndereco; Dataset : TDataSet);
    class function ExisteEndereco(Dataset : TDataSet) : Boolean;
    class function SaveEndereco(Endereco : TDTOEndereco) : Integer;
    class function GetController : TControllerEndereco;
    class function DeleteEndereco(id : Integer) : Boolean;
    class procedure GetEnderecos(id : integer; dataset : TDataSet);
  end;

implementation

{ TControllerEndereco }

constructor TControllerEndereco.Create;
begin
  Inherited Create;
  DaoEndereco := TDAOEndereco.Create;
end;

class function TControllerEndereco.DeleteEndereco(id: Integer): Boolean;
begin
  Result := DaoEndereco.Delete(id);
end;

destructor TControllerEndereco.Destroy;
begin
  FreeAndNil(DaoEndereco);
  inherited Destroy;
end;

class function TControllerEndereco.ExisteEndereco(Dataset: TDataSet): Boolean;
begin
  Result := Dataset.RecordCount > 0;
end;

class function TControllerEndereco.GetController: TControllerEndereco;
begin
  if not(Assigned(Controller)) then
    Controller := TControllerEndereco.Create;
  Result := Controller;
end;

class procedure TControllerEndereco.GetEnderecos(id: integer; dataset : TDataSet);
var
  dts : TDataSet;
begin
  dts := DaoEndereco.Select(id);
  if not(dataset.Active) then
    dataset.Open;

  dts.First;
  while not(dts.Eof) do
  begin
    dataset.Append;
    dataset.FieldByName('TIPO_ENDERECO').AsString := dts.FieldByName('TIPO_ENDERECO').AsString;
    dataset.FieldByName('CEP').AsString := dts.FieldByName('CEP').AsString;
    dataset.FieldByName('LOGRADOURO').AsString := dts.FieldByName('LOGRADOURO').AsString;
    dataset.FieldByName('NUMERO').AsString := dts.FieldByName('NUMERO').AsString;
    dataset.FieldByName('COMPLEMENTO').AsString := dts.FieldByName('COMPLEMENTO').AsString;
    dataset.FieldByName('BAIRRO').AsString := dts.FieldByName('BAIRRO').AsString;
    dataset.FieldByName('CIDADE').AsString := dts.FieldByName('CIDADE').AsString;
    dataset.FieldByName('UF').AsString := dts.FieldByName('UF').AsString;
    dataset.Post;

    DTS.Next;
  end;
end;

class procedure TControllerEndereco.InsertEnderecoDataset(
  Endereco: TDTOEndereco; Dataset: TDataSet);
begin
  if not(Dataset.Active) then
    Dataset.Open;
  with (Endereco) do
  begin
    Dataset.Append;
    Dataset.FieldByName('TIPO_ENDERECO').AsString := TipoEndereco;
    Dataset.FieldByName('LOGRADOURO').AsString := Logradouro;
    Dataset.FieldByName('NUMERO').AsString := Numero;
    Dataset.FieldByName('COMPLEMENTO').AsString := Complemento;
    Dataset.FieldByName('BAIRRO').AsString := Bairro;
    Dataset.FieldByName('CIDADE').AsString := Cidade;
    Dataset.FieldByName('UF').AsString := Estado;
    Dataset.FieldByName('CEP').AsString := CEP;
    Dataset.Post;
  end;
end;

class function TControllerEndereco.SaveEndereco(
  Endereco: TDTOEndereco): Integer;
begin
  Result := 0;

  if (Endereco.ID > 0) then
    Result := DaoEndereco.Update(Endereco)
  else
    Result := DaoEndereco.Insert(Endereco);
end;

class function TControllerEndereco.ValidateInsert(
  Endereco: TDTOEndereco): Boolean;
begin
  Result := False;

  if (Endereco.TipoEndereco.IsEmpty) then
    raise Exception.Create('Informe o tipo de endereço antes de continuar');

  if (Endereco.Logradouro.IsEmpty) then
    raise Exception.Create('Informe o logradouro antes de continuar');

  if (Endereco.CEP.IsEmpty) then
    raise Exception.Create('Informe o CEP antes de continuar');

  Result := True;
end;

end.
