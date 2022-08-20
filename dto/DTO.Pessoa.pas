unit DTO.Pessoa;

interface

uses
  System.SysUtils, DTO.Endereco;

type
  TDTOPessoa = class
  private
    FRG: string;
    FPai: string;
    FCPF: string;
    FID: Integer;
    FNome: string;
    FMae: string;
    FEndereco: TDTOEndereco;
  public
    property ID : Integer read FID write FID;
    property Nome : string read FNome write FNome;
    property CPF : string read FCPF write FCPF;
    property RG : string read FRG write FRG;
    property Pai : string read FPai write FPai;
    property Mae : string read FMae write FMae;
    property Endereco : TDTOEndereco read FEndereco write FEndereco;
    procedure Clear;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TTDOPessoa }



{ TTDOPessoa }

procedure TDTOPessoa.Clear;
begin
  FID := 0;
  FNome := '';
  FCPF := '';
  FPai := '';
  FMae := '';
end;

constructor TDTOPessoa.Create;
begin
  inherited Create;
  FID := 0;
  FNome := '';
  FCPF := '';
  FPai := '';
  FMae := '';
  FEndereco := TDTOEndereco.Create;
end;

destructor TDTOPessoa.Destroy;
begin
  FreeAndNil(FEndereco);
  inherited Destroy;
end;



end.
