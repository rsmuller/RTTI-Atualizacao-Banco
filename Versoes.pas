unit Versoes;

interface

uses
  FireDAC.Comp.Client, System.SysUtils,System.StrUtils,System.Classes, DDL;

type
  TVersoes = class
  private
    destructor Destroy; override;
  public
    constructor Create(Conexao : TFDConnection);

    procedure Versao001_001_001;
    procedure Versao001_002_001;
    procedure Versao001_002_002;

    var
      AQuery, AConsulta : TFDQuery;
      DDL : TDDL;
end;

implementation

{ TVersoes }

constructor TVersoes.Create(Conexao: TFDConnection);
begin
  AQuery            := TFDQuery.Create(nil);
  AQuery.Connection := Conexao;

  AConsulta            := TFDQuery.Create(nil);
  AConsulta.Connection := Conexao;

  DDL                  := TDDL.Create(Conexao);
end;

destructor TVersoes.Destroy;
begin
  FreeAndNil(AQuery);
  FreeAndNil(AConsulta);
  FreeAndNil(DDL);
  inherited;
end;

procedure TVersoes.Versao001_001_001;
begin
  DDL.createTable('TESTE',
                  ['ID INTEGER NOT NULL PRIMARY KEY,',
                  'DESCRICAO VARCHAR(80)'
                  ]);
end;

procedure TVersoes.Versao001_002_001;
begin
  DDL.addField('TESTE','ATIVO1','CHAR(1)','''F''');
  DDL.addField('TESTE','ATIVO2','CHAR(1)','''F''');
end;
procedure TVersoes.Versao001_002_002;
begin
  DDL.DropField('TESTE','ATIVO2');
end;


end.
