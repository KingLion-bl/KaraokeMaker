unit MyWav;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses MyType;

type
  TSimpleWavHead = packed record
    RIFF: array [0 .. 3] of AnsiChar;
    RIFFcksize: UInt32;
    WaveID: array [0 .. 3] of AnsiChar;
    FormatCkID: array [0 .. 3] of AnsiChar;
    FormatCkSize: UInt32;
    wFormatTag: UInt16;
    wChannels: UInt16;
    dwSamplesPerSec: UInt32;
    dwAvgBytesPerSec: UInt32;
    wBlockAlign: UInt16;
    wBitsPerSample: UInt16;
    DataID: array [0 .. 3] of AnsiChar;
    DataSize: UInt32;
  end;

  // —читывает данные в Real в зависимости от числа каналов.
procedure ReadWave(name: String; var Head: TSimpleWavHead;
  var Data: TArrayArrayReal; var dwSamplesPerSec: DWord);
procedure WriteWave(name: String; Data: TArrayArrayReal;
  dwSamplesPerSec: DWord);

implementation

procedure ReadWave(name: String; var Head: TSimpleWavHead;
  var Data: TArrayArrayReal; var dwSamplesPerSec: DWord);
var
  f: File;
  i, j: Integer;
  b: Byte;
  w: SmallInt;
  l: Integer;
begin
  AssignFile(f, name);
  reset(f, 1);
  BlockRead(f, Head, SizeOf(Head));
  SetLength(Data, Head.wChannels);
  dwSamplesPerSec := Head.dwSamplesPerSec;

  for j := 0 to Head.wChannels - 1 do
  begin
    SetLength(Data[j], ((Head.DataSize div Head.wChannels) * 8)
      div Head.wBitsPerSample);
  end;

  if Head.wBitsPerSample = 8 then
  begin
    for i := 0 to Length(Data[0]) - 1 do
      for j := 0 to Length(Data) - 1 do
      begin
        BlockRead(f, b, SizeOf(b));
        Data[j][i] := b;
      end;
  end;

  if Head.wBitsPerSample = 16 then
  begin
    for i := 0 to Length(Data[0]) - 1 do
      for j := 0 to Length(Data) - 1 do
      begin
        BlockRead(f, w, SizeOf(w));
        Data[j][i] := w;
      end;
  end;

  if Head.wBitsPerSample = 32 then
  begin
    for i := 0 to Length(Data[0]) - 1 do
      for j := 0 to Length(Data) - 1 do
      begin
        BlockRead(f, l, SizeOf(l));
        Data[j][i] := l;
      end;
  end;

  Close(f);
end;

procedure WriteWave(name: String; Data: TArrayArrayReal;
  dwSamplesPerSec: DWord);
begin
end;

end.
