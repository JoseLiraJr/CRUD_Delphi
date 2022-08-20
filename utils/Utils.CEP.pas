unit Utils.CEP;

interface

uses
  System.SysUtils, System.JSON, IdHTTP, IdSSLOpenSSL, System.Classes,
  DTO.Endereco;

type
  TUtilsCep = Class
  private
    function ConsultaCEP(Cep : string) : TJSONObject;
    function GetJsonCEP(Cep : string) : TJSONObject;
  public
    procedure ConsultarCEP(var Endereco : TDTOEndereco);
    constructor Create;
    destructor Destroy; override;
  End;

implementation

{ TUtilsCep }

function TUtilsCep.ConsultaCEP(Cep: string): TJSONObject;
var
  idHTTP: TIdHTTP;
  idHandler : TIdSSLIOHandlerSocketOpenSSL;
  Response: TStringStream;
  cepJson: TJSONObject;
begin
  idHTTP := TIdHTTP.Create;
  idHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
  Response := TStringStream.Create('');
  try
    idHTTP.IOHandler := idHandler;

    idHTTP.Get('https://viacep.com.br/ws/' + Cep + '/json', Response);
    if (idHTTP.ResponseCode = 200) and not(Utf8ToAnsi(Response.DataString) = '{'#$A'  "erro": true'#$A'}') then
      cepJson := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes( Utf8ToAnsi(Response.DataString)), 0) as TJSONObject;
    Result := cepJson;
  finally
   FreeAndNil(idHTTP);
   FreeAndNil(idHandler);
   FreeAndNil(Response);
  end;
end;

procedure TUtilsCep.ConsultarCEP(var Endereco: TDTOEndereco);
var
  cepJson: TJSONObject;
begin
  if (Endereco.CEP.Length < 8) then
    raise Exception.Create('CEP Inválido ou Imcompleto!');

  cepJson := GetJsonCEP(Endereco.CEP);

  if (cepJson = nil) then
    raise Exception.Create('A consulta no webservice não retornou um endereço válido!');

  //Preenche o objeto do endereço com o retorno do webservice.
  with Endereco do
  begin
    Logradouro := cepJson.Get('logradouro').JsonValue.Value;
    Complemento := cepJson.Get('complemento').JsonValue.Value;
    Bairro := cepJson.Get('bairro').JsonValue.Value;
    Cidade := cepJson.Get('localidade').JsonValue.Value;
    Estado := cepJson.Get('uf').JsonValue.Value;
  end;
end;

constructor TUtilsCep.Create;
begin
  inherited Create;
end;

destructor TUtilsCep.Destroy;
begin
  inherited Destroy;
end;

function TUtilsCep.GetJsonCEP(Cep: string): TJSONObject;
var
  idHTTP: TIdHTTP;
  idHandler : TIdSSLIOHandlerSocketOpenSSL;
  Response: TStringStream;
begin
  idHTTP := TIdHTTP.Create;
  idHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
  Response := TStringStream.Create('');
  try
    idHandler.SSLOptions.Method := sslvTLSv1_2;
    idHTTP.IOHandler := idHandler;

    idHTTP.Get('https://viacep.com.br/ws/' + Cep + '/json', Response);
    if (idHTTP.ResponseCode = 200) and (Pos('"erro": "true"', Response.DataString) = 0) then
      Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes( Utf8ToAnsi(Response.DataString)), 0) as TJSONObject
    else
      Result := nil;
  finally
   FreeAndNil(idHTTP);
   FreeAndNil(idHandler);
   FreeAndNil(Response);
  end;
end;

end.
