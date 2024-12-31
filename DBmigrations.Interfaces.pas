unit DBmigrations.Interfaces;

interface

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
  end;

  IConfigManager = interface
    ['{A4E1CD42-0754-4E9A-93D3-CEB65078A480}']
    procedure SetConfiguracao(AChave, Valor: string);
    function GetConfiguracao(AChave: string): string;
    function HasSettingsFile: Boolean;
    function ContainsKey(AKey: String): Boolean;

  end;

  IConnection = interface
    ['{2FA710A9-03B6-4AB3-9B88-9BB8C1B6AEC1}']
    function TestConnection: Boolean;
  end;

implementation

end.
