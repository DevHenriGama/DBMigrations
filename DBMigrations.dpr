program DBMigrations;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  DBmigrations.Interactions in 'DBmigrations.Interactions.pas',
  DBmigrations.Interfaces in 'DBmigrations.Interfaces.pas',
  DBmigrations.Settings in 'DBmigrations.Settings.pas',
  DBmigrations.DBConnection in 'DBmigrations.DBConnection.pas';

begin
  Writeln('Welcome DBMigrations 1.0');

  if ParamCount > 0 then
  begin

    if ParamStr(1).ToLower = '--help' then
    begin
      Writeln('--init  To start manager DBMigrations');
      Writeln('--new To Create migration file');
      Writeln('--run Apply Migrations');
      Exit;
    end;

    if ParamStr(1).ToLower = '--init' then
    begin

    end;

  end
  else
  begin
    Writeln('Write --help to see options');
  end;

end.
