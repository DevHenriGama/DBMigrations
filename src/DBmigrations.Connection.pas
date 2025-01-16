unit DBmigrations.Connection;

interface

uses
  DBmigrations.Interfaces,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.ConsoleUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.FB,
  DBmigrations.ConnectionParams;

type
  TConnection = class(TInterfacedObject, IConnection)
  private
    FParams: TConnectionParams;
    FConnection: TFDConnection;
  public
    constructor Create(AParams: TConnectionParams);
    destructor Destroy; override;
    class function new(AParams: TConnectionParams): IConnection;
    procedure CreateMigrationDatabase(APath: string);
    function TestConnection: Boolean;
    function Connection: TFDConnection;
  end;

implementation

uses
  System.IOUtils, System.SysUtils, DBmigrations.AdapterLog, Logger.Types;

{ TConnection }

function TConnection.Connection: TFDConnection;
begin
  Result := FConnection;
end;

constructor TConnection.Create(AParams: TConnectionParams);
begin
  FParams := AParams;
  FConnection := TFDConnection.Create(nil);
  FConnection.LoginPrompt := False;
  FConnection.DriverName := AParams.DriverID;

  FConnection.Params.Text := FParams.GetParamsAsString;
end;

procedure TConnection.CreateMigrationDatabase(APath: string);
var
  FDConnection: TFDConnection;
begin
  FDConnection := TFDConnection.Create(nil);
  try
    FDConnection.Params.Clear;
    FDConnection.DriverName := 'SQLite';
    FDConnection.Params.Add('Database=' + APath);
    FDConnection.Params.Add('LockingMode=Normal');
    FDConnection.LoginPrompt := False;

    FDConnection.Connected := True;

    sLog.Add('Created MigrationsDB', TLogLevel.Info);

  finally
    FDConnection.Free;
  end;
end;

destructor TConnection.Destroy;
begin
  inherited;
  FConnection.Free;
end;

class function TConnection.new(AParams: TConnectionParams): IConnection;
begin
  Result := Self.Create(AParams);
end;

function TConnection.TestConnection: Boolean;
begin
  Result := False;
  try
    FConnection.Connected := True;
    if FConnection.Connected then
      Result := True;
  except
    on E: Exception do
      sLog.Add(E.ToString);
  end;
end;

end.
