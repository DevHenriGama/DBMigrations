unit DBmigrations.Migrations;

interface

uses
  DBmigrations.Interfaces,
  DBmigrations.ConnectionParams,
  DBmigrations.DBQuery,
  DBmigrations.DatabaseScheemas,
  System.Classes, DBmigrations.Entity, System.Generics.Collections;

type
  TMigrations = class(TInterfacedObject, IMigrations)

  private
    MigrationParams: TConnectionParams;
    FMigrationsFilesName: TStringList;
    FMigrationList: TObjectList<TMigrationEntity>;

  const
    _DBNAME: string = 'migrations.db';
    procedure UpdateMigrationFileNameList;
    function DBPath: String;
    function MigrationsDirPath: string;
    procedure Initialize;
    procedure CreateDatabase;
    procedure LoadMigrationList;
    function CreateMigrationFile(AFileName: string): string;
    function MigrationFileName(AName: string): string;
    procedure RegisterMigration(AFileName: string);
    procedure ClearUnuselessMigrations;
    function AlreadyToRunMigrations: Boolean;
    procedure ProcessMigrations;
    procedure CompleteMigration(AID: integer);
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
  System.SysUtils, DBmigrations.Connection, System.IOUtils;

{ TMigrations }

function Migrations: IMigrations;
begin
  Result := TMigrations.Create;
end;

function TMigrations.AlreadyToRunMigrations: Boolean;
begin
  Result := False;

  ClearUnuselessMigrations;
  UpdateMigrationFileNameList;

  if FMigrationsFilesName.Count = 0 then
    Exit;

  if not TConnection.New(TConnectionParams(TConnectionParams.New(dtOther)
    .GetTarget)).TestConnection then
    Exit;

  Result := True;
end;

procedure TMigrations.ClearUnuselessMigrations;
var
  Connection: IConnection;
  I: integer;
  FIDsNotExist: TList<integer>;
  FMigration, FMigrationsNeedToRemove: String;
begin
  UpdateMigrationFileNameList;
  Connection := TConnection.New(MigrationParams);
  FIDsNotExist := TList<integer>.Create;

  with DBQuery(Connection).Query do
  begin
    SQL.Add('SELECT * FROM MIGRATIONS');
    Open();

    // Clear Files
    for I := 0 to FMigrationsFilesName.Count - 1 do
    begin
      if not Locate('MIGRATION_NAME', FMigrationsFilesName[I], []) then
        DeleteFile(MigrationsDirPath + FMigrationsFilesName[I]);
    end;

    First;
    // Clear In database
    while not EOF do
    begin
      FMigration := MigrationsDirPath + FieldByName('MIGRATION_NAME').AsString;

      if not FileExists(FMigration) then
        FIDsNotExist.Add(FieldByName('ID').AsInteger);

      Next;
    end;

    for I := 0 to FIDsNotExist.Count - 1 do
    begin
      if I > 0 then
        FMigrationsNeedToRemove := FMigrationsNeedToRemove + ', ';

      FMigrationsNeedToRemove := FMigrationsNeedToRemove +
        IntToStr(FIDsNotExist[I]);
    end;

    Close;
    SQL.Clear;
    SQL.Add(Format('DELETE FROM MIGRATIONS WHERE ID IN (%s)',
      [FMigrationsNeedToRemove]));
    ExecSQL;
  end;

  FIDsNotExist.Free;
end;

procedure TMigrations.CompleteMigration(AID: integer);
var
  Connection: IConnection;
begin
  Connection := TConnection.New(MigrationParams);

  with DBQuery(Connection).Query do
  begin
    SQL.Add('UPDATE MIGRATIONS SET EXECUTED = 1, TIME_EXECUTED = :dt WHERE ID = :id');
    ParamByName('dt').AsDateTime := Now;
    ParamByName('id').AsInteger := AID;
    ExecSQL;
  end;
end;

constructor TMigrations.Create;
begin
  MigrationParams := TConnectionParams.Create;
  FMigrationsFilesName := TStringList.Create;
  FMigrationList := TObjectList<TMigrationEntity>.Create(True);

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
  Writeln(FFileName);

  RegisterMigration(FFileName);
end;

function TMigrations.CreateMigrationFile(AFileName: string): String;
var
  FName: string;
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
  FMigrationsFilesName.Free;
  FMigrationList.Free;
end;

procedure TMigrations.Initialize;
begin
  TConnection.New(MigrationParams).TestConnection;
end;

procedure TMigrations.LoadMigrationList;
var
  Connection: IConnection;
  FDir: String;
  FMigration: TMigrationEntity;
begin
  Connection := TConnection.New(MigrationParams);
  FDir := MigrationsDirPath;

  FMigrationList.Clear;

  with DBQuery(Connection).Query do
  begin
    Open('SELECT * FROM MIGRATIONS WHERE EXECUTED = 0 ORDER BY CREATED_AT ASC');

    First;
    while not EOF do
    begin
      FMigration := TMigrationEntity.Create(FieldByName('MIGRATION_NAME')
        .AsString, FDir);
      FMigration.ID := FieldByName('ID').AsInteger;
      FMigrationList.Add(FMigration);
      Next;
    end;
  end;
end;

function TMigrations.MigrationFileName(AName: string): string;
begin
  Result := Format('%s_%s.txt',
    [AName, FormatDateTime('yyyy-mm-dd_hh-nn-ss', Now)]);
end;

function TMigrations.MigrationsDirPath: string;
begin
{$IFDEF LINUX }
  Result := ExtractFilePath(ParamStr(0)) + 'migrations/';
{$ELSE}
  Result := ExtractFilePath(ParamStr(0)) + 'migrations\';
{$ENDIF}
end;

class function TMigrations.New: IMigrations;
begin
  Result := Self.Create;
end;

procedure TMigrations.ProcessMigrations;
var
  Connection: IConnection;
  Migration: TMigrationEntity;
begin
  Connection := TConnection.New(TConnectionParams(TConnectionParams.New(dtOther)
    .GetTarget));

  with DBQuery(Connection).Query do
  begin
    for Migration in FMigrationList do
    begin
      try
        Close;
        SQL.Clear;
        SQL.Add(Migration.Query);
        ExecSQL;

        CompleteMigration(Migration.ID);
      except
        Break;
      end;
    end;
  end;
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
var
  Connection: IConnection;
begin

  if not AlreadyToRunMigrations then
    Exit;

  LoadMigrationList;

  ProcessMigrations;

end;

procedure TMigrations.UpdateMigrationFileNameList;
var
  SR: TSearchRec;
begin
  FMigrationsFilesName.Clear;
  if FindFirst(MigrationsDirPath + '*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr and faDirectory) = 0 then
        FMigrationsFilesName.Add(SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

end.
