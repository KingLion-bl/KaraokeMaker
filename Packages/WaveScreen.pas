unit WaveScreen;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls, Vcl.MPlayer, MyType,
  Vcl.StdCtrls, WinAPI.Messages, System.Types, Vcl.Graphics, Vcl.Forms, WavData, PaintWave,
  WaveScrollBar, SongTextGrid;

const
  imNearest = 0;
  imLine = 1;
  imSinC = 2;
  imCubic = 3;

type
  TBig = array[0..0] of Integer;

  TWaveScreenSelectPosition = procedure(Sender: TObject; Time: Extended) of object;

  TWaveScreen = class(TPanel)
  private
    FPaintBox: TWSPaintBox;
    FScrollBar: TWSScrollBar;
    FSongTextGrid: TSongTextGrid;

    FWaveScreenSelectPosition: TWaveScreenSelectPosition;

    FNotRepaint: Boolean;

    FAutoScroll: Boolean;

    FWavData: TWavData;
    FDisplayedData: TDisplayedData;

    FYScale: Real;

    // ������� ������� ������� � �������
    FCursorPosition: Integer;

    // ������� ������� "�����" � �������
    FWavePosition: Integer;

    FVisibleInterval: TInterval;

    procedure PaintWaveScreen(Sender: TObject);
    procedure WaveScreenMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    // ��������� � ������ ������� ������� "�����": ������ �� ������ �����
    procedure SetWavePositionBySamples(ASamplesPosition: Integer);
    function GetWavePositionAsSamples: Integer;

    // ��������� � ������ ������� ������� �������: ������� �� ������ �����
    procedure SetCursorPositionByTime(ATimePosition: Extended);
    function GetCursorPositionAsTime: Extended;

    // ��������� � ������ ������� ������� �������: ������ �� ������ �����
    procedure SetCursorPositionBySamples(APosition: Integer);
    function GetCursorPositionAsSamples: Integer;

    // ��������� ����� ���������� � �������� � � �������
    function GetLengthAsTime: Extended;
    function GetLengthAsSamples: Integer;

    // ��������� ����� �������������
    procedure SetAutoScroll(AAutoScroll: Boolean);

    function GetFileOpened: boolean;

    procedure FullDisplayedDataGenerate;



  protected
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure Resize; override;

    property WavData: TWavData read FWavData;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Repaint;
    property NotRepaint: Boolean read FNotRepaint write FNotRepaint;

    // ��������� ���� ��� �����������
    procedure OpenMedia(AFileName: string);
    // ����������� ��������������� �� ������
    property YScale: Real read FYScale write FYScale;

    // ������������� ������ � ����� ������
    procedure ShowCursorAtScreenCenter;

    procedure SendDataToPaintWave();

    // ������������� �������� �������, ��� ����������� �� ������
    procedure SetVisibleInterval(FirstSample, LastSample: Integer);
    // �������� �������, ������������ �� ������
    property VisibleInterval: TInterval read FVisibleInterval;
    // �������� ���������� �������, ������� �� ������
    function GetVisibleSamplesCount: Integer;

    // ����������� �������� ���������� � �����
    function SampleByX(ACoordinate: Integer): Integer;
    // ����������� �������� ���������� �� ����� �� ������ �����
    function TimeByX(ACoordinate: Integer): Extended;

    // �������� ���� �� �������
    function GetSampleByTime(Time: Extended): Integer;
    // �������� ����� �� ������
    function GetTimeBySample(Sample: Integer): Extended;

    // ������� ��������� ����������� "�����" � ������� �� ������ �����
    property WavePositionAsSamples: Integer read GetWavePositionAsSamples write SetWavePositionBySamples;

    // ������� ��������� ������� � �������� � �������
    property CursorPositionAsTime: Extended read GetCursorPositionAsTime
                                            write SetCursorPositionByTime;
    property CursorPositionAsSamples: Integer read GetCursorPositionAsSamples
                                              write SetCursorPositionBySamples;

    // ����� ����������� � ��������
    property LengthAsTime: Extended read GetLengthAsTime;
    property LengthAsSamples: Integer read GetLengthAsSamples;

    // ���� ��������
    property FileOpened: boolean read GetFileOpened;

  published
    property PaintBox: TWSPaintBox read FPaintBox;
    property ScrollBar: TWSScrollBar read FScrollBar;
    property SongTextGrid: TSongTextGrid read FSongTextGrid write FSongTextGrid;

    // ������������� ������ � ��������
    property AutoScroll: Boolean read FAutoScroll write SetAutoScroll default True;

    property OnSelectPosition: TWaveScreenSelectPosition read FWaveScreenSelectPosition
                                                         write FWaveScreenSelectPosition;
  end;


