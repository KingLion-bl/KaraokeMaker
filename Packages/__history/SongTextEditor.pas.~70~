unit SongTextEditor;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls,
  WinApi.Messages, System.Types, WinApi.Windows, RichEdit, Graphics, RegExpr,
  Generics.Collections;

type
  //---------------------------------------------------------------------
  TMyTextAttributes = class(TTextAttributes)
  private
    RichEdit: TCustomRichEdit;
    FType: TAttributeType;

    procedure GetAttributes(var Format: TCharFormat2);
    function GetBGColor: TColor;

    procedure SetAttributes(var Format: TCharFormat2);
    procedure SetBGColor(Value: TColor);

  public
    constructor Create(AOwner: TCustomRichEdit; AttributeType: TAttributeType);

    property BGColor: TColor read GetBGColor write SetBGColor;
  end;

  TTextItem = record
    First, Last : integer;
  end;

  //---------------------------------------------------------------------
  TSongTextEditor = class(TRichEdit)
  private
    RegEx: TRegExpr;
//    MarkedTextItems: TList<TTextItem>;

    FSelAttributes: TMyTextAttributes;
    FDefAttributes: TMyTextAttributes;

    procedure SetDefAttributes(Value: TMyTextAttributes);
    procedure SetSelAttributes(Value: TMyTextAttributes);

    procedure PasteMessage(var Message: TMessage); message WH_CALLWNDPROC;

  protected
    procedure Change; override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure WNDProc(var Message: TMessage); override;

    property DefAttributes: TMyTextAttributes read FDefAttributes write SetDefAttributes;
    property SelAttributes: TMyTextAttributes read FSelAttributes write SetSelAttributes;

    procedure HighlightText(BeginPosition, EndPosition: Integer);
  published

  end;

procedure Register;

implementation

uses
  Winapi.CommDlg;


constructor TMyTextAttributes.Create(AOwner: TCustomRichEdit; AttributeType: TAttributeType);
begin
  inherited Create(AOwner, AttributeType);
  RichEdit := AOwner;
  FType := AttributeType;
end;

procedure TMyTextAttributes.GetAttributes(var Format: TCharFormat2);
begin
  InitFormat(Format);
  if RichEdit.HandleAllocated then
    SendGetStructMessage(RichEdit.Handle, EM_GETCHARFORMAT,
      WPARAM(FType = atSelected), Format, True);
end;

function TMyTextAttributes.GetBGColor: TColor;
var
  Format: TCharFormat2;
begin
  GetAttributes(Format);
  with Format do
    if (dwEffects and CFE_AUTOCOLOR) <> 0 then
      Result := clWindow else
      Result := crBackColor;
end;

procedure TMyTextAttributes.SetAttributes(var Format: TCharFormat2);
var
  Flag: Longint;
begin
  if FType = atSelected then Flag := SCF_SELECTION
  else Flag := 0;
  if RichEdit.HandleAllocated then
    SendStructMessage(RichEdit.Handle, EM_SETCHARFORMAT, Flag, Format);
end;

procedure TMyTextAttributes.SetBGColor(Value: TColor);
var
  Format: TCharFormat2;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_BACKCOLOR;
    if Value = clWindow then
      dwEffects := CFE_AUTOCOLOR else
      crBackColor := ColorToRGB(Value);
  end;
  SetAttributes(Format);
end;


//-----------------------------------------------------------------------------
constructor TSongTextEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := AOwner as TWinControl;

  FSelAttributes := TMyTextAttributes.Create(Self, atSelected);
  FDefAttributes := TMyTextAttributes.Create(Self, atDefaultText);

  RegEx := TRegExpr.Create;
  RegEx.ModifierM := True;
  RegEx.ModifierI := True;
  RegEx.ModifierG := True;
  RegEx.Expression := '^(\[\d+:\d+:\d+\])';

//  MarkedTextItems := TList<TTextItem>.Create;
end;

destructor TSongTextEditor.Destroy;
begin
  RegEx.Free;

  inherited Destroy;
end;

procedure TSongTextEditor.WNDProc(var Message: TMessage);
var
  a: Integer;
begin
  if (Message.Msg = WM_PASTE) or (Message.Msg = WM_COPY) then
    a := 1;

  inherited;
end;

procedure TSongTextEditor.PasteMessage(var Message: TMessage);
var
  a: Integer;
begin
  if Message.Msg = WM_PASTE then
    a := 1;

  inherited;
end;

procedure TSongTextEditor.SetDefAttributes(Value: TMyTextAttributes);
begin
  DefAttributes.Assign(Value);
end;

procedure TSongTextEditor.SetSelAttributes(Value: TMyTextAttributes);
begin
  SelAttributes.Assign(Value);
end;

procedure TSongTextEditor.HighlightText(BeginPosition, EndPosition: Integer);
var CurPos, i : Integer;
    ValText: String;
    PreviusD, NextD: Integer;
    TextLen: Integer;
    TextItem: TTextItem;

    Find: TFindText;
    GetTextLengthEx: TGetTextLengthEx;

