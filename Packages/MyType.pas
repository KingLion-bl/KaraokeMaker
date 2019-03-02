unit MyType;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses SysUtils, Math;

const
  uf0Unit = 0;
  uf1Unit = 1;
  uf2Unit = 2;
  uf3Unit = 3;
  uf4Unit = 4;

type
  DWord = Cardinal;
  Int = Integer;
  TUnitFormat = DWord;

  Complex = Packed record
    Re, Im: Real;
  end;

  Complex_Extended = Packed record
    Re, Im: Extended;
  end;

  Complex_Full = Packed record
    Im, Re: Real;
    A, R: Real;
  end;

  TInterval = Record
    Min, Max: Integer;
  end;

  // ������������ �������
  TArrayByte = array of Byte;
  TArrayShortInt = array of ShortInt;
  TArrayWord = array of Word;
  TArraySmallint = array of Smallint;
  TArrayDWord = array of DWord;
  TArrayInt = array of Integer;
  TArrayInt64 = array of Int64;
  TArrayPointer = array of Pointer;

  TArraySingle = array of Single;
  TArrayDouble = array of Double;
  TArrayReal = array of Real;

  TArrayComplex = array of Complex;

  // ������������ �������
  TAByte = array [0 .. 65536] of Byte;
  PAByte = ^TAByte;
  TAShortInt = array [0 .. 65536] of ShortInt;
  PAShortInt = ^TAShortInt;

  TAWord = array [0 .. 65536] of Word;
  PAWord = ^TAWord;
  TASmallint = array [0 .. 65536] of Smallint;
  PASmallint = ^TASmallint;
  TADWord = array [0 .. 65536] of DWord;
  PADWord = ^TADWord;
  TAInt = array [0 .. 65536] of Integer;
  PAInt = ^TAInt;

  TAPointer = array [0 .. 65536] of Pointer;
  PAPointer = ^TAPointer;

  TAReal = array [0 .. 65536] of Real;
  PAReal = ^TAReal;
  PReal = ^Real;

  TAComplex = array [0 .. 65536] of Complex;
  PAComplex = ^TAComplex;
  PComplex = ^Complex;

  TAComplex_Extended = array [0 .. 65536] of Complex_Extended;
  PAComplex_Extended = ^TAComplex_Extended;

  // �������   j,i  ��� j �������� ������ i �������
  TMatrix22Int = array [0 .. 1, 0 .. 1] of Integer;
  TMatrix22Real = array [0 .. 1, 0 .. 1] of Real;
  TMatrix22 = TMatrix22Real;

  TMatrix33Int = array [0 .. 2, 0 .. 2] of Integer;
  TMatrix33Real = array [0 .. 2, 0 .. 2] of Real;
  TMatrix33 = TMatrix33Real;

  TMatrix44Int = array [0 .. 3, 0 .. 3] of Integer;
  TMatrix44Real = array [0 .. 3, 0 .. 3] of Real;
  TMatrix44 = TMatrix44Real;

  TArrayArrayReal = array of TArrayReal;
  TArrayArrayInt = array of TArrayInt;
  TArrayArrayComplex = array of TArrayComplex;
  TMatrixNN = TArrayArrayReal;
  TMatrixNM = TArrayArrayReal;

  // �������
  TVectorN = TArrayReal;

  TVector2Int = array [0 .. 1] of Integer;
  TVector2Real = array [0 .. 1] of Real;
  TVector2 = TVector2Real;

  TVector3Int = array [0 .. 2] of Integer;
  TVector3Real = array [0 .. 2] of Real;
  TVector3 = TVector3Real;

  TRGBA = record
    R, g, b, A: Byte;
  end;

  TBGRA = record
    b, g, R, A: Byte;
  end;

  TRGB = packed record
    R, g, b: Byte;
  end;

  TBGR = packed record
    b, g, R: Byte;
  end;

  THSV = packed record
    h, s, v: Byte;
  end;

  T3Byte = packed record
    a1, a2, a3: Byte;
  end;

  T4Byte = packed record
    a1, a2, a3: Byte;
  end;

  TArrayRGB = array [0 .. 65536] of TRGB;
  PArrayRGB = ^TArrayRGB;

  TArrayBGR = array [0 .. 65536] of TBGR;
  PArrayBGR = ^TArrayBGR;

  TArrayHSV = array [0 .. 65536] of THSV;
  PArrayHSV = ^TArrayHSV;

  TArray3Byte = array [0 .. 65536] of T3Byte;
  PArray3Byte = ^TArray3Byte;

  TArray4Byte = array [0 .. 65536] of T4Byte;
  PArray4Byte = ^TArray4Byte;

  TVector4Int = array [0 .. 3] of Integer;
  TVector4Real = array [0 .. 3] of Real;
  TVector4 = TVector4Real;

  TPoint2DInt = record
    x, y: Integer;
  end;

  TPoint2DReal = record
    x, y: Real;
  end;

  TPoint3DInt = record
    x, y, z: Integer;
  end;

  TPoint3DReal = record
    x, y, z: Real;
  end;

  TMyRectInt = packed record
    case Integer of
      0:
        (x1, y1, x2, y2: Integer);
      1:
        (P1, P2: TPoint2DInt);
      2:
        (V1, V2: TVector2Int);
  end;

  TArrayPoint2DInt = array of TPoint2DInt;
  TArrayPoint2DReal = array of TPoint2DReal;

  PListNode = ^TListNode;

  TListNode = record
    Data: Pointer;
    Next: PListNode;
  end;

  TThreshMode = (THRESH_BINARY, THRESH_BINARY_INV, THRESH_TRUNC, THRESH_TOZERO,
    THRESH_TOZERO_INV);
  TStepSelector = (ssN, ssNW, ssW, ssSW, ssS, ssSE, ssE, ssNE);
  TCountur = array of TStepSelector;
  TArrayContur = array of TCountur;

