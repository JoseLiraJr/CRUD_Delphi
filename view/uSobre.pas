unit uSobre;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TfrmSobre = class(TForm)
    pnBottom: TPanel;
    pnSobre: TPanel;
    lbCaptionTecnologias: TLabel;
    lbTecnologias: TLabel;
    lbCaptionArquitetura: TLabel;
    lbArquitetura: TLabel;
    lbCaptionDesenvolvedor: TLabel;
    lbDesenvolvedor: TLabel;
    Bevel1: TBevel;
    btnFechar: TBitBtn;
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSobre: TfrmSobre;

implementation

uses
  Utils.Geral;

{$R *.dfm}

procedure TfrmSobre.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSobre.FormCreate(Sender: TObject);
begin
  lbTecnologias.Caption := SOBRE_TECNOLOGIAS;
  lbArquitetura.Caption := SOBRE_ARQUITETURA;
  lbDesenvolvedor.Caption := SOBRE_DESENVOLVEDOR;
end;

end.
