program DBMigrationTool;

uses
  System.StartUpCopy,
  FMX.Forms,
  MigrationTool in 'MigrationTool.pas' {frmTool};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTool, frmTool);
  Application.Run;
end.
