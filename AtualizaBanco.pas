unit AtualizaBanco;

interface

uses
  FireDAC.Comp.Client, Vcl.Forms, System.SysUtils, RTTI, Versoes;


type
  TAtualiza = class
  private
    FConexao : TFDConnection;
    procedure InsereVersao(vVersao : String);
    function  VersaoPendente(vVersao : String) : Boolean;
  public
    procedure AtualizaBancoDeDados;
    constructor Create(Conexao : TFDConnection);
    destructor Destroy; override;
  var
    AQuery : TFDQuery;
end;


implementation

uses
  System.StrUtils;

{ TAtualiza }

procedure TAtualiza.AtualizaBancoDeDados;
var
  Versoes : TVersoes;
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Metodo: TRttiMethod;
  AStrVersao : String;
begin

  Versoes                := TVersoes.Create(FConexao);

  try
    Tipo := Contexto.GetType(Versoes.ClassInfo);
    for Metodo in Tipo.GetDeclaredMethods do
      begin
        if Metodo.Name <> 'Create' then
          begin
            AStrVersao := StringReplace(Metodo.Name,'_','.',[rfReplaceAll]);
            AStrVersao := StringReplace(AStrVersao,'Versao',EmptyStr,[rfReplaceAll]);
            if VersaoPendente(AStrVersao) then
              begin
                try
                  Metodo.Invoke(Versoes,[]);
                  InsereVersao(AStrVersao);
                except
                on E: Exception do
                  Raise exception.Create('ERRO AO ATUALIZAR A VERSÃO '+Metodo.Name+' DO BANCO DE DADOS!');
                end;
              end;
          end;
      end;
  finally
    FreeAndNil(Versoes);
  end;
end;

constructor TAtualiza.Create(Conexao : TFDConnection);
begin
  FConexao          := Conexao;
  AQuery            := TFDQuery.Create(nil);
  AQuery.Connection := Conexao;
end;

destructor TAtualiza.Destroy;
begin
  FreeAndNil(AQuery);
  inherited;
end;


procedure TAtualiza.InsereVersao(vVersao: String);
begin
  AQuery.SQL.Clear;
  AQuery.SQL.Add('INSERT INTO VERSAO_BANCO (VERSAO) VALUES (:VERSAO)');
  AQuery.ParamByName('VERSAO').AsString := vVersao;
  AQuery.ExecSQL();
end;

function TAtualiza.VersaoPendente(vVersao : String) : Boolean;
begin
  AQuery.SQL.Clear;
  AQuery.SQL.Add('SELECT ID FROM VERSAO_BANCO WHERE VERSAO = :VERSAO');
  AQuery.ParamByName('VERSAO').AsString := vVersao;
  AQuery.Open;
  Result := AQuery.IsEmpty;
end;


end.
