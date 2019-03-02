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
    SongTextEditor: TSongTextEditor;


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
//  // ������������� ��������� � �������
//  if Message.Msg = WM_PASTE then
//    SongTextEditor.Text := '�������!!!'
//  else
//    OldWindowProc(Message);
//
//end;

procedure TMainForm.FormCreate(Sender: TObject);
var FileName: string;
begin

//  // ���������� ������ ������� ���������
//  OldWindowProc := SongTextEditor.WindowProc;
//  // �������� �� �����
//  SongTextEditor.WindowProc := NewEditWindowProc;


  FileName:= 'wave-16.wav';
  MediaPlayer.FileName := ExtractFilePath(ParamStr(0)) + FileName;

  WaveScreen.OpenMedia(MediaPlayer.FileName);
  WaveScreen.CursorPositionAsSamples := 0;

  MediaPlayer.Open;

end;

end.
