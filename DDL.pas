unit DDL;

interface

uses
  FireDAC.Comp.Client, System.SysUtils;


type
  TDDL = class
  private

  public
    constructor Create(Conexao : TFDConnection);
    destructor Destroy; override;

    procedure ExecutaSQL(vSQL : String);

    procedure createTable(AName : String; AFields : TArray<String>);

    procedure addField(ATable, AField, AType : String; ADefault: String = '');
    procedure addIndex(AName, ATable, AField, AType : String);

    procedure DropField(ATable, AField : String);

    var
      AQuery : TFDQuery;
end;


implementation

uses
  System.StrUtils;

{ TDDL }

procedure TDDL.addField(ATable, AField, AType : String; ADefault: String = '');
begin
  AQuery.SQL.Clear;
  AQuery.SQL.Add('select RF.RDB$FIELD_NAME ');
  AQuery.SQL.Add('from rdb$relation_fields RF ');
  AQuery.SQL.Add('where RF.rdb$relation_name = '''+ATable+''' AND ');
  AQuery.SQL.Add('RF.RDB$FIELD_NAME = '''+AField+''' ');
  AQuery.Open();
  if AQuery.IsEmpty then
    begin
      AQuery.SQL.Clear;
      AQuery.SQL.Add('ALTER TABLE ' +ATable+  ' ADD ' +AField+ ' ' +AType+ ' '  +IfThen(ADefault <> EmptyStr,'DEFAULT '+ADefault,EmptyStr));
      AQuery.ExecSQL;

      if ADefault <> EmptyStr then
        begin
          AQuery.SQL.Clear;
          AQuery.SQL.Add('UPDATE ' +ATable+  ' SET ' +AField+ ' = ' + ADefault);
          AQuery.ExecSQL;
        end;
    end;
end;

procedure TDDL.addIndex(AName, ATable, AField,
  AType: String);
begin
  AQuery.Close;
  AQuery.SQL.Clear;
  AQuery.SQL.Add('select ri.RDB$INDEX_NAME ');
  AQuery.SQL.Add('from RDB$INDICES ri ');
  AQuery.SQL.Add('WHERE ri.RDB$INDEX_NAME = '''+AName+''' AND ri.RDB$RELATION_NAME = '''+ATable+'''');
  AQuery.Open();
  if AQuery.IsEmpty then
    begin
      AQuery.SQL.Clear;
      AQuery.SQL.Add('CREATE '+AType+' INDEX '+AName+' ON '+ATable+' ('+AField+')');
      AQuery.ExecSQL;
    end;
end;

destructor TDDL.Destroy;
begin
  FreeAndNil(AQuery);
  inherited;
end;

procedure TDDL.DropField(ATable, AField : String);
begin
  AQuery.Close;
  AQuery.SQL.Clear;
  AQuery.SQL.Add('select RF.RDB$FIELD_NAME ');
  AQuery.SQL.Add('from rdb$relation_fields RF ');
  AQuery.SQL.Add('where RF.rdb$relation_name = '''+ATable+''' AND ');
  AQuery.SQL.Add('RF.RDB$FIELD_NAME = '''+AField+''' ');
  AQuery.Open();
  if not AQuery.IsEmpty then
    begin
      AQuery.SQL.Clear;
      AQuery.SQL.Add('ALTER TABLE ' +ATable+  ' DROP ' +AField);
      AQuery.ExecSQL;
    end;
end;

procedure TDDL.ExecutaSQL(vSQL: String);
begin
  AQuery.SQL.Clear;
  AQuery.SQL.Add(vSQL);
  AQuery.ExecSQL;
end;

constructor TDDL.Create(Conexao : TFDConnection);
begin
  AQuery            := TFDQuery.Create(nil);
  AQuery.Connection := Conexao;
end;

procedure TDDL.createTable(AName: String; AFields: TArray<String>);
var
  ALinha : String;
begin
  AQuery.Close;
  AQuery.SQL.Clear;
  AQuery.SQL.Add('select RR.RDB$RELATION_NAME');
  AQuery.SQL.Add('from RDB$RELATIONS RR');
  AQuery.SQL.Add('WHERE RR.RDB$RELATION_NAME = '''+AName+'''');
  AQuery.Open();
  if AQuery.IsEmpty then
  begin
    AQuery.SQL.Clear;
    AQuery.SQL.Add('CREATE TABLE '+AName+' (');
    for ALinha in AFields do
    begin
      AQuery.SQL.Add(ALinha);
    end;
    AQuery.SQL.Add(')');
    AQuery.ExecSQL;
  end;
end;

end.
