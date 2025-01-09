unit DBmigrations.DatabaseScheemas;

interface

uses
  DBmigrations.Interfaces, System.Classes;

type
  TDatabaseScheemas = class(TInterfacedObject, IDatabaseScheema)
  private
    FSQL: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IDatabaseScheema;
    function MigrationDatabaseScheema: TStringList;

  end;

function DBScheemas: IDatabaseScheema;

implementation

{ TDatabaseScheemas }
function DBScheemas: IDatabaseScheema;
begin
  Result := TDatabaseScheemas.Create;
end;

constructor TDatabaseScheemas.Create;
begin
  FSQL := TStringList.Create;
end;

destructor TDatabaseScheemas.Destroy;
begin

  inherited;
  FSQL.Free;
end;

function TDatabaseScheemas.MigrationDatabaseScheema: TStringList;
begin
  FSQL.Clear;
  with FSQL do
  begin
    Add('CREATE TABLE MIGRATIONS (');
    Add('ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,');
    Add('MIGRATION_NAME TEXT,');
    Add('TIME_EXECUTED TEXT,');
    Add('EXECUTED INTEGER DEFAULT (0)');
    Add(', CREATED_AT TEXT DEFAULT (CURRENT_TIMESTAMP));');
  end;

  Result := FSQL;
end;

class function TDatabaseScheemas.New: IDatabaseScheema;
begin
  Result := Self.Create;
end;

end.
