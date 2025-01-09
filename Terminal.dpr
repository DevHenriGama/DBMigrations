program Terminal;

uses
  Vcl.Forms,
  PASTerminal in 'PASTerminal.pas' {Form1},
  DBmigrations.ConnectionParams in 'DBmigrations.ConnectionParams.pas',
  DBmigrations.Interactions in 'DBmigrations.Interactions.pas',
  DBmigrations.Interfaces in 'DBmigrations.Interfaces.pas',
  DBmigrations.Settings in 'DBmigrations.Settings.pas',
  DBmigrations.Connection in 'DBmigrations.Connection.pas',
  DBmigrations.Migrations in 'DBmigrations.Migrations.pas',
  DBmigrations.DatabaseScheemas in 'DBmigrations.DatabaseScheemas.pas',
  DBmigrations.DBQuery in 'DBmigrations.DBQuery.pas',
  DBmigrations.Entity in 'DBmigrations.Entity.pas';

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
