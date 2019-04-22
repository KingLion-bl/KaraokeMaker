object MainForm: TMainForm
  Left = 211
  Top = 128
  Anchors = [akLeft, akTop, akBottom]
  Caption = 'MainForm'
  ClientHeight = 667
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 424
    Width = 852
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 889
    ExplicitTop = 0
    ExplicitWidth = 423
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 424
    Align = alTop
    Caption = 'Panel2'
    TabOrder = 0
    object Panel1: TPanel
      Left = 1
      Top = 350
      Width = 850
      Height = 73
      Align = alBottom
      Caption = 'Panel1'
      TabOrder = 0
      DesignSize = (
        850
        73)
      object MediaPlayer: TMediaPlayer
        Left = 10
        Top = 16
        Width = 85
        Height = 41
        VisibleButtons = [btPlay, btPause, btStop]
        DoubleBuffered = True
        FileName = 
          'C:\Users\KingLion\Documents\Embarcadero\Studio\Projects\KaraokeM' +
          'aker\wave-16.wav'
        ParentDoubleBuffered = False
        TabOrder = 0
        OnClick = MediaPlayerClick
      end
      object AutoScroll: TCheckBox
        Left = 731
        Top = 6
        Width = 97
        Height = 17
        Anchors = [akTop, akRight]
        Caption = #1040#1074#1090#1086#1087#1088#1086#1082#1088#1091#1090#1082#1072
        TabOrder = 1
        OnClick = AutoScrollClick
      end
      object Button1: TButton
        Left = 731
        Top = 29
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1050#1091#1088#1089#1086#1088' '#1074' '#1094#1077#1085#1090#1088#1077
        TabOrder = 2
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 624
        Top = 6
        Width = 75
        Height = 46
        Caption = #1052#1085#1086#1075#1086#1089#1090#1088#1086#1095#1085#1072#1103' '#1082#1085#1086#1087#1082#1072
        TabOrder = 3
        OnClick = Button2Click
      end
    end
    object WaveScreen: TWaveScreen
      Left = 1
      Top = 1
      Width = 850
      Height = 349
      Align = alClient
      Caption = 'WaveScreen'
      TabOrder = 1
      PaintBox.Left = 1
      PaintBox.Top = 1
      PaintBox.Width = 848
      PaintBox.Height = 322
      PaintBox.OnMouseDown = WaveScreenPaintBoxMouseDown
      PaintBox.ExplicitLeft = 0
      PaintBox.ExplicitTop = 0
      PaintBox.ExplicitWidth = 0
      PaintBox.ExplicitHeight = 0
      ScrollBar.Left = 1
      ScrollBar.Top = 1
      ScrollBar.Width = 846
      ScrollBar.Height = 23
      ScrollBar.Align = alClient
      ScrollBar.PageSize = 1
      ScrollBar.TabOrder = 0
      AutoScroll = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 429
    Width = 852
    Height = 238
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object StringGrid1: TStringGrid
      Left = 1
      Top = 1
      Width = 850
      Height = 236
      Align = alClient
      ColCount = 2
      FixedCols = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
      ParentFont = False
      TabOrder = 0
      OnDrawCell = StringGrid1DrawCell
      OnGetEditMask = StringGrid1GetEditMask
      ExplicitLeft = 0
      ColWidths = (
        103
        721)
      RowHeights = (
        24
        24
        24
        24
        24)
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = TimerTimer
    Left = 16
    Top = 24
  end
end