procedure Register;

implementation

uses Variants, Winapi.Windows;


constructor TWaveScreen.Create(AOwner: TComponent);
var GroupPanel: TPanel;
begin
  inherited;

  GroupPanel := TPanel.Create(Self);
  with GroupPanel do
  begin
    Parent := Self;
    Name := 'GroupPanel';
    Caption := '';
    Align := alBottom;
    Height := 25;
  end;

  FScrollBar := TWSScrollBar.Create(Self);
  with FScrollBar do
  begin
    Parent := GroupPanel;
    Name := 'ScrollBar';
    Align := alClient;
  end;

  FPaintBox := TWSPaintBox.Create(Self);
  with FPaintBox do
  begin
    Parent := Self;
    Name := 'PaintBox';
    Align := alClient;
    OnPaint := PaintWaveScreen;
    OnMouseDown := WaveScreenMouseDown;
  end;

  FWavData := TWavData.Create;
end;

destructor TWaveScreen.Destroy;
begin
  inherited;
end;

function TWaveScreen.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
var NewIntervalSize: Integer;
  Deviation: Integer;
  PositionShift: Integer;
begin
  // ��������� ����������� �����������
  NotRepaint := true;

  // ��������� ����� ������� ��������
  if WheelDelta > 0 then
    NewIntervalSize := Round(GetVisibleSamplesCount * 95 / 100)
  else
    NewIntervalSize := Round(GetVisibleSamplesCount * 100 / 95);

  // ����� ������� �������� ���������� ����������� ��������
  PositionShift := (NewIntervalSize - FScrollBar.PageSize) Div 2;

  // ��������� ���������� ���������
  FScrollBar.PageSize := NewIntervalSize;
  FScrollBar.Position := FScrollBar.Position - PositionShift;

  // ��������� ������ �������� ���������
  SetVisibleInterval(FScrollBar.Position, FScrollBar.Position + FScrollBar.PageSize);

  // ���������� ������� ������, ������ �� ������ ���������
  FullDisplayedDataGenerate;

  // �������������� �����������
  NotRepaint := false;
  Repaint;

  Result := True;
end;

function TWaveScreen.GetVisibleSamplesCount: Integer;
begin
  Result := FVisibleInterval.Max - FVisibleInterval.Min + 1;
end;

function TWaveScreen.SampleByX(ACoordinate: Integer): Integer;
var RealPos: Extended;
begin
  RealPos := 1.0 * FVisibleInterval.Min + 1.0 * ACoordinate * (FVisibleInterval.Max - FVisibleInterval.Min) / PaintBox.ClientWidth;

  Result := Round(RealPos);
end;

function TWaveScreen.TimeByX(ACoordinate: Integer): Extended;
begin
  Result := SampleByX(ACoordinate) / FWavData.Head.dwSamplesPerSec;
end;

function TWaveScreen.GetSampleByTime(Time: Extended): Integer;
begin
  Result := Trunc(Time * FWavData.Head.dwSamplesPerSec);
end;

function TWaveScreen.GetTimeBySample(Sample: Integer): Extended;
begin
  Result := Sample / FWavData.Head.dwSamplesPerSec;
end;

procedure TWaveScreen.Resize;
begin
  inherited;

  // ���������� ������ ������� ������, ��-�� �������� ��������
  FullDisplayedDataGenerate;

  // ������...
  Repaint;
end;

procedure TWaveScreen.SetWavePositionBySamples(ASamplesPosition: Integer);
begin
  FScrollBar.Position := ASamplesPosition;
end;

function TWaveScreen.GetWavePositionAsSamples: Integer;
begin
  Result := FScrollBar.Position;
end;

procedure TWaveScreen.SetCursorPositionByTime(ATimePosition: Extended);
var NewPosition: Integer;
begin
  NewPosition := GetSampleByTime(ATimePosition);
  SetCursorPositionBySamples(NewPosition);
