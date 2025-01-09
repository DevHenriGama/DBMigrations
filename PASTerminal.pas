unit PASTerminal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  DBmigrations.Interactions, DBmigrations.Interfaces, DBmigrations.Settings,
  Vcl.StdCtrls, DBmigrations.ConnectionParams, DBmigrations.Migrations;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  TConnectionParams.New(dtFirebird).SaveToSettings;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
TMigrations.New.RunMigrations;
end;

end.
