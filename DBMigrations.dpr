program DBMigrations;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  DBmigrations.Interactions in 'DBmigrations.Interactions.pas',
  DBmigrations.Interfaces in 'DBmigrations.Interfaces.pas',
  DBmigrations.Settings in 'DBmigrations.Settings.pas',
  DBmigrations.ConnectionParams in 'DBmigrations.ConnectionParams.pas',
  DBmigrations.Connection in 'DBmigrations.Connection.pas';

begin
  Writeln('Welcome DBMigrations 1.0');

  if ParamCount > 0 then
  begin

    if ParamStr(1).ToLower = '--help' then
    begin
      Writeln(' ');
      Writeln('  --types  To see drivers db');
      Writeln(' ');
      Writeln('  --init --drivedb  To start manager DBMigrations');
      Writeln(' ');
      Writeln('  --new To Create migration file');
      Writeln(' ');
      Writeln('  --run Apply Migrations');
      Writeln(' ');
      Exit;
    end;

    if ParamStr(1).ToLower = '--types' then
    begin
      Writeln(' ');
      Writeln('  -fb  To FIREBIRD Databases');
      Writeln(' ');
      Writeln('  -sqlite  To SQLITE Databases');
    end;

    if ParamStr(1).ToLower = '--init' then
    begin
      if ParamCount = 1 then
      begin
        Writeln(' ');
        Writeln('  --types. Write to see all drivers db');
        Exit;
      end;

      if TConfigManager.New.HasSettings then
      begin
        Writeln('Already initializated migrations.');
        Exit;
      end;

      if ParamStr(2).ToLower = 'fb' then
      begin
        TConnectionParams.New(dtFirebird).SaveToSettings;
        Writeln('Migrations to Drive FIREBIRD has created');
        Exit;
      end;

      if ParamStr(2).ToLower = 'sqlite' then
      begin
        TConnectionParams.New(dtSQLite).SaveToSettings;
        Writeln('Migrations to Drive SQLITE has created');
        Exit;
      end;

      // Se chegar aqui e pq n�o o parametro n�o foi informado corretamente
      Writeln(' ');
      Writeln('  --types. Write to see all drivers db');
    end;

  end
  else
  begin
    Writeln('Write --help to see options');
  end;

end.
