unit MigrationTool;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmTool = class(TForm)
    btnInit: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    edtMigrationName: TEdit;
    Button4: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTool: TfrmTool;

implementation

{$R *.fmx}

end.
