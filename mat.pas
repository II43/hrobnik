unit MAT; {MATEMATICKE FUNKCE A PROCEDURY}

interface

function PWR(c,m:integer):integer; {vrati m-tou mocninu cisla c}
function ST(n:integer):string;     {vraci n ve forme string}
function TS(s:string):integer;     {vraci s ve forme integer}
function AMIN(rez1:string;rez2:string):boolean;  {porovnani dvou retezcu}
function MIN(c1:integer;c2:integer):boolean; {porovnani dvou cisel}


implementation

function PWR(c,m:integer):integer;
var i,vys:integer;
begin
  vys := c;
  for i:=1 to m-1 do begin
    vys := c*vys;
  end;
  PWR := vys;
end;

function ST(n:integer):string;
var j,i,zb,pos,ic,x:integer;
    s:string;
begin
  ic := 0;
  x := n;
  s := '';
  repeat
    inc(ic);
    x := x div 10;
  until x = 0;
  x := n;
  i := 0;
  repeat
    if ic = 1 then zb := (x mod PWR(10,ic))
    else begin
      zb := (x mod PWR(10,ic)) - (x mod PWR(10,ic-1));
      zb := zb div PWR(10,ic-1);
    end;
    dec(ic);
    s :=  s + chr(ord('0')+zb);
  until ic = 0;
  ST := s;
end;

function TS(s:string):integer;
var i,n:integer;
begin
  i := 1;
  n := 0;
  while (s[i] >= '0') and (s[i] <= '9') do begin
    n := n * 10;
    n := n + (ord(s[i]) - ord('0'));
    inc(i);
  end;
  TS := n;
end;

function AMIN(rez1:string;rez2:string):boolean;
{porovna dve rezetce a vrati TRUE jestlize rez1 je abecedne mensi nez rez2}
var nasel_reseni:boolean;
var pozice:integer;
begin
  nasel_reseni := FALSE;
  pozice := 1;
  AMIN := FALSE;
  while nasel_reseni = FALSE do begin
    if rez1[pozice] < rez2[pozice] then begin
      AMIN := TRUE;
      nasel_reseni := TRUE;
    end;     
    if rez1[pozice] > rez2[pozice] then begin
      AMIN := FALSE;
      nasel_reseni := TRUE;
    end;
    inc(pozice);
  end;  
end;

function MIN(c1:integer;c2:integer):boolean;
{porovna dve cisla a vrati TRUE jestilize c1 je mensi nez c2}
begin
  MIN := FALSE;
  if c1 < c2 then MIN := TRUE;
end;

end.