unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Logger.Log, Logger.Types;

type
  TfrmLog = class(TForm)
    Button1: TButton;
    edtLogText: TEdit;
    cbxType: TComboBox;
    edtUser: TEdit;
    CheckBox1: TCheckBox;
    edtLogName: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbxTypeChange(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    FType: TLogLevel;
  public
    { Public declarations }
  end;

var
  frmLog: TfrmLog;

implementation

{$R *.dfm}

procedure TfrmLog.Button1Click(Sender: TObject);
var
  FTeste: String;
begin
  FTeste := edtLogText.Text + sLineBreak + edtLogText.Text;

  if not CheckBox1.Checked then
    Log.Add(FTeste, FType, edtUser.Text)
  else
    cLog(edtLogName.Text).Add(FTeste, FType, edtUser.Text);
end;

procedure TfrmLog.cbxTypeChange(Sender: TObject);
begin
  case cbxType.ItemIndex of
    0:
      FType := Info;
    1:
      FType := Warning;
    2:
      FType := Error;

  end;
end;

procedure TfrmLog.CheckBox1Click(Sender: TObject);
begin
  edtLogName.Enabled := CheckBox1.Checked;
end;

procedure TfrmLog.FormCreate(Sender: TObject);
begin
  FType := Info;
end;

end.
