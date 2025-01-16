unit EnvManager.Interfaces;

interface

type

  IEnvManager = interface
    ['{184614D3-0BC5-4DF4-AF2D-DC7DE9480B7D}']
    function GetEnv(AKey: String): string;
    procedure SetEnv(AKey, AValue: String);
    procedure LoadEnv();
  end;

implementation

end.