procedure CopyInRe(var z: TArrayComplex; A: TArrayReal); Overload;
procedure CopyInRe(N: Integer; z: PAComplex; A: PAReal); Overload;
procedure CopyInRe(N: Integer; z: TArrayComplex; zIndex: Integer; A: TArrayReal;
  aIndex: Integer); Overload;
procedure CopyFromRe(var A: TArrayReal; z: TArrayComplex); Overload;
procedure CopyFromRe(N: Integer; A: PAReal; z: PAComplex); Overload;
procedure CopyFromRe(N: Integer; A: TArrayReal; aIndex: Integer;
  z: TArrayComplex; zIndex: Integer); Overload;
procedure CopyInIm(N: Integer; z: PAComplex; A: PAReal); Overload;
procedure CopyFromIm(N: Integer; A: PAReal; z: PAComplex); Overload;

// ���������� � ��������
procedure SaveArray(A: TArrayReal; FileName: String); Overload;
procedure LoadArray(var A: TArrayReal; FileName: String); Overload;

procedure SaveArray(A: TArrayInt; FileName: String); Overload;
procedure LoadArray(var A: TArrayInt; FileName: String); Overload;

function Point2DReal(x, y: Real): TPoint2DReal;
function Point3DReal(x, y, z: Real): TPoint3DReal;

function Point2DInt(x, y: Integer): TPoint2DInt;
function Point3DInt(x, y, z: Integer): TPoint3DInt;

implementation

function Point2DReal(x, y: Real): TPoint2DReal;
begin
  Result.x := x;
  Result.y := y;
end;

function Point3DReal(x, y, z: Real): TPoint3DReal;
begin
  Result.x := x;
  Result.y := y;
  Result.z := z;
end;

function Point2DInt(x, y: Integer): TPoint2DInt;
begin
  Result.x := x;
  Result.y := y;
