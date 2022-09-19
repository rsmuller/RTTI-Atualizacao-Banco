unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.IBBase, FireDAC.Dapt;

type
  TfPrincipal = class(TForm)
    btnAtualizaBanco: TButton;
    Conexao: TFDConnection;
    lStatus: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAtualizaBancoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

{$R *.dfm}

uses AtualizaBanco;

procedure TfPrincipal.btnAtualizaBancoClick(Sender: TObject);
var
  Atualiza : TAtualiza;
begin
  lStatus.Caption := 'Atualizando banco de dados, aguarde...';
  Application.ProcessMessages;
  Conexao.Connected := True;
  Atualiza := TAtualiza.Create(Conexao);
  try
    Atualiza.AtualizaBancoDeDados;
    lStatus.Caption := 'Banco de dados atualizado com sucesso!';
    Application.ProcessMessages;
  finally
    FreeAndNil(Atualiza);
  end;
end;

procedure TfPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
