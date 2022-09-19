program RttiAtualizaBanco;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {fPrincipal},
  AtualizaBanco in 'AtualizaBanco.pas',
  Versoes in 'Versoes.pas',
  DDL in 'DDL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
