unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TfrmPrincipal = class(TForm)
    stbPrincipal: TStatusBar;
    pnBotoes: TPanel;
    bvlPrincipal: TBevel;
    ImgPessoa: TImage;
    ImgDatabase: TImage;
    ImgSobre: TImage;
    ImgEncerrar: TImage;
    pnWorkArea: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ImgEncerrarClick(Sender: TObject);
    procedure ImgPessoaClick(Sender: TObject);
    procedure ImgSobreClick(Sender: TObject);
    procedure ImgDatabaseClick(Sender: TObject);
  private
    { Private declarations }
    FFormActive: TForm;
    procedure LoadForm(AClass: TFormClass);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  Utils.Geral, uPessoa, uSobre, Controller.Conexao;

{$R *.dfm}

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (Application.MessageBox('Deseja realmente encerrar Sistema?', 'Encerrar Aplicação', MB_ICONQUESTION + MB_YESNO) = mrYes) then
    Action := caFree
  else
    Action := caNone;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  stbPrincipal.Panels[0].Text :=Application.Title + '  [Local do EXE: ' + Application.ExeName + ']';
  stbPrincipal.Panels[1].Text := TUtilsGeral.dayOfWeek + ', ' + TUtilsGeral.dataExtenso;
end;

procedure TfrmPrincipal.ImgDatabaseClick(Sender: TObject);
begin
  if TControllerConexao.CreateData then
    Application.MessageBox('Base de Dados criada com Sucesso!', 'Sucesso', MB_OK + MB_ICONINFORMATION)
  else
    Application.Terminate;
end;

procedure TfrmPrincipal.ImgEncerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.ImgPessoaClick(Sender: TObject);
begin
  if (TControllerConexao.VerificaBanco) then
    LoadForm(TfrmPessoa)
  else
    Application.MessageBox('O banco de dados da aplicação não existe! ' + sLineBreak +
                           'Clique no botão do Banco de dados para criação da base antes de tentar realizar um cadastro.',
                           'Erro de base de dados', MB_OK + MB_ICONWARNING);
end;

procedure TfrmPrincipal.ImgSobreClick(Sender: TObject);
begin
  LoadForm(TfrmSobre);
end;

procedure TfrmPrincipal.LoadForm(AClass: TFormClass);
begin
  if Assigned(FFormActive) then
  begin
    FFormActive.Close;
    FFormActive.Free;
    FFormActive := nil;
  end;

  FFormActive             := AClass.Create(nil);
  FFormActive.Parent      := Self.pnWorkArea;
  FFormActive.BorderStyle := TFormBorderStyle.bsNone;
  FFormActive.Top   := 0;
  FFormActive.Left  := 0;
  FFormActive.Align := TAlign.alClient;
  FFormActive.Show;
end;

end.
