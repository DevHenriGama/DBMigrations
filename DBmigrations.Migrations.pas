unit DBmigrations.Migrations;

interface

uses
  DBmigrations.Interfaces, DBmigrations.ConnectionParams, DBmigrations.DBQuery,
  DBmigrations.DatabaseScheemas;

type
  TMigrations = class(TInterfacedObject, IMigrations)

  private
    MigrationParams: TConnectionParams;

  const
    _DBNAME: string = 'migrations.db';
    function DBPath: String;
    function MigrationsDirPath: string;
    procedure Initialize;
    procedure CreateDatabase;
    function CreateMigrationFile(AFileName: string): string;
    function MigrationFileName(AName: string): string;
    procedure RegisterMigration(AFileName: string);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IMigrations;
    procedure RunMigrations;
    procedure CreateMigration(AName: string);
  end;

function Migrations: IMigrations;

implementation

uses
  System.SysUtils, DBmigrations.Connection, System.Classes, System.IOUtils;

{ TMigrations }

function Migrations: IMigrations;
begin
  Result := TMigrations.Create;
end;

constructor TMigrations.Create;
begin
  MigrationParams := TConnectionParams.Create;
  with MigrationParams do
  begin
    DriverID := 'SQLite';
    Database := DBPath;
  end;

  if not FileExists(DBPath) then
    CreateDatabase;

  Initialize;
end;

procedure TMigrations.CreateDatabase;
var
  Connection: IConnection;
begin
  Connection := TConnection.New(MigrationParams);
  Connection.CreateMigrationDatabase(DBPath);

  with DBQuery(Connection).Query do
  begin
    SQL.AddStrings(DBScheemas.MigrationDatabaseScheema);
    ExecSQL;
  end;
end;

procedure TMigrations.CreateMigration(AName: string);
var
  FFileName: string;
begin
  FFileName := CreateMigrationFile(AName);

  RegisterMigration(FFileName);
end;

function TMigrations.CreateMigrationFile(AFileName: string): String;
var
  FName, a: string;
begin
  FName := MigrationFileName(AFileName);

  if not DirectoryExists(MigrationsDirPath) then
    CreateDir(MigrationsDirPath);

  TFile.WriteAllText(Format('%s\%s', [MigrationsDirPath, FName]), '');

  Result := FName;
end;

function TMigrations.DBPath: String;
begin
  Result := ExtractFilePath(ParamStr(0)) + _DBNAME;
end;

destructor TMigrations.Destroy;
begin
  inherited;
  MigrationParams.Free;
end;

procedure TMigrations.Initialize;
begin
  TConnection.New(MigrationParams).TestConnection;
end;

function TMigrations.MigrationFileName(AName: string): string;
begin
  Result := Format('%s_%s.txt',
    [AName, FormatDateTime('yyyy-mm-dd_hh-nn-ss', Now)]);
end;

function TMigrations.MigrationsDirPath: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'migrations/'
end;

class function TMigrations.New: IMigrations;
begin
  Result := Self.Create;
end;

procedure TMigrations.RegisterMigration(AFileName: string);
var
  Connection: IConnection;
begin
  Connection := TConnection.New(MigrationParams);
  with DBQuery(Connection).Query do
  begin
    SQL.Add('INSERT INTO MIGRATIONS (MIGRATION_NAME) VALUES(:name)');
    ParamByName('name').AsString := AFileName;
    ExecSQL;
  end;
end;

procedure TMigrations.RunMigrations;
begin
  TConnection.New(MigrationParams).TestConnection;
end;

end.
