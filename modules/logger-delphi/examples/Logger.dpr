program Logger;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmLog},
  Logger.CORE in '..\src\Logger.CORE.pas',
  Logger.Interfaces in '..\src\Logger.Interfaces.pas',
  Logger.Log in '..\src\Logger.Log.pas',
  Logger.Types in '..\src\Logger.Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLog, frmLog);
  Application.Run;
end.
