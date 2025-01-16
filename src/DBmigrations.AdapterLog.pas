unit DBmigrations.AdapterLog;

interface

uses
  DBmigrations.Interfaces, DBmigrations.ENV, Logger.Log, Logger.Types;

type
  TAdapterLog = class(TInterfacedObject, IAdapterLog)
  public
    procedure Add(ALog: string; AType: TLogLevel = Error);
  end;

function sLog: IAdapterLog;

implementation

function sLog: IAdapterLog;
begin
  Result := TAdapterLog.Create;
end;

{ TAdapterLog }

procedure TAdapterLog.Add(ALog: string; AType: TLogLevel);
begin

  if _ENV <> 'prod' then
    Exit;

  Log.Add(ALog, AType, 'System');
end;

end.
