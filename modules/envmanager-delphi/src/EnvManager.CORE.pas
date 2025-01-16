unit EnvManager.CORE;

interface

uses
  System.Classes, EnvManager.Interfaces;

type
  TEnvManagerCORE = class(TInterfacedObject, IEnvManager)
  private
    FEnv: TStringList;

  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadEnv();
    function GetEnv(AKey: String): string;
    procedure SetEnv(AKey, AValue: String);
  end;

function _env: IEnvManager;

implementation

uses
  System.SysUtils, Vcl.Forms, Winapi.Windows, Vcl.Dialogs;

function _env: IEnvManager;
begin
  Result := TEnvManagerCORE.Create;
end;

{ TENV }

constructor TEnvManagerCORE.Create;
begin
  FEnv := TStringList.Create;
end;

destructor TEnvManagerCORE.Destroy;
begin

  inherited;
  FEnv.Free;
end;

function TEnvManagerCORE.GetEnv(AKey: String): string;
begin
  Result := GetEnvironmentVariable(AKey);
end;

procedure TEnvManagerCORE.LoadEnv;
var
  LFile, Line, Chave, Valor: string;
  SeparadorPos: integer;
begin
  LFile := ExtractFilePath(Application.ExeName) + '.env';
  if not FileExists(LFile) then
  begin
    ShowMessage('Variaveis de ambiente não configuradas!');
    Exit;
  end;

  FEnv.LoadFromFile(LFile, TEncoding.UTF8);

  for Line in FEnv do
  begin
    SeparadorPos := Line.IndexOf('=');
    if SeparadorPos > 0 then
    begin
      Chave := Line.Substring(0, SeparadorPos).Trim;
      Valor := Line.Substring(SeparadorPos + 1).Trim;
      SetEnv(Chave, Valor);
    end;

  end;

end;

procedure TEnvManagerCORE.SetEnv(AKey, AValue: String);
begin
  SetEnvironmentVariable(Pchar(AKey), Pchar(AValue));
end;

end.
