object frmLog: TfrmLog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Log'
  ClientHeight = 106
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 440
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Add Simple'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtLogText: TEdit
    Left = 16
    Top = 24
    Width = 225
    Height = 21
    TabOrder = 1
    Text = 'New Log'
  end
  object cbxType: TComboBox
    Left = 360
    Top = 24
    Width = 65
    Height = 21
    ItemIndex = 0
    TabOrder = 2
    Text = 'Info'
    OnChange = cbxTypeChange
    Items.Strings = (
      'Info'
      'Warning'
      'Error')
  end
  object edtUser: TEdit
    Left = 256
    Top = 24
    Width = 89
    Height = 21
    TabOrder = 3
    Text = 'System'
  end
  object CheckBox1: TCheckBox
    Left = 264
    Top = 56
    Width = 97
    Height = 17
    Caption = 'UseCustomName'
    TabOrder = 4
    OnClick = CheckBox1Click
  end
  object edtLogName: TEdit
    Left = 16
    Top = 56
    Width = 225
    Height = 21
    Enabled = False
    TabOrder = 5
  end
end
