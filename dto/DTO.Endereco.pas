unit DTO.Endereco;

interface

type
  TDTOEndereco = class
  private
    FLogradouro: string;
    FBairro: string;
    FCEP: string;
    FID: Integer;
    FNumero: string;
    FComplemento: string;
    FCidade: string;
    FEstado: string;
    FTipoEndereco: string;
    FID_Pessoa: Integer;
  public
    property ID : Integer read FID write FID;
    property TipoEndereco : string read FTipoEndereco write FTipoEndereco;
    property CEP : string read FCEP write FCEP;
    property Logradouro : string read FLogradouro write FLogradouro;
    property Numero : string read FNumero write FNumero;
    property Complemento : string read FComplemento write FComplemento;
    property Bairro : string read FBairro write FBairro;
    property Cidade : string read FCidade write FCidade;
    property Estado : string read FEstado write FEstado;
    property ID_Pessoa : Integer read FID_Pessoa write FID_Pessoa;
    procedure Clear;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TDTOEndereco }

{ TDTOEndereco }

procedure TDTOEndereco.Clear;
begin
  FID := 0;
  FTipoEndereco := '';
  FCEP := '';
  FLogradouro := '';
  FNumero := '';
  FComplemento := '';
  FBairro := '';
  FCidade := '';
  FEstado := '';
  FID_Pessoa := 0;
end;

constructor TDTOEndereco.Create;
begin
  inherited Create;
  FID := 0;
  FTipoEndereco := '';
  FCEP := '';
  FLogradouro := '';
  FNumero := '';
  FComplemento := '';
  FBairro := '';
  FCidade := '';
  FEstado := '';
  FID_Pessoa := 0;
end;

destructor TDTOEndereco.Destroy;
begin
  inherited Destroy;
end;

end.
