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
    procedure Initialize;
    procedure CreateDatabase;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IMigrations;
    procedure RunMigrations;
    procedure CreateMigration;
  end;

function Migrations: IMigrations;

implementation

uses
  System.SysUtils, DBmigrations.Connection, System.Classes;

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

  CreateDatabase;
  Initialize;
end;

procedure TMigrations.CreateDatabase;
var
  Connection: IConnection;
begin
  if FileExists(DBPath) then
    Exit;

  Connection := TConnection.New(MigrationParams);
  Connection.CreateMigrationDatabase(DBPath);

  with DBQuery(Connection).Query do
  begin
    SQL.AddStrings(DBScheemas.MigrationDatabaseScheema);
    ExecSQL;
  end;

end;

procedure TMigrations.CreateMigration;
begin

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

class function TMigrations.New: IMigrations;
begin
  Result := Self.Create;
end;

procedure TMigrations.RunMigrations;
begin
  TConnection.New(MigrationParams).TestConnection;
end;

end.
