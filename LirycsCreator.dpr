program LirycsCreator;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  MyType in 'MyType.pas',
  MyWav in 'MyWav.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

end.
