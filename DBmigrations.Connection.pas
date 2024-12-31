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
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client;

type
  TConnection = class(TInterfacedObject, IConnection)
  private
    FParams: IConnectionParams;
    FConnection: TFDConnection;
  public
    constructor Create(AParams: IConnectionParams);
    destructor Destroy; override;
    class function new(AParams: IConnectionParams): IConnection;
    function TestConnection: Boolean;
  end;

implementation

{ TConnection }

constructor TConnection.Create(AParams: IConnectionParams);
begin
  FParams := AParams;
  FConnection := TFDConnection.Create(nil);
  FConnection.LoginPrompt := False;

  // Carrega as configs
  FParams.LoadFromSettings;
  FConnection.Params.Text := FParams.GetParamsAsString;
end;

destructor TConnection.Destroy;
begin
  inherited;
  FConnection.Free;
end;

class function TConnection.new(AParams: IConnectionParams): IConnection;
begin
  Result := Self.Create(AParams);
end;

function TConnection.TestConnection: Boolean;
begin
  try
    Result := FConnection.Connected;
  except
    Result := False;
  end;
end;

end.