end;

function Point3DInt(x, y, z: Integer): TPoint3DInt;
begin
  Result.x := x;
  Result.y := y;
  Result.z := z;
end;

procedure CopyFromRe(N: Integer; A: PAReal; z: PAComplex);
var
  i: Integer;
begin
  for i := 0 to N - 1 do
    A[i] := z[i].Re;
end;

procedure CopyFromRe(var A: TArrayReal; z: TArrayComplex);
var
  i, N: Integer;
begin
  N := Length(z);
  SetLength(A, N);
  for i := 0 to N - 1 do
    A[i] := z[i].Re;
end;

procedure CopyFromRe(N: Integer; A: TArrayReal; aIndex: Integer;
  z: TArrayComplex; zIndex: Integer);
var
  i: Integer;
begin
  for i := 0 to N - 1 do
    if (aIndex + i < Length(A)) and ((zIndex + i < Length(z))) then
      A[aIndex + i] := z[zIndex + i].Re;
end;

procedure CopyFromIm(N: Integer; A: PAReal; z: PAComplex);
var
  i: Integer;
begin
  for i := 0 to N - 1 do
    A[i] := z[i].Im;
end;

procedure CopyInRe(var z: TArrayComplex; A: TArrayReal); Overload;
var
  i, N: Integer;
begin
  N := Length(A);
  SetLength(z, N);
  for i := 0 to N - 1 do
    z[i].Re := A[i];
end;

procedure CopyInRe(N: Integer; z: PAComplex; A: PAReal);
var
  i: Integer;
begin
  for i := 0 to N - 1 do
    z[i].Re := A[i];
end;

procedure CopyInRe(N: Integer; z: TArrayComplex; zIndex: Integer; A: TArrayReal;
  aIndex: Integer);
var
  i: Integer;
begin
  for i := 0 to N - 1 do
    if (aIndex + i < Length(A)) and ((zIndex + i < Length(z))) then
      z[zIndex + i].Re := A[aIndex + i];
end;

procedure CopyInIm(N: Integer; z: PAComplex; A: PAReal);
var
  i: Integer;
begin
  for i := 0 to N - 1 do
    z[i].Im := A[i];
end;

// ���������� � ��������
procedure SaveArray(A: TArrayReal; FileName: String); Overload;
var
  f: Text;
  f1: File;
  i: Integer;
  Ext: String;
begin
  Ext := ExtractFileExt(FileName);
  if StrUpper(PChar(Ext)) = 'TXT' then
  begin
    AssignFile(f, FileName);
    Rewrite(f);
    For i := 0 to Length(A) - 1 do
      WriteLn(f, A[i]);
    CloseFile(f);
  end;
  if StrUpper(PChar(Ext)) = 'BIN' then
  begin
    AssignFile(f1, FileName);
    Rewrite(f1);
    BlockWrite(f1, A[0], Length(A) * SizeOf(A[0]));
    CloseFile(f1);
  end;
end;

procedure LoadArray(var A: TArrayReal; FileName: String); Overload;
begin

end;

procedure SaveArray(A: TArrayInt; FileName: String); Overload;
var
  f: Text;
  f1: File;
  i: Integer;
  Ext: String;
begin
  Ext := ExtractFileExt(FileName);
  if StrUpper(PChar(Ext)) = '.TXT' then
  begin
    AssignFile(f, FileName);
    Rewrite(f);
    For i := 0 to Length(A) - 1 do
      WriteLn(f, A[i]);
    CloseFile(f);
  end;
  if StrUpper(PChar(Ext)) = '.BIN' then
  begin
    AssignFile(f1, FileName);
    Rewrite(f1);
    BlockWrite(f1, A[0], Length(A) * SizeOf(A[0]));
    CloseFile(f1);
  end;
end;

procedure LoadArray(var A: TArrayInt; FileName: String); Overload;
begin

end;

end.
