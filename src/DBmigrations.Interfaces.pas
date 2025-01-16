unit DBmigrations.Interfaces;

interface

uses
  System.Classes, FireDAC.Comp.Client, Logger.Types;

type
  IInteractions = interface
    ['{AC037B1E-6073-44E1-A408-C67363AA2752}']
    function MessageResult: String;
    function InitMigrations: IInteractions;
    function NewMigration: IInteractions;
    function TestDatabase: IInteractions;
    function RunMigrations: IInteractions;
  end;

  IConnectionParams = interface
    ['{AE29CE57-9209-484F-AB8B-4A453D8F6D5B}']
    procedure SaveToSettings;
    procedure LoadFromSettings;
    function GetParamsAsString: string;
    function GetTarget: IConnectionParams;
    function ParamsInitalizared: Boolean;
  end;

  IConfigManager = interface
    ['{A4E1CD42-0754-4E9A-93D3-CEB65078A480}']
    procedure SetConfiguracao(AChave, Valor: string);
    function GetConfiguracao(AChave: string): string;
    function HasSettingsFile: Boolean;
    function ContainsKey(AKey: String): Boolean;
    function FileInitialized: Boolean;

  end;

  IConnection = interface
    ['{2FA710A9-03B6-4AB3-9B88-9BB8C1B6AEC1}']
    function TestConnection: Boolean;
    procedure CreateMigrationDatabase(APath: string);
    function Connection: TFDConnection;
  end;

  IMigrations = interface
    ['{CBC6B9B7-2E78-40D9-817A-4CD21795BF2B}']
    procedure RunMigrations;
    procedure CreateMigration(AName: string);
  end;

  IDatabaseScheema = interface
    ['{93930C17-120A-45D8-A64E-98602F3571ED}']
    function MigrationDatabaseScheema: TStringList;
  end;

  IDBQuery = interface
    ['{897670B1-0980-4678-B22C-6B8AB5A9AE18}']
    function Query: TFDQuery;
  end;

  IAdapterLog = interface
    ['{0DD2FA3B-3211-4C46-9AB1-BB3DF7D61307}']
    procedure Add(ALog: string; AType: TLogLevel = Error);
  end;

implementation

end.
