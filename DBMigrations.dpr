program DBMigrations;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  DBmigrations.Connection in 'DBmigrations.Connection.pas',
  DBmigrations.ConnectionParams in 'DBmigrations.ConnectionParams.pas',
  DBmigrations.DatabaseScheemas in 'DBmigrations.DatabaseScheemas.pas',
  DBmigrations.DBQuery in 'DBmigrations.DBQuery.pas',
  DBmigrations.Entity in 'DBmigrations.Entity.pas',
  DBmigrations.Interactions in 'DBmigrations.Interactions.pas',
  DBmigrations.Interfaces in 'DBmigrations.Interfaces.pas',
  DBmigrations.Migrations in 'DBmigrations.Migrations.pas',
  DBmigrations.Settings in 'DBmigrations.Settings.pas';

function SettingsInitialized: Boolean;
var
  sOk: Boolean;
  FSett: TSettings;
begin
  FSett := TSettings.Create;
  try
    sOk := FSett.FileInitialized;
  finally
    FSett.Free;
  end;

  Result := sOk;
end;

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

      if SettingsInitialized then
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

      Writeln(' ');
      Writeln('  --types. Write to see all drivers db');
    end;

    if ParamStr(1) = '--create' then
    begin
      if ParamStr(2) <> '' then
      begin
        TMigrations.New.CreateMigration(ParamStr(2));
        Writeln(' ');
        Writeln('  Migration Created');
        Exit;
      end;

      Writeln(' ');
      Writeln('  In second param type name of migration, please do not use special chars');
    end;

    if ParamStr(1) = '--run' then
    begin
      if not SettingsInitialized then
      begin
        Writeln(' ');
        Writeln('  Migrations not initialized.');
        Exit;
      end;

      TMigrations.New.RunMigrations;
      Writeln(' ');
      Writeln(' Migrations Runned');
    end;

  end
  else
  begin
    Writeln('Write --help to see options');
  end;

end.