end;

function TWaveScreen.GetCursorPositionAsTime: Extended;
begin
  Result := GetTimeBySample(FCursorPosition);
end;

procedure TWaveScreen.SetCursorPositionBySamples(APosition: Integer);
var Deviation: Integer;
begin

  if AutoScroll then
  begin
    // ��������� ����������� ���������� ��� ��������� �������
    NotRepaint := True;

    //��������� � ������������� �������
    Deviation := APosition - FCursorPosition;
    FScrollBar.Position := FScrollBar.Position + Deviation;

    // ������� ������ �� �����������
    NotRepaint := False;
  end;

  FCursorPosition := APosition;

end;

function TWaveScreen.GetCursorPositionAsSamples: Integer;
begin
  Result := FCursorPosition;
end;

function TWaveScreen.GetLengthAsTime: Extended;
begin
  Result := FWavData.SamplesCount / FWavData.Head.dwSamplesPerSec;
end;

function TWaveScreen.GetLengthAsSamples: Integer;
begin
  Result := FWavData.SamplesCount;
end;

procedure TWaveScreen.FullDisplayedDataGenerate();
var
  NewWidth: Integer;
begin
  // ���� ������ � ����� ��������� �����, �� �������. ��� ���� �� ������
  if FVisibleInterval.Max = FVisibleInterval.Min then
    exit;

  // ������������ ����� ���������� �������� ������������ ������ ������ ��
  // ������ ���� � ���������� ������� � �����
  NewWidth := Trunc(ClientWidth / ((FVisibleInterval.Max - FVisibleInterval.Min) / Length(FWavData.Data)));

  // ���������� ������ ������ ��� �����������
  FDisplayedData := FWavData.FullDisplayedDataGenerate(NewWidth, imLine);
end;

procedure TWaveScreen.OpenMedia(AFileName: string);
var SamplesCount: Integer;
  Zoom: Real;
begin

  // ��������� ���� � ��������� ������ �� ����
  FWavData.OpenFile(AFileName);
  SamplesCount := FWavData.SamplesCount;

  // ����� ����� ��������� �������� ��� ������ ���������
  FScrollBar.Max := SamplesCount;
  FScrollBar.PageSize := SamplesCount;

  // ���������� ������� �� ��������� ������ �� ����������� �����
  case FWavData.Head.wBitsPerSample of
    8:
      FYScale := 256;
    16:
      FYScale := 1;
    32:
      FYScale := 1 / (256 * 256);
  end;

  // ������������� ������� ���� �������� �������
  SetVisibleInterval(0, SamplesCount);

  // ���������� ������ ������� ������, ������ �� ������ ���������
  FullDisplayedDataGenerate;

  // � ������...
  Repaint;
end;

procedure TWaveScreen.SetVisibleInterval(FirstSample, LastSample: Integer);
var AddToMax, DecFromMin: Integer;
    Ratio: Extended;
    Min, Max, IntervalSize: Integer;
    IntervalMin, IntervalMax: Integer;
    i: Integer;
begin

  // ���� ������ ����� ����� ����������, �� �������, ��� ���� �� ������
  if FirstSample = LastSample then
    exit;

  // ������������� ����� ������ ������ ���������
  IntervalSize := LastSample - FirstSample + 1;

  // ������������ ������ ���������, � ������ ���� �� ������ ����� �����
  if IntervalSize > WavData.SamplesCount then
    IntervalSize := WavData.SamplesCount;


  FVisibleInterval.Min := FirstSample;
  FVisibleInterval.Max := LastSample;
end;

procedure TWaveScreen.SetAutoScroll(AAutoScroll: boolean);
begin
  FAutoScroll := AAutoScroll;
end;

procedure TWaveScreen.ShowCursorAtScreenCenter;
var NewScrollPosition: Integer;
begin

  NewScrollPosition := FCursorPosition - (FScrollBar.PageSize Div 2);

  if NewScrollPosition < 0 then
    NewScrollPosition := 0;

  if NewScrollPosition + FScrollBar.PageSize > FScrollBar.Max then
    NewScrollPosition := FScrollBar.Max - FScrollBar.PageSize;

  FScrollBar.Position := NewScrollPosition;

