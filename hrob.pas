unit HROB;

interface
uses MAT;

type {zaznam neboztika}
     tZaznam = record
       id:integer; 			{identificni cislo neboztika}
       jmeno:string; 			{jmeno neboztika}
       prijmeni:string;			{prijmeni neboztika}
       datum_narozeni:string;	        {datum narozeni}
       datum_umrti:string;		{datum umrti}
       id_hrob:integer;                 {identifikacni cislo hrobu}
     end;
     {prvek seznamu}
     pPr = ^tPr;
     tPr = record
       z:tZaznam;
       dal:pPr;   {odkaz na dalsiho}
       pred:pPr;  {odkaz na predhoziho}
     end;
     {seznam}
     pFr = ^tFr;
     tFR = object
       ZAC:pPr;
       KON:pPr;
       constructor INIT;  {inicializace}
       destructor DONE;   {destruktor}
       function PRIDEJ(h:tZaznam):boolean;             {prida zaznam na konec}
       function ODEBER(k:integer):boolean;             {odebere k-ty zaznam}
       function VRAT(k:integer;var h:tZaznam):boolean;       {vrati k-ty zaznam}
       function EMPTY:boolean;                               {vrati TRUE jestlize ve fronte nic neni}
       {#TR}
       procedure PROHOD(k1,k2:integer);                      {prohodi dva zaznamy}
     end;

implementation

constructor tFR.INIT;
begin
  new(ZAC);
  new(KON);
  KON := nil;
  ZAC := nil;
end;

destructor tFR.DONE;
var z1,z2:pPr;
begin
  z1 := ZAC;
  while (z1^.dal <> nil) do begin
    z2 := z1;
    z1 := z1^.dal;
    dispose(z2);
  end;
end;

function tFR.PRIDEJ(h:tZaznam):boolean;
{prida zaznam na konec seznamu}
var z1:pPr;
begin
  new(z1);
  z1^.z.id := h.id;
  z1^.z.jmeno := h.jmeno;
  z1^.z.prijmeni := h.prijmeni;
  z1^.z.datum_narozeni := h.datum_narozeni;
  z1^.z.datum_umrti := h.datum_umrti;
  z1^.z.id_hrob := h.id_hrob;
  z1^.pred := KON;
  z1^.dal := nil;
  if ZAC = nil then ZAC := z1
  else KON^.dal := z1;
  KON := z1;
  PRIDEJ := TRUE;
end;

function tFR.ODEBER(k:integer):boolean;
{odebere k-ty zaznam se seznamu}
var z1,z2,z3:pPr;
    i:integer;
    ok:boolean;
begin
  z1 := ZAC;
  i := 1;
  ok := FALSE;
  while (z1 <> nil) and (ok = FALSE) do begin
    if (k = i) then begin
      z2 := z1;
      ok := TRUE;
    end;
    z1 := z1^.dal;
    z3 := z2^.pred;
    inc(i);
  end;
  if (ok = TRUE) then begin
    if (z2 <> ZAC) and (z2 <> KON) then begin
      z3^.dal := z1;
      z1^.pred := z3;
    end;
    if (z2 = ZAC) then begin
      z1^.pred := nil;
      ZAC := z1;
    end;
    if (z2 = KON) then begin
      z3^.dal := nil;
      KON := z3;
    end;
    dispose(z2);
  end;
  ODEBER := ok;
end;

function tFR.VRAT(k:integer;var h:tZaznam):boolean;
{vrati k-ty zaznam se seznamu - vraci TRUE jestlize ho nasel, jinak FALSE}
var z1:pPr;
    i:integer;
    ok:boolean;
begin
  z1 := ZAC;
  i := 1;
  ok := FALSE;
  while (z1 <> nil) and (ok = FALSE) do begin
    if (k = i) then begin
      h := z1^.z;
      ok := TRUE;
    end;
    z1 := z1^.dal;
    inc(i);
  end;
  VRAT := ok;
end;

function tFR.EMPTY:boolean;
begin
 if ZAC = nil then EMPTY := TRUE
 else EMPTY := FALSE;
end;

{#TR}

procedure tFR.PROHOD(k1,k2:integer);
{prohodi dva zaznamy}
var z0,z1,z2,z1p,z1d,z2p,z2d:pPr;
    i:integer;
    f1,f2:boolean;
begin
  z0 := ZAC;
  i := 1;
  f1 := FALSE; f2 := FALSE;
  while (z0 <> nil) and ((f1 = FALSE) or (f2 = FALSE)) do begin
    if (i = k1) then begin
      z1 := z0;
      f1 := TRUE;
    end;
    if (i = k2) then begin
      z2 := z0;
      f2 := TRUE;
    end;
    z0 := z0^.dal;
    inc(i);
  end;
  if (f1 = TRUE) and (f2 = TRUE) then begin
    z1p := z1^.pred;
    z1d := z1^.dal;
    z2p := z2^.pred;
    z2d := z2^.dal;
    if (k2 - k1) = 1 then begin
      z1p^.dal := z2;
      z2^.pred := z1p;
      z2^.dal := z1;
      z1^.pred := z2;
      z1^.dal := z2d;
      z2d^.pred := z1;
    end;
    if (k2 - k1) > 1 then begin
      z1p^.dal := z2;
      z1d^.pred := z2;
      z2p^.dal := z1;
      z2d^.pred := z1;
      z2^.pred := z1p;
      z2^.dal := z1d;
      z1^.pred := z2p;
      z1^.dal := z2d;
    end;
    if (z1p = nil) then ZAC := z2;
    if (z2d = nil) then KON := z1;
  end;
end;

end.