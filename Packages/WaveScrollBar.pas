unit WaveScrollBar;

interface

uses
  Vcl.StdCtrls, System.Classes;

type

  TWSScrollBar = class(TScrollBar)
  private
    procedure SetPosition(Value: Integer);
    function GetPosition: Integer;

    procedure SetPageSize(Value: Integer);
    function GetPageSize: Integer;

  protected
    procedure Scroll(ScrollCode: TScrollCode; var ScrollPos: Integer); override;

  public
    constructor Create(AOwner: TComponent); override;

  published
    property Position: Integer read GetPosition write SetPosition default 0;
    property PageSize: Integer read GetPageSize write SetPageSize;

  end;

implementation

uses
  WaveScreen;

constructor TWSScrollBar.Create(AOwner: TComponent);
begin
  inherited;
  PageSize := 1;

  SetSubComponent(True);
end;

procedure TWSScrollBar.Scroll(ScrollCode: TScrollCode; var ScrollPos: Integer);
var EndPos: Integer;
    Deviation: Integer;
    RealPos: Extended;
begin
//  if TWaveScreen(Self.Owner).AutoScroll then
//  begin
//    ScrollPos := Position;
//    exit;
//  end;

  inherited;

  Position := ScrollPos;

  EndPos := Self.Max - Self.PageSize;
  if EndPos = 0 then
    exit;

  with TWaveScreen(Self.Owner) do
  begin
    SetVisibleInterval(ScrollPos, ScrollPos + Self.PageSize);
    Repaint;
  end;
end;

procedure TWSScrollBar.SetPosition(Value: Integer);
var RealPos: Extended;
    Deviation: Integer;
begin
  if Value > Max then
    Value := Max;
  if Value < 0 then
    Value := 0;

  if Value + Self.PageSize > Max then
    Value := Max - Self.PageSize;

  inherited Position := Value;

  with TWaveScreen(Self.Owner) do
  begin
    SetVisibleInterval(Position, Position + Self.PageSize);
    Repaint;
  end;
end;

function TWSScrollBar.GetPosition: Integer;
begin
  Result := inherited Position;
end;

procedure TWSScrollBar.SetPageSize(Value: Integer);
begin
  if Value > Max then
    Value := Max;
  if Value < Min then
    Value := Min;

  inherited PageSize := Value;
end;

function TWSScrollBar.GetPageSize: Integer;
begin
  Result := inherited PageSize;
end;

end.
