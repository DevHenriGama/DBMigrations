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

  IDBConnection = interface
    ['{AE29CE57-9209-484F-AB8B-4A453D8F6D5B}']
  end;

  IConfigManager = interface
    ['{A4E1CD42-0754-4E9A-93D3-CEB65078A480}']
    function ReadValue(const Key: string;
      const DefaultValue: string = ''): string;
    procedure WriteValue(const Key, Value: string);
  end;

implementation

end.