end;

procedure TWaveScreen.SendDataToPaintWave;
var
  Ratio: Extended;
  Min: Integer;
  Max: Integer;
begin

  if Not FWavData.FileOpened then
    exit;

  // ������������ ��������� ���������� ������� �������� � ���������� �������
  // ��� ����������� ������������ � ������������� �������� ������� ������ ��
  // ������, ������������� � �������
  Ratio := Length(FDisplayedData.Min) / FWavData.SamplesCount;
  Min := Round(FVisibleInterval.Min * Ratio);
  Max := Round(FVisibleInterval.Max * Ratio);

  if Assigned(FDisplayedData.Min) then
    FPaintBox.SetDisplayedData(FDisplayedData, Min, Max);

end;

procedure TWaveScreen.Repaint;
begin
  if NotRepaint then
    exit;

  // �������� ������ ��� ����������
  SendDataToPaintWave;
  FPaintBox.Paint;
end;

procedure TWaveScreen.PaintWaveScreen(Sender: TObject);
var
  PaintWave: TWSPaintBox;
  NewLength: integer;
  F: Real;
  i: integer;
  WavData: TWavData;
  Coeff: Real;
  LinePos: Integer;

  curTimePoint: Extended;
  curSample: integer;

begin
  inherited;

  PaintWave := TWSPaintBox(Sender);

  if ScrollBar.PageSize = 0 then
    exit;

  with PaintWave do
  begin
    if not Assigned(ScrBitmap) then
      CreateBitmap(ClientWidth, ClientHeight)
    else
      if (ScrBitmap.Width <> ClientWidth) or (ScrBitmap.Height <> ClientHeight) then
        RecreateBitmap(ClientWidth, ClientHeight);

    with ScrBitmap.Canvas do
    begin
      // ������� ���� ��� ������
      Brush.Color := clBlack;
      FillRect(ClientRect);

      // ������ ���
      DrawAxis;

      // ������� � ������ ����� �����
      Pen.Color := clLime;
      F := Height * YScale / 65536;

      NewLength := Length(FDisplayedData.Max);

      For i := 0 to NewLength - 1 do
      begin
        MoveTo(i, Height shr 1 - round(FDisplayedData.Max[i] * F));
        LineTo(i, Height shr 1 - round(FDisplayedData.Min[i] * F) + 1);
      end;

      For i := 0 to NewLength - 1 do
      begin
        MoveTo(i, Height shr 1 + round(FDisplayedData.Min[i] * F));
        LineTo(i, Height shr 1 + round(FDisplayedData.Max[i] * F) + 1);
      end;

      // ����� �������� �������
      Coeff := Width / ScrollBar.PageSize;
      LinePos := Trunc((CursorPositionAsSamples - VisibleInterval.Min) * Coeff);
      Pen.Color := clAqua;

      MoveTo(LinePos, 1);
      LineTo(LinePos, Height);

      // ���������� ��������� �����
      Pen.Color := clHotLight;
      Brush.Color := clCream;

      if Assigned(SongTextGrid) then
      begin
        for i := 1 to SongTextGrid.TimePointsCount do
        begin
          curTimePoint := SongTextGrid.TimePoints[i];
          curSample := GetSampleByTime(curTimePoint);

          if (curSample >= VisibleInterval.Min) And (curSample <= VisibleInterval.Max) then
          begin
            LinePos := Trunc((curSample - VisibleInterval.Min) * Coeff);
            MoveTo(LinePos, Height Div 2);
            Ellipse(LinePos - 5, Height Div 2 - 15, LinePos + 5, Height Div 2 + 15);
          end;
        end;
      end;

    end;

    Canvas.Draw(0, 0, ScrBitmap);
  end;
end;

procedure TWaveScreen.WaveScreenMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;

  if Assigned(OnSelectPosition) then
  begin
    CursorPositionAsSamples := SampleByX(X);
    Repaint;
    OnSelectPosition(Self, CursorPositionAsTime);
  end;
end;

function TWaveScreen.GetFileOpened: boolean;
begin
  Result := FWavData.FileOpened;
end;


procedure Register;
begin
  RegisterComponents('WaveScreen', [TWaveScreen]);
end;

end.
