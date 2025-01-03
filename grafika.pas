unit GRAFIKA;

interface

uses GRAPH,CRT;
var grDriver,grMode,grError:integer;
procedure grINIT;
procedure grEND;
procedure grCRT;
procedure grRESTORE;

function grREAD(x,y:integer):string;

implementation
const K_ENTER = chr(13);
      K_ESC   = chr(27);

procedure grINIT;
begin
  grDriver := Detect;
  InitGraph(grDriver, grMode,'c:\prog_1\bp70\bgi');
  grError := GraphResult;
  if grError <> grOk then begin
    writeln('chyba grafiky: ');
    writeln(GraphErrorMsg(grError));
    writeln('program ukoncen...');
    halt(1);
  end;
end;

procedure grEND;
begin
  CloseGraph;
end;

procedure grCRT;
begin
  RestoreCrtMode;
end;

procedure grRESTORE;
begin
  SetGraphMode(grMode);
end;

function grREAD(x,y:integer):string;
var s:string;
    c:char;
begin
  s := '';
  repeat
    c := ReadKey;
    if (c <> K_ENTER) or (c <> K_ESC) then begin
      s := s + c;
      OutTextXY(x,y,c);
      x := x + TextWidth(c);
    end;
  until (c = K_ENTER) or (c = K_ESC);
  grREAD := s;
end;

end.