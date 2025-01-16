program DBMigrationTool;

uses
  System.StartUpCopy,
  FMX.Forms,
  MigrationTool in 'MigrationTool.pas' {frmTool},
  DBmigrations.Connection in 'src\DBmigrations.Connection.pas',
  DBmigrations.ConnectionParams in 'src\DBmigrations.ConnectionParams.pas',
  DBmigrations.DatabaseScheemas in 'src\DBmigrations.DatabaseScheemas.pas',
  DBmigrations.DBQuery in 'src\DBmigrations.DBQuery.pas',
  DBmigrations.Entity in 'src\DBmigrations.Entity.pas',
  DBmigrations.Interactions in 'src\DBmigrations.Interactions.pas',
  DBmigrations.Interfaces in 'src\DBmigrations.Interfaces.pas',
  DBmigrations.Migrations in 'src\DBmigrations.Migrations.pas',
  DBmigrations.Settings in 'src\DBmigrations.Settings.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTool, frmTool);
  Application.Run;
end.
