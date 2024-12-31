unit DBmigrations.Settings;

interface

uses
  System.Classes, System.JSON, System.IOUtils, DBmigrations.Interfaces;

type
  TConfigManager = class(TInterfacedObject,IConfigManager)
  private
    FFileName: string;
    FConfig: TJSONObject;
    procedure LoadConfig;
    procedure SaveConfig;
    procedure CreateDefaultConfig;
  public
    constructor Create(const AFileName: string = 'configDB.json');
    destructor Destroy; override;

    function ReadValue(const Key: string; const DefaultValue: string = ''): string;
    procedure WriteValue(const Key, Value: string);

    property FileName: string read FFileName;
  end;

implementation

uses
  System.SysUtils;

{ TConfigManager }

constructor TConfigManager.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := TPath.Combine(TDirectory.GetCurrentDirectory, AFileName);

  if not TFile.Exists(FFileName) then
    CreateDefaultConfig
  else
    LoadConfig;
end;

destructor TConfigManager.Destroy;
begin
  FConfig.Free;
  inherited;
end;

procedure TConfigManager.CreateDefaultConfig;
begin
  FConfig := TJSONObject.Create;
  FConfig.AddPair('AppName', 'MyApplication');
  FConfig.AddPair('Version', '1.0.0');
  FConfig.AddPair('DefaultSetting', 'Value');
  SaveConfig;
end;

procedure TConfigManager.LoadConfig;
var
  JSONString: string;
begin
  JSONString := TFile.ReadAllText(FFileName);
  FConfig := TJSONObject.ParseJSONValue(JSONString) as TJSONObject;

  if FConfig = nil then
    raise Exception.Create('Erro ao carregar o arquivo de configuração. JSON inválido.');
end;

procedure TConfigManager.SaveConfig;
var
  JSONString: string;
  StringWriter: TStringWriter;
begin
  StringWriter := TStringWriter.Create;
  try
    JSONString := StringWriter.ToString;
    TFile.WriteAllText(FFileName, JSONString, TEncoding.UTF8);
  finally
    StringWriter.Free;
  end;
end;

function TConfigManager.ReadValue(const Key, DefaultValue: string): string;
begin
  if not FConfig.TryGetValue(Key, Result) then
    Result := DefaultValue;
end;

procedure TConfigManager.WriteValue(const Key, Value: string);
begin
  FConfig.AddPair(Key, Value);
  SaveConfig;
end;

end.

