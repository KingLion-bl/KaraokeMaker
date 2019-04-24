unit PaintWave;

interface

uses Vcl.Controls, Vcl.Graphics, System.Classes, WavData, MyType;

type

  TWSPaintBox = class(TGraphicControl)
  public
    ScrBitmap: TBitmap;
    Scr: Pointer;
    SX, SY: Integer;
    PrevInterval: TInterval;

    FDisplayedData: TDisplayedData;
    FDisplayedDataLength: Integer;

    FOnPaint: TNotifyEvent;

    procedure DrawAxis;

    procedure CreateBitmap(aSX, aSY: Integer);
    procedure DeleteBitmap;
    procedure RecreateBitmap(aSX, aSY: Integer);

    function GetLeft: Integer;

    procedure Paint; override;

  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetDisplayedData(AllData: TDisplayedData; Min, Max: Integer);
    procedure Repaint(PageSize: integer);

    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnMouseDown;

  end;

implementation

uses
  WaveScreen, Winapi.Windows, Vcl.Forms;

constructor TWSPaintBox.Create(AOwner: TComponent);
begin
  inherited;
  SetSubComponent(True);
end;

destructor TWSPaintBox.Destroy;
begin
  inherited;

  if Assigned(ScrBitmap) then
    DeleteBitmap;
end;

procedure TWSPaintBox.SetDisplayedData(AllData: TDisplayedData; Min, Max: Integer);
var NewLength: Integer;
    i: Integer;
begin
  NewLength := Max - Min + 1;

  if Abs(FDisplayedDataLength - NewLength) > 1 then
  begin
    FDisplayedDataLength := NewLength;

    SetLength(FDisplayedData.Min, NewLength);
    SetLength(FDisplayedData.Max, NewLength);
  end;

  for i := 0 to NewLength do
  begin
    FDisplayedData.Min[i] := AllData.Min[Min + i];
    FDisplayedData.Max[i] := AllData.Max[Min + i];
  end;
end;

procedure TWSPaintBox.DrawAxis;
var
  TempColor: TColor;
  TempWidth: integer;
begin

  with ScrBitmap.Canvas do
  begin
    TempColor := Pen.Color;
    TempWidth := Pen.Width;

    Pen.Style := psSolid;
    Pen.Color := clRed;
    Pen.Width := 1;

    MoveTo(0, Height div 2);
    LineTo(Width, Height div 2);

    Pen.Color := TempColor;
    Pen.Width := TempWidth;
  end;

end;

procedure TWSPaintBox.CreateBitmap(aSX, aSY: Integer);
var
  BInfo: tagBITMAPINFO;
begin
  // Создание DIB
  SX := aSX; SY := aSY;
  BInfo.bmiHeader.biSize := sizeof(tagBITMAPINFOHEADER);
  BInfo.bmiHeader.biWidth := SX;
  BInfo.bmiHeader.biHeight := -SY;
  BInfo.bmiHeader.biPlanes := 1;
  BInfo.bmiHeader.biBitCount := 32;
  BInfo.bmiHeader.biCompression := BI_RGB;
  ScrBitmap := Vcl.Graphics.TBitmap.Create();
  ScrBitmap.Handle := CreateDIBSection(Application.MainFormHandle, BInfo, DIB_RGB_COLORS, Scr, 0, 0);
  ZeroMemory(Scr, SX * SY * 4);
end;

procedure TWSPaintBox.DeleteBitmap;
begin
  // Удаление DIB
  ScrBitmap.FreeImage();
  ScrBitmap.Destroy;
end;

procedure TWSPaintBox.RecreateBitmap(aSX, aSY: Integer);
var
  BInfo: tagBITMAPINFO;
begin
  // Пересоздание DIB при изменении размеров "экрана"
  ScrBitmap.FreeImage();
  SX := aSX; SY := aSY;
  BInfo.bmiHeader.biSize := sizeof(tagBITMAPINFOHEADER);
  BInfo.bmiHeader.biWidth := SX;
  BInfo.bmiHeader.biHeight := -SY;
  BInfo.bmiHeader.biPlanes := 1;
  BInfo.bmiHeader.biBitCount := 32;
  BInfo.bmiHeader.biCompression := BI_RGB;
  ScrBitmap.Handle := CreateDIBSection(Application.MainFormHandle, BInfo, DIB_RGB_COLORS, Scr, 0, 0);
  ZeroMemory(Scr, SX * SY * 4);
end;

function TWSPaintBox.GetLeft: Integer;
begin
  Result := inherited Left;
end;

procedure TWSPaintBox.Repaint(PageSize: integer);
begin

end;

procedure TWSPaintBox.Paint;
begin
  inherited;

  if Assigned(FOnPaint) then
    FOnPaint(Self);
end;


end.
