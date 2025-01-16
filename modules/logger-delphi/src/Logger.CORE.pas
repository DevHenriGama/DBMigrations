unit Logger.CORE;

interface

uses

  System.SysUtils, Logger.Types;

type

  TLogger = class
  private
    FLogFile: TextFile;
    FDir: String;
    FSettedName: string;

  const
    _LogAttr = 'Logger - ';

    function LogName: String;
    procedure SettingUPLogger;
    function DefType(aType: TLogLevel): string;
    function NormalizeInput(const AText: string): string;
  public
    constructor Create; overload;
    constructor Create(ALogName: string); overload;
    destructor Destroy; override;
    procedure Add(aLogMessage: String; aType: TLogLevel = Info;
      AUser: string = ''); overload;
    procedure Add(aLogMessage: String; AUser: string = ''); overload;
    procedure Add(aLogMessage: string); overload;
    function LogsDir: string;

  end;

implementation


{ TLogger }

procedure TLogger.Add(aLogMessage: String; aType: TLogLevel; AUser: string);
var
  LUser: String;
begin
  LUser := AUser;

{$IFDEF TEST}
  if LUser.IsEmpty then
    LUser := ' TEST';
{$ENDIF}
  Append(FLogFile);
  try
    Writeln(FLogFile, Format('| [%s] | %s | %s | - %s | [%s] |',
      [DateToStr(Now), DefType(aType), LUser, NormalizeInput(aLogMessage),
      TimeToStr(Now)]));
  finally
    CloseFile(FLogFile);
  end;
end;

procedure TLogger.Add(aLogMessage: string);
begin
  Self.Add(aLogMessage, TLogLevel.Error, DefaultUser);
end;

constructor TLogger.Create(ALogName: string);
begin
  FSettedName := ALogName;
  SettingUPLogger;
end;

procedure TLogger.Add(aLogMessage, AUser: string);
begin
  Self.Add(aLogMessage, TLogLevel.Error, AUser);
end;

constructor TLogger.Create;
begin
  SettingUPLogger;
end;

function TLogger.DefType(aType: TLogLevel): string;
begin
  case aType of
    Info:
      Result := '[Info]';
    Warning:
      Result := '[Warning]';
    Error:
      Result := '[Error]';
  else
    Result := '[Unknown]';
  end;
end;

destructor TLogger.Destroy;
begin
  inherited;
end;

function TLogger.LogName: String;
var
  FName: string;
begin
  FName := FSettedName;

  if FSettedName.IsEmpty then
    FName := _LogAttr;

  Result := FName + FormatDateTime('ddmmyyyy', Now) + '.logr';
end;

function TLogger.LogsDir: string;
begin
  Result := FDir;
end;

function TLogger.NormalizeInput(const AText: string): string;
begin
  if AText.IsEmpty then
  begin
    Result := 'LOG NOT ADDED :(';
    Exit;
  end;

  Result := StringReplace(AText, sLineBreak, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #13, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, '|', ' ', [rfReplaceAll]);

end;

procedure TLogger.SettingUPLogger;
var
  FFile: string;
begin
{$IFDEF LINUX}
  FDir := ExtractFilePath(ParamStr(0)) + 'Logs/';
{$ELSE}
  FDir := ExtractFilePath(ParamStr(0)) + 'Logs\';
{$ENDIF}
  FFile := FDir + LogName;

  if not DirectoryExists(FDir) then
  begin
    CreateDir(FDir);
  end;

  AssignFile(FLogFile, FFile);
  if not FileExists(FFile) then
    Rewrite(FLogFile)
  else
    Append(FLogFile);

  CloseFile(FLogFile);
end;

end.
