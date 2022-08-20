unit uPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.ComCtrls,
  Datasnap.DBClient, DTO.Endereco, DTO.Pessoa;

type
  TfrmPessoa = class(TForm)
    pnTop: TFlowPanel;
    btnInserir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnFechar: TBitBtn;
    pgcPessoa: TPageControl;
    tabConsulta: TTabSheet;
    GroupBox1: TGroupBox;
    btnLocalizar: TSpeedButton;
    rbNome: TRadioButton;
    edtLocalizar: TEdit;
    rbCPF: TRadioButton;
    grdConsulta: TDBGrid;
    tabCadastro: TTabSheet;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    gbEndereco: TGroupBox;
    Label4: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edtNome: TEdit;
    edtCPF: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    edtRG: TEdit;
    edtPai: TEdit;
    Label5: TLabel;
    edtMae: TEdit;
    cbUF: TComboBox;
    cbTipoEndereco: TComboBox;
    edtCEP: TEdit;
    btnCEP: TSpeedButton;
    edtLogradouro: TEdit;
    edtNumero: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    grdEndereco: TDBGrid;
    cdsEndereco: TClientDataSet;
    cdsEnderecoLOGRADOURO: TStringField;
    cdsEnderecoNUMERO: TStringField;
    cdsEnderecoCOMPLEMENTO: TStringField;
    cdsEnderecoBAIRRO: TStringField;
    cdsEnderecoCIDADE: TStringField;
    cdsEnderecoUF: TStringField;
    cdsEnderecoCEP: TStringField;
    dsEndereco: TDataSource;
    btnAddEndereco: TSpeedButton;
    btnRemoveEndereco: TSpeedButton;
    cdsEnderecoTIPOENDERECO: TStringField;
    cdsPessoa: TClientDataSet;
    dsPessoa: TDataSource;
    cdsPessoaID: TIntegerField;
    cdsPessoaNOME: TStringField;
    cdsPessoaCPF: TStringField;
    cdsPessoaRG: TStringField;
    cdsPessoaPAI: TStringField;
    cdsPessoaMAE: TStringField;
    procedure pgcPessoaChanging(Sender: TObject; var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCEPClick(Sender: TObject);
    procedure edtNumbersKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnAddEnderecoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRemoveEnderecoClick(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure grdConsultaDblClick(Sender: TObject);
  private
    { Private declarations }
    Endereco : TDTOEndereco;
    Pessoa : TDTOPessoa;
    procedure Habilita;
    procedure Desabilita;
    procedure SetEnderecoToComponentes;
    procedure SetComponentesToEndereco;
    procedure SetComponentesToPessoa;
    procedure SetPessoaToComponentes;
    procedure SetDatasetToPessoa;
  public
    { Public declarations }
  end;

var
  frmPessoa: TfrmPessoa;

implementation

uses
  Utils.Geral, Utils.CEP, Controller.Endereco, Controller.Pessoa;

{$R *.dfm}

procedure TfrmPessoa.btnAddEnderecoClick(Sender: TObject);
begin
  try
    SetComponentesToEndereco;

    if (TControllerEndereco.ValidateInsert(Endereco)) then
    begin
      TControllerEndereco.InsertEnderecoDataset(Endereco, dsEndereco.DataSet);
      TUtilsGeral.ClearEditors(gbEndereco);
    end;
  except
    on e: exception do
      raise Exception.Create('Erro adicionar o endereço da pessoa: ' + e.Message);
  end;
end;

procedure TfrmPessoa.btnAlterarClick(Sender: TObject);
begin
  try
    //Verifica se tem algum registro a ser alterado.
    if not(TControllerPessoa.GetController.ExistePessoa(dsPessoa.DataSet)) then
    begin
      Application.MessageBox('Nenhum registo para ser alterado!', 'Sucesso', MB_OK + MB_ICONWARNING);
      Exit;
    end;

    SetDatasetToPessoa;
    SetPessoaToComponentes;
    TControllerEndereco.GetController.GetEnderecos(dsPessoa.DataSet.FieldByName('ID').AsInteger,
                                                   dsEndereco.DataSet);
    Desabilita;
  except
    on e : Exception do
      raise Exception.Create('Erro ao alterar o cadastro de pessoa: ' + e.Message);
  end;
end;

procedure TfrmPessoa.btnCancelarClick(Sender: TObject);
begin
  //Ao cancelar limpa os campos e os objetos e retorna para aba consulta;
  try
    TUtilsGeral.ClearEditors(gbEndereco);
    TUtilsGeral.ClearEditors(tabCadastro);
    cdsEndereco.EmptyDataSet;
    Habilita;
    Pessoa.Clear;
    Endereco.Clear;
  except
    on e : Exception do
      raise Exception.Create('Erro ao cancelar o cadastro de pessoa: ' + e.Message);
  end;
end;

procedure TfrmPessoa.btnCEPClick(Sender: TObject);
var
  ConsultaCep : TUtilsCep;
begin
  ConsultaCep := TUtilsCep.Create;
  try
    Endereco.CEP := edtCEP.Text;
    //Método de consulta do CEP: Recebe o objeto como Endereço paramêtro e devolve o mesmo preenchido.
    ConsultaCep.ConsultarCEP(Endereco);

    //Passando o endereço para os edits.
    SetEnderecoToComponentes;
  finally
    FreeAndNil(ConsultaCep);
  end;
end;

procedure TfrmPessoa.btnConfirmarClick(Sender: TObject);
var
  idPessoa, idEndereco : Integer;
  ExisteEndereco : Boolean;
begin
  try
    SetComponentesToPessoa;
    if (TControllerPessoa.GetController.ValidateInsert(Pessoa)) then
    begin
      ExisteEndereco := TControllerEndereco.GetController.ExisteEndereco(dsEndereco.DataSet);
      if not(ExisteEndereco) then
      begin
        if (Application.MessageBox('Não foi informado o endereço deseja continuar mesmo assim?',
                             'Endereço não informado', MB_YESNO + MB_ICONQUESTION) <> mrYes) then
          Exit;
      end;

      idPessoa := TControllerPessoa.GetController.SavePessoa(Pessoa);

      if (ExisteEndereco) then
      begin
        Endereco.ID_Pessoa := idPessoa;

        dsEndereco.DataSet.First;
        while not(dsEndereco.DataSet.Eof) do
        begin
          idEndereco := TControllerEndereco.GetController.SaveEndereco(Endereco);
          dsEndereco.DataSet.Next;
        end;

        if (idEndereco > 0) then
          Application.MessageBox('Registro gravado com sucesso!', 'Sucesso', MB_OK + MB_ICONINFORMATION);
      end
      else
      if (idPessoa > 0) then
        Application.MessageBox('Registro gravado com sucesso!', 'Sucesso', MB_OK + MB_ICONINFORMATION);

      Habilita;
      //Limpando os Objetos;
      Pessoa.Clear;
      Endereco.Clear;
      //Atualizando o grid com os dados do cadastro
      dsPessoa.DataSet := TControllerPessoa.GetController.GetPessoas;
    end;
  except
    on e : Exception do
      raise Exception.Create('Erro ao gravar a pessoa: ' + e.Message);
  end;
end;

procedure TfrmPessoa.btnExcluirClick(Sender: TObject);
begin
  try
    if not(TControllerPessoa.GetController.ExistePessoa(dsPessoa.DataSet)) then
    begin
      Application.MessageBox('Nenhum registo para ser excluido!', 'Sucesso', MB_OK + MB_ICONWARNING);
      Exit;
    end;

    if (Application.MessageBox('Deseja realmente excluir o registro?', 'Exclusão', MB_YESNO + MB_ICONQUESTION) = mrYes) then
    begin
      //Exclui primeiro os endereços e só em caso de sucesso exclui a pessoa.
      if not(TControllerEndereco.GetController.DeleteEndereco(dsPessoa.DataSet.FieldByName('ID').AsInteger)) then
        Abort;

      if not(TControllerPessoa.GetController.DeletePessoa(dsPessoa.DataSet.FieldByName('ID').AsInteger)) then
        Abort;

      //Atualizando o grid com os dados do cadastro
      dsPessoa.DataSet := TControllerPessoa.GetController.GetPessoas;
    end;
  except
    on e : Exception do
      raise Exception.Create('Erro ao excluir o cadastro de pessoa: ' + e.Message);
  end;
end;

procedure TfrmPessoa.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPessoa.btnInserirClick(Sender: TObject);
begin
  Desabilita;
end;

procedure TfrmPessoa.btnLocalizarClick(Sender: TObject);
begin
  if (edtLocalizar.Text = EmptyStr) then
    dsPessoa.DataSet := TControllerPessoa.GetController.GetPessoas
  else
    dsPessoa.DataSet := TControllerPessoa.GetController.GetPessoas(
                             TUtilsGeral.ifthen<string>(rbNome.Checked,
                             'WHERE NOME LIKE '+ QuotedStr('%'+ edtLocalizar.Text),
                             'WHERE CPF = ' + QuotedStr(edtLocalizar.Text)));
end;

procedure TfrmPessoa.btnRemoveEnderecoClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja realmente excluir o endereço?', 'Exclusão', MB_YESNO + MB_ICONQUESTION) = mrYes) then
    dsEndereco.DataSet.Delete;
end;

procedure TfrmPessoa.Desabilita;
begin
  TUtilsGeral.EnableControls(pnTop, False);
  pgcPessoa.ActivePage := tabCadastro;
end;

procedure TfrmPessoa.edtNumbersKeyPress(Sender: TObject; var Key: Char);
begin
  if not(TUtilsGeral.CharNumbers(Key)) then
    Key := #0;
end;

procedure TfrmPessoa.FormCreate(Sender: TObject);
begin
  try
    //Criando os objetos e os dataset do cadastro
    Pessoa := TDTOPessoa.Create;
    Endereco := TDTOEndereco.Create;
    cdsEndereco.CreateDataSet;
    cdsPessoa.CreateDataSet;

    //Navegando no pagecontrol
    pgcPessoa.ActivePage := tabConsulta;
  except
    on e : Exception do
      raise Exception.Create('Erro ao Criar os objetos da pessoa: ' + e.Message);
  end;
end;

procedure TfrmPessoa.FormDestroy(Sender: TObject);
begin
  try
    FreeAndNil(Endereco);
    FreeAndNil(Pessoa);
  except
    on e : Exception do
      raise Exception.Create('Erro ao destruir os objetos da pessoa: ' + e.Message);
  end;
end;

procedure TfrmPessoa.FormShow(Sender: TObject);
begin
  dsPessoa.DataSet := TControllerPessoa.GetController.GetPessoas;
end;

procedure TfrmPessoa.grdConsultaDblClick(Sender: TObject);
begin
  btnAlterar.Click;
end;

procedure TfrmPessoa.Habilita;
begin
  TUtilsGeral.EnableControls(pnTop, True);
  pgcPessoa.ActivePage := tabConsulta;
end;

procedure TfrmPessoa.pgcPessoaChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := False;
end;

procedure TfrmPessoa.SetComponentesToEndereco;
begin
  try
    Endereco.TipoEndereco := cbTipoEndereco.Text;
    Endereco.CEP := edtCEP.Text;
    Endereco.Logradouro := edtLogradouro.Text;
    Endereco.Numero := edtNumero.Text;
    Endereco.Complemento := edtComplemento.Text;
    Endereco.Bairro := edtBairro.Text;
    Endereco.Cidade := edtCidade.Text;
    Endereco.Estado := cbUF.Text;
  except
    on e : Exception do
      raise Exception.Create('Erro ao setar os dados dos componentes no endereço: ' + e.Message);
  end;
end;

procedure TfrmPessoa.SetComponentesToPessoa;
begin
  try
    Pessoa.Nome := edtNome.Text;
    Pessoa.CPF := edtCPF.Text;
    Pessoa.RG := edtRG.Text;
    Pessoa.Pai := edtPai.Text;
    Pessoa.Mae := edtMae.Text;
  except
    on e : Exception do
      raise Exception.Create('Erro ao setar os dados dos componentes na pessoa: ' + e.Message);
  end;
end;

procedure TfrmPessoa.SetDatasetToPessoa;
begin
  try
    Pessoa.ID := dsPessoa.DataSet.FieldByName('ID').AsInteger;
    Pessoa.Nome :=  dsPessoa.DataSet.FieldByName('NOME').AsString;
    Pessoa.CPF := dsPessoa.DataSet.FieldByName('CPF').AsString;
    Pessoa.RG := dsPessoa.DataSet.FieldByName('RG').AsString;
    Pessoa.Pai := dsPessoa.DataSet.FieldByName('PAI').AsString;
    Pessoa.Mae := dsPessoa.DataSet.FieldByName('MAE').AsString;
  except
    on e : Exception do
      raise Exception.Create('Erro ao setar os dados do grid na pessoa: ' + e.Message);
  end;
end;

procedure TfrmPessoa.SetEnderecoToComponentes;
begin
  try
    cbTipoEndereco.ItemIndex := cbTipoEndereco.Items.IndexOf(Endereco.TipoEndereco);
    edtCEP.Text := Endereco.CEP;
    edtLogradouro.Text := Endereco.Logradouro;
    edtNumero.Text := Endereco.Numero;
    edtComplemento.Text := Endereco.Complemento;
    edtBairro.Text := Endereco.Bairro;
    edtCidade.Text := Endereco.Cidade;
    cbUF.ItemIndex := cbUF.Items.IndexOf(Endereco.Estado);
  except
    on e : Exception do
      raise Exception.Create('Erro ao setar os dados do endereço nos componentes: ' + e.Message);
  end;
end;

procedure TfrmPessoa.SetPessoaToComponentes;
begin
  try
    edtNome.Text := Pessoa.Nome;
    edtCPF.Text := Pessoa.CPF;
    edtRG.Text := Pessoa.RG;
    edtPai.Text := Pessoa.Pai;
    edtMae.Text := Pessoa.Mae;
  except
    on e : Exception do
      raise Exception.Create('Erro ao setar os dados da pessoa nos componentes: ' + e.Message);
  end;
end;

end.
