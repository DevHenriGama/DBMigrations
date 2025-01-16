unit Logger.Interfaces;

interface

uses
  Logger.Types;

type
  ILog = interface
    ['{5611ABB6-14B7-47A5-90C1-2FF2FFD3C24A}']
    procedure Add(aLogMessage: String; aType: TLogLevel = Info;
      AUser: string = ''); overload;
    procedure Add(aLogMessage: String; AUser: string = ''); overload;
    procedure Add(aLogMessage: string); overload;
    function LogsDir: string;
  end;

implementation

end.