begin

  // Приводим текст к Линукс формату (RegEx только в этом случае работает корректно)
  ValText := Text;
  ValText := ValText.Replace(#$D#$A, #$D, [rfReplaceAll]);
  ValText := Copy(ValText, BeginPosition, EndPosition - BeginPosition + 1);

  // Поиск вхождений шаблона с начала текущего абзаца
  RegEx.InputString := ValText;


  // Снимаем выделение с остальной части текста абзаца
  SelStart := EndPosition - 1; //+ SelLength;
  SelLength := EndPosition - EndPosition;
  SelAttributes.BGColor := clWhite;

  // Ищем шаблоны в тексте
  if RegEx.Exec() then
  repeat

    // Выделение шаблона
    SelStart := EndPosition + RegEx.MatchPos[1] - 2;
    SelLength := RegEx.MatchLen[1];
    SelAttributes.BGColor := RGB(142, 243, 255);

  until not RegEx.ExecNext;


  GetTextLengthEx.flags := GTL_DEFAULT;
  GetTextLengthEx.codepage := 1200;
  TextLen := SendMessage(Handle, EM_GETTEXTLENGTHEX, WPARAM(@GetTextLengthEx), 0);

end;

procedure TSongTextEditor.Change;
var CurPos, i : Integer;
    ValText: String;
    PreviusD, NextD: Integer;
    TextLen: Integer;
    TextItem: TTextItem;

    Find: TFindText;
    GetTextLengthEx: TGetTextLengthEx;

    ParagraphBegin, ParagraphEnd: Integer;

begin
  inherited Change;

  CurPos:= SelStart;

  Find.lpstrText := #$D;
  Find.chrg.cpMin := CurPos;

  // Получаем начало текущего абзаца
  Find.chrg.cpMax := 0;
  PreviusD := SendStructMessage(Handle, EM_FINDTEXT, 0, Find);

  // Получаем конец текущего абзаца
  Find.chrg.cpMax := -1;
  NextD := SendStructMessage(Handle, EM_FINDTEXT, FR_DOWN, Find);

  // Коррекция начала текущего выделения
  if PreviusD = -1 then
    ParagraphBegin := 1
  else
    ParagraphBegin := PreviusD + 1;

  // Позиция окончания параграфа
  ParagraphEnd := NextD;

//  HighlightText(ParagraphBegin, ParagraphEnd);

  // Приводим текст к Линукс формату (RegEx только в этом случае работает корректно)
  ValText := Text;
  ValText := ValText.Replace(#$D#$A, #$D, [rfReplaceAll]);
  ValText := Copy(ValText, ParagraphBegin, ParagraphEnd - ParagraphBegin + 1);

  // Поиск вхождений шаблона с начала текущего абзаца
  RegEx.InputString := ValText;


  // Снимаем выделение с остальной части текста абзаца
  SelStart := ParagraphBegin - 1; //+ SelLength;
  SelLength := ParagraphEnd - ParagraphBegin;
  SelAttributes.BGColor := clWhite;

  // Ищем шаблоны в тексте
  if RegEx.Exec() then
  repeat

    // Выделение шаблона
    SelStart := ParagraphBegin + RegEx.MatchPos[1] - 2;
    SelLength := RegEx.MatchLen[1];
    SelAttributes.BGColor := RGB(142, 243, 255);

  until not RegEx.ExecNext;


  GetTextLengthEx.flags := GTL_DEFAULT;
  GetTextLengthEx.codepage := 1200;
  TextLen := SendMessage(Handle, EM_GETTEXTLENGTHEX, WPARAM(@GetTextLengthEx), 0);

  SelStart := CurPos;
  SelLength := 0;
  SelAttributes.BGColor := clWhite;

end;

procedure TSongTextEditor.KeyUp(var Key: Word; Shift: TShiftState);
var CurPos, i : Integer;
    ValText: String;
    PreviusD, NextD: Integer;
    TextLen: Integer;
    TextItem: TTextItem;

    Find: TFindText;
    GetTextLengthEx: TGetTextLengthEx;

    ParagraphBegin, ParagraphEnd: Integer;
  StartPos: Integer;

begin
  inherited KeyUp(Key, Shift);

  if (ssCtrl in Shift) and (key=86) then
  begin

      CurPos := SelStart;

      ParagraphBegin := 1;
      ParagraphEnd := TextLen;

    //  HighlightText(ParagraphBegin, ParagraphEnd);

      // Приводим текст к Линукс формату (RegEx только в этом случае работает корректно)
      ValText := Text;
      ValText := ValText.Replace(#$D#$A, #$D, [rfReplaceAll]);
      ValText := Copy(ValText, ParagraphBegin, ParagraphEnd - ParagraphBegin + 1);

      // Снимаем выделение с остальной части текста абзаца
      SelStart := ParagraphBegin - 1; //+ SelLength;
      SelLength := ParagraphEnd - ParagraphBegin;
      SelAttributes.BGColor := clWhite;

      // Поиск вхождений шаблона с начала текущего абзаца
      RegEx.InputString := ValText;

      StartPos := 1;
      // Ищем шаблоны в тексте
      while RegEx.ExecPos(StartPos) do
      begin

        // Выделение шаблона
        SelStart := ParagraphBegin + RegEx.MatchPos[1] - 2;
        SelLength := RegEx.MatchLen[1];

        StartPos := SelStart + SelLength;

        SelAttributes.BGColor := RGB(142, 243, 255);
        RegEx.InputString := ValText;

      end;


      GetTextLengthEx.flags := GTL_DEFAULT;
      GetTextLengthEx.codepage := 1200;
      TextLen := SendMessage(Handle, EM_GETTEXTLENGTHEX, WPARAM(@GetTextLengthEx), 0);

      SelStart := CurPos;
      SelLength := 0;
      SelAttributes.BGColor := clWhite;

  end;
end;

//-----------------------------------------------------------------------------
procedure Register;
begin
  RegisterComponents('WaveScreen', [TSongTextEditor]);
end;

end.
