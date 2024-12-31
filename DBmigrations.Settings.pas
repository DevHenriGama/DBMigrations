unit DBmigrations.Settings;

interface

uses
  System.SysUtils, System.JSON, System.IOUtils, System.NetEncoding,
  DBmigrations.Interfaces;

type
  TSettings = class(TInterfacedObject, IConfigManager)
  private
    FFilePath: string;
    FJSON: TJSONObject;
    FUseEncrypt: Boolean;

  const
    FileName = 'settings.json';

  const
    EncryptionKey = 'MinhaChaveSegura'; // Deve ser armazenada com seguran�a

    function Encrypt(const Value: string): string;
    function Decrypt(const Value: string): string;
    procedure LoadFileSettings;
    procedure SaveSettings;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IConfigManager; overload;
    property UseEncrypt: Boolean read FUseEncrypt write FUseEncrypt;
    procedure SetConfiguracao(AChave, Valor: string);
    function GetConfiguracao(AChave: string): string;
    function HasSettingsFile: Boolean;
    function ContainsKey(AKey: String): Boolean;

  end;

function Settings: IConfigManager;

implementation

uses
  System.Classes;

{ TMACConfig }

function Settings: IConfigManager;
begin
  Result := TSettings.Create;
end;

function TSettings.ContainsKey(AKey: String): Boolean;
begin
  Result := False;

  if HasSettingsFile then
    Result := FJSON.GetValue(AKey) <> NIL;

end;

constructor TSettings.Create;
begin
  FFilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), FileName);
  FUseEncrypt := False;
  FJSON := TJSONObject.Create;
  LoadFileSettings;
end;

destructor TSettings.Destroy;
begin
  SaveSettings;
  FJSON.Free;
  inherited;
end;

function TSettings.Encrypt(const Value: string): string;
begin
  if FUseEncrypt then
    Result := TNetEncoding.Base64.Encode(Value)
  else
    Result := Value;
end;

function TSettings.Decrypt(const Value: string): string;
begin
  if FUseEncrypt then
    Result := TNetEncoding.Base64.Decode(Value)
  else
    Result := Value;

end;

function TSettings.GetConfiguracao(AChave: string): string;
var
  Value: TJSONValue;
begin
  Value := FJSON.GetValue(AChave);
  if Assigned(Value) then
    Result := Decrypt(Value.Value)
  else
    Result := '';
end;

function TSettings.HasSettingsFile: Boolean;
begin
  Result := FileExists(FFilePath);
end;

procedure TSettings.SetConfiguracao(AChave, Valor: string);
var
  FValue: string;
begin
  if FJSON.TryGetValue<string>(AChave, FValue) then
    FJSON.RemovePair(AChave);

  FJSON.AddPair(AChave, Encrypt(Valor));
end;

procedure TSettings.LoadFileSettings;
var
  FileContent: string;
begin
  if not TFile.Exists(FFilePath) then
  begin
    FJSON.AddPair('DBMigrations', '1.0');
    SaveSettings;
    Exit;
  end;

  try
    FileContent := TFile.ReadAllText(FFilePath);

    FJSON.Free;
    FJSON := TJSONObject.ParseJSONValue(FileContent) as TJSONObject;
    if not Assigned(FJSON) then
      raise Exception.Create('Arquivo de configuração inválido.');
  except
    on E: Exception do
    begin
      FJSON := TJSONObject.Create;
      raise Exception.CreateFmt('Erro ao carregar configuração: %s',
        [E.Message]);
    end;
  end;
end;

class function TSettings.New: IConfigManager;
begin
  Result := Self.Create;
end;

procedure TSettings.SaveSettings;
var
  JSONString: string;
begin
  try
    JSONString := FJSON.ToJSON;

    TFile.WriteAllText(FFilePath, JSONString);
  except
    on E: Exception do
      raise Exception.CreateFmt('Erro ao salvar configura��es: %s',
        [E.Message]);
  end;
end;

end.
