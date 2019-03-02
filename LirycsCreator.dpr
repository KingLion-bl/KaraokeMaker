program LirycsCreator;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  MyType in 'Packages\MyType.pas',
  MyWav in 'Packages\MyWav.pas',
  SongTextEditor in 'Packages\SongTextEditor.pas',
  RegExpr in 'Packages\RegExpr.pas',
  WaveScreen in 'Packages\WaveScreen.pas',
  WaveScrollBar in 'Packages\WaveScrollBar.pas',
  PaintWave in 'Packages\PaintWave.pas',
  WavData in 'Packages\WavData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

end.
