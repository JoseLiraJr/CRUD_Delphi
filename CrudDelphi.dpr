program CrudDelphi;

uses
  Vcl.Forms,
  uPrincipal in 'view\uPrincipal.pas' {frmPrincipal},
  Vcl.Themes,
  Vcl.Styles,
  DTO.Pessoa in 'dto\DTO.Pessoa.pas',
  DTO.Endereco in 'dto\DTO.Endereco.pas',
  Controller.Conexao in 'controller\Controller.Conexao.pas',
  uDmPrincipal in 'model\uDmPrincipal.pas' {dmPrincipal: TDataModule},
  Utils.Geral in 'utils\Utils.Geral.pas',
  uPessoa in 'view\uPessoa.pas' {frmPessoa},
  uSobre in 'view\uSobre.pas' {frmSobre},
  Utils.CEP in 'utils\Utils.CEP.pas',
  DAO.Pessoa in 'dao\DAO.Pessoa.pas',
  Controller.Pessoa in 'controller\Controller.Pessoa.pas',
  Controller.Endereco in 'controller\Controller.Endereco.pas',
  DAO.Endereco in 'dao\DAO.Endereco.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Luna');
  Application.Title := 'Crud - Delphi';
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmSobre, frmSobre);
  Application.Run;
end.
