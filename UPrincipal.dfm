object fPrincipal: TfPrincipal
  Left = 0
  Top = 0
  Caption = 'Atualiza Banco'
  ClientHeight = 94
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lStatus: TLabel
    Left = 8
    Top = 71
    Width = 12
    Height = 13
    Caption = '...'
  end
  object btnAtualizaBanco: TButton
    Left = 8
    Top = 8
    Width = 153
    Height = 57
    Caption = 'Atualizar'
    TabOrder = 0
    OnClick = btnAtualizaBancoClick
  end
  object Conexao: TFDConnection
    Params.Strings = (
      'Database=C:\DEV\Fontes\RTTI-Atualizacao-Banco\DATABASE.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
end
