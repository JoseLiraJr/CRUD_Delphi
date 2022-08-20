unit Controller.Pessoa;

interface

uses
  System.SysUtils, DTO.Pessoa, DAO.Pessoa, Data.DB;

type
  TControllerPessoa = class
  private
    class var DaoPessoa : TDAOPessoa;
    class var Controller : TControllerPessoa;
  public
    constructor Create;
    destructor Destroy; override; 
    class function ValidateInsert(Pessoa : TDTOPessoa) : Boolean;
    class function SavePessoa(Pessoa : TDTOPessoa) : Integer;
    class function GetPessoas(Where : string = '') : TDataSet; 
    class function GetController : TControllerPessoa;
    class function ExistePessoa(Dataset : TDataSet) : Boolean;
    class function DeletePessoa(id : Integer) : Boolean;
  end;

implementation

{ TControllerPessoa }

constructor TControllerPessoa.Create;
begin
  inherited Create;
  DaoPessoa := TDAOPessoa.Create;
end;

class function TControllerPessoa.DeletePessoa(id: Integer): Boolean;
begin
  Result := DaoPessoa.Delete(id);
end;

destructor TControllerPessoa.Destroy;
begin
  FreeAndNil(DaoPessoa);
  inherited Destroy;
end;

class function TControllerPessoa.ExistePessoa(Dataset: TDataSet): Boolean;
begin
  Result := Dataset.RecordCount > 0;
end;

class function TControllerPessoa.GetController: TControllerPessoa;
begin
  if not(Assigned(Controller)) then
    Controller := TControllerPessoa.Create;
  Result := Controller;
end;

class function TControllerPessoa.GetPessoas(Where : string = '') : TDataset;
begin
  Result := DaoPessoa.Select(where);
end;

class function TControllerPessoa.SavePessoa(Pessoa: TDTOPessoa): Integer;     
begin   
  Result := 0;  
  
  if (Pessoa.ID > 0) then
    Result := DaoPessoa.Update(Pessoa)
  else
    Result := DaoPessoa.Insert(Pessoa);  
end;

class function TControllerPessoa.ValidateInsert(
  Pessoa: TDTOPessoa): Boolean;
begin
  Result := False;

  if (Pessoa.Nome.IsEmpty) then
    raise Exception.Create('Informe o nome da pessoa antes de continuar!');

  if (Pessoa.CPF.IsEmpty) then
    raise Exception.Create('Informe o CPF antes de continuar!');

  Result := True;
end;

end.
