unit Logger.Log;

interface

uses
  Logger.CORE, Logger.Interfaces, Logger.Types;

type

  TLog = class(TInterfacedObject, ILog)
  private
    FLogger: TLogger;
  public
    constructor Create; overload;
    constructor Create(ALogName: string); overload;
    destructor Destroy; override;
    class function New: ILog;
    procedure Add(aLogMessage: String; aType: TLogLevel = Info;
      AUser: string = ''); overload;
    procedure Add(aLogMessage: String; AUser: string = ''); overload;
    procedure Add(aLogMessage: string); overload;
    function LogsDir: string;
  end;

function Log: ILog;

function cLog(ALogName: string): ILog;

implementation

uses
  System.SysUtils;

{ TLog }

function Log: ILog;
begin
  Result := TLog.Create;
end;

function cLog(ALogName: string): ILog;
begin
  Result := TLog.Create(ALogName);
end;

procedure TLog.Add(aLogMessage: String; aType: TLogLevel; AUser: string);
begin
  FLogger.Add(aLogMessage, aType, AUser);
end;

procedure TLog.Add(aLogMessage, AUser: string);
begin
  FLogger.Add(aLogMessage, AUser);
end;

procedure TLog.Add(aLogMessage: string);
begin
  FLogger.Add(aLogMessage, DefaultUser);
end;

constructor TLog.Create(ALogName: string);
begin
  FLogger := TLogger.Create(ALogName);
end;

constructor TLog.Create;
begin
  FLogger := TLogger.Create;
end;

destructor TLog.Destroy;
begin
  inherited;
  FLogger.Free;
end;

function TLog.LogsDir: string;
begin
  Result := FLogger.LogsDir;
end;

class function TLog.New: ILog;
begin
  Result := Self.Create;
end;

end.
