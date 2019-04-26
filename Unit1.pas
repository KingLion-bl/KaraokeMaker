unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Vcl.MPlayer, Vcl.ComCtrls, WaveScreen, Vcl.StdCtrls,
  Vcl.Grids, Vcl.ValEdit, SongTextGrid, System.Actions, Vcl.ActnList, Vcl.Menus;

type

  TMainForm = class(TForm)
    Panel1: TPanel;
    Timer: TTimer;
    AutoScroll: TCheckBox;
    Button1: TButton;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel4: TPanel;
    MediaPlayer: TMediaPlayer;
    WaveScreen: TWaveScreen;
    SongTextTable: TSongTextGrid;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ActionList1: TActionList;
    SaveProjectAction: TAction;
    OpenProjectAction: TAction;


    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MediaPlayerClick(Sender: TObject; Button: TMPBtnType;
      var DoDefault: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure AutoScrollClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WaveScreenSelectPosition(Sender: TObject;
      Time: Extended);

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

procedure TMainForm.WaveScreenSelectPosition(Sender: TObject;
  Time: Extended);
var curRow: Integer;
    TimeAsInt, Hours, Minutes, Seconds: Integer;
    PlayAfterSetPosition: Boolean;
    AutoScroll: Boolean;
begin

  Timer.Enabled := False;

  AutoScroll := WaveScreen.AutoScroll;
  WaveScreen.AutoScroll := False;

  WaveScreen.CursorPositionAsTime := Time;
  WaveScreen.Repaint;

  PlayAfterSetPosition := MediaPlayer.Mode = mpPlaying;
  MediaPlayer.Position := Round(WaveScreen.CursorPositionAsTime * 1000);

  if PlayAfterSetPosition then
    MediaPlayer.Play;

  WaveScreen.AutoScroll := AutoScroll;

  Timer.Enabled := True;


  curRow := SongTextTable.Row;
  SongTextTable.TimePoints[curRow] := Time;

end;

procedure TMainForm.AutoScrollClick(Sender: TObject);
begin
  WaveScreen.AutoScroll := AutoScroll.Checked;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  WaveScreen.ShowCursorAtScreenCenter;
end;


procedure TMainForm.FormCreate(Sender: TObject);
var FileName: string;
begin

  FileName:= 'wave-16.wav';
  MediaPlayer.FileName := ExtractFilePath(ParamStr(0)) + FileName;

  WaveScreen.OpenMedia(MediaPlayer.FileName);
  WaveScreen.CursorPositionAsSamples := 0;

  MediaPlayer.Open;

end;

end.
