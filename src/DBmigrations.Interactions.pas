unit DBmigrations.Interactions;

interface

uses
  DBmigrations.Interfaces;

type
  TInteractions = class(TInterfacedObject, IInteractions)
  private
    FResult: String;
    procedure SetResultMessage(AMsg: String);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IInteractions;
    function MessageResult: String;
    function InitMigrations: IInteractions;
    function NewMigration: IInteractions;
    function TestDatabase: IInteractions;
    function RunMigrations: IInteractions;
  end;

implementation

{ TInteractions }

constructor TInteractions.Create;
begin

end;

destructor TInteractions.Destroy;
begin

  inherited;
end;

function TInteractions.InitMigrations: IInteractions;
begin
  Result := Self;
end;

function TInteractions.MessageResult: String;
begin
  Result := FResult;
end;

class function TInteractions.New: IInteractions;
begin
  Result := Self.Create;
end;

function TInteractions.NewMigration: IInteractions;
begin
  Result := Self;
end;

function TInteractions.RunMigrations: IInteractions;
begin
  Result := Self;
end;

procedure TInteractions.SetResultMessage(AMsg: String);
begin
  FResult := AMsg;
end;

function TInteractions.TestDatabase: IInteractions;
begin
  Result := Self;
end;

end.
