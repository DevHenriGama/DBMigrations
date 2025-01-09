unit DBmigrations.Entity;

interface

type
  TMigrationEntity = class
  private
    FName: string;
    FID: Integer;
    FQuery: String;
  public
    constructor Create(AName, AMigrationsFolder: String);
    destructor Destroy; override;
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
    property Query: String read FQuery;

  end;

implementation

uses
  System.IOUtils;

{ TMigrationEntity }

constructor TMigrationEntity.Create(AName, AMigrationsFolder: String);
begin
  FQuery := TFile.ReadAllText(AMigrationsFolder + AName);
end;

destructor TMigrationEntity.Destroy;
begin

  inherited;
end;

end.
