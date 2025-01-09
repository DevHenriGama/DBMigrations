unit DBmigrations.DBQuery;

interface

uses
  DBmigrations.Interfaces, DBmigrations.Connection, FireDAC.Comp.Client,FireDAC.DApt;

type
  TDBQuery = class(TInterfacedObject, IDBQuery)
  private
    FQuery: TFDQuery;
  public
    constructor Create(AConnection: IConnection);
    destructor Destroy; override;
    class function New(AConnection: IConnection): IDBQuery;
    function Query: TFDQuery;
  end;

function DBQuery(AConnection: IConnection): IDBQuery;

implementation

{ TDBQuery }

function DBQuery(AConnection: IConnection): IDBQuery;
begin
  Result := TDBQuery.Create(AConnection);
end;

constructor TDBQuery.Create(AConnection: IConnection);
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := AConnection.Connection;
end;

destructor TDBQuery.Destroy;
begin
  inherited;
  FQuery.Free;
end;

class function TDBQuery.New(AConnection: IConnection): IDBQuery;
begin
  Result := Self.Create(AConnection);
end;

function TDBQuery.Query: TFDQuery;
begin
  Result := FQuery;
end;

end.
