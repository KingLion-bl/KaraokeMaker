unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Vcl.MPlayer, Vcl.ComCtrls, WaveScreen, Vcl.StdCtrls,
  Vcl.Grids, Vcl.ValEdit, SongTextEditor;

type

  TMainForm = class(TForm)
    Panel1: TPanel;
    MediaPlayer: TMediaPlayer;
    WaveScreen: TWaveScreen;
    Timer: TTimer;
    AutoScroll: TCheckBox;
    Button1: TButton;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Button2: TButton;
    Panel2: TPanel;
    StringGrid1: TStringGrid;


    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MediaPlayerClick(Sender: TObject; Button: TMPBtnType;
      var DoDefault: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure WaveScreenPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AutoScrollClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure StringGrid1GetEditMask(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);

  private
    { Private declarations }
//    OldWindowProc: TWndMethod;
//    procedure NewEditWindowProc(var Message: TMessage);

  public

    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses Winapi.RichEdit;

{$R *.dfm}

procedure TMainForm.FormResize(Sender: TObject);
begin
  WaveScreen.Repaint;
end;

procedure TMainForm.MediaPlayerClick(Sender: TObject; Button: TMPBtnType;
        var DoDefault: Boolean);
begin

    case Button of
      TMPBtnType.btPlay: Timer.Enabled := True;
      TMPBtnType.btPause:
        case MediaPlayer.Mode of
          mpPlaying: Timer.Enabled := False;
          mpPaused:  Timer.Enabled := True;
        end;
      TMPBtnType.btStop: Timer.Enabled := False;
    end;

end;

procedure TMainForm.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  curText: string;
  curTextWidth: Integer;
  curTextHeight: Integer;
begin

  if (ACol = 0) and not(gdFixed in State) then
    with StringGrid1.Canvas do
      begin
        Brush.Color := clAqua;
        Rectangle(Rect);

        curText := StringGrid1.Cells[ACol, ARow];

        curTextWidth := TextWidth(curText);
        curTextHeight := TextHeight(curText);

        TextOut(Rect.Left + (Rect.Width - curTextWidth) div 2,
                Rect.Top +  (Rect.Height - curTextHeight) div 2,
                curText);
      end;

end;

procedure TMainForm.StringGrid1GetEditMask(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
begin
  if ACol = 0 then
    Value := '00.00.00';
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  WaveScreen.CursorPositionAsTime := MediaPlayer.Position / 1000;
  WaveScreen.Repaint;
end;

procedure TMainForm.WaveScreenPaintBoxMouseDown(Sender: TObject;
          Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var PlayAfterSetPosition: Boolean;
    AutoScroll: Boolean;
begin
  Timer.Enabled := False;

  AutoScroll := WaveScreen.AutoScroll;
  WaveScreen.AutoScroll := False;

  WaveScreen.CursorPositionAsSamples := WaveScreen.SampleByX(X);
  WaveScreen.Repaint;

  PlayAfterSetPosition := MediaPlayer.Mode = mpPlaying;
  MediaPlayer.Position := Round(WaveScreen.CursorPositionAsTime * 1000);

  if PlayAfterSetPosition then
    MediaPlayer.Play;

  WaveScreen.AutoScroll := AutoScroll;

  Timer.Enabled := True;
end;

procedure TMainForm.AutoScrollClick(Sender: TObject);
begin
  WaveScreen.AutoScroll := AutoScroll.Checked;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  WaveScreen.ShowCursorAtScreenCenter;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var Res: Boolean;
    i: integer;
    Text: String;
begin
  //SetWindowLong(Button2.Handle, GWL_STYLE, GetWindowLong(Button2.Handle, GWL_STYLE) OR BS_MULTILINE);

 // SongTextEditor.SelAttributes.BGColor := clRed;
end;

//procedure TMainForm.NewEditWindowProc(var Message: TMessage);
//begin
//
//  // перехватываем сообщение о вставке
//  if Message.Msg = WM_PASTE then
//    SongTextEditor.Text := 'Вставка!!!'
//  else
//    OldWindowProc(Message);
//
//end;

procedure TMainForm.FormCreate(Sender: TObject);
var FileName: string;
begin

//  // Запоминаем старую оконную процедуру
//  OldWindowProc := SongTextEditor.WindowProc;
//  // Заменяем ее новой
//  SongTextEditor.WindowProc := NewEditWindowProc;


  FileName:= 'wave-16.wav';
  MediaPlayer.FileName := ExtractFilePath(ParamStr(0)) + FileName;

  WaveScreen.OpenMedia(MediaPlayer.FileName);
  WaveScreen.CursorPositionAsSamples := 0;

  MediaPlayer.Open;

end;

end.
