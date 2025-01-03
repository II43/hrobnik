unit HRMENU;

interface

uses GRAPH,HROB,MAT;

{BARVY}
const B_AK = Green; {barva aktivni polozky}
      B_NO = White; {barva normalni polozky}
      B_ME = LightRed; {barva ostatnich informaci}
      B_BG = Black;  {barva pozadi}

type hMenu = object
       x,y:integer;             {souradnice menu}
       a,b:integer;             {od jake do jake polozky zobrazovat}
       np:integer;              {pocet polozek = pocet neboztiku}
       ap:integer;              {aktualni polozka}
       p:tFR;                   {fronta polozek prevzata z HROB.PAS}
       constructor Init(x1,y1,a1,b1:integer);    {inicializuje menu}
       procedure AB(a1,b1:integer);  {zmena zobrazeni odkad kam}
       procedure Vloz(h:tZaznam);          {vlozi polozku do menu}
       procedure Zobraz;                 {zobraz polozky}
       procedure Schovej;                {schova polozky}
       procedure AK(z:tZaznam;n:integer);    {polozka n - aktivni}
       procedure NO(z:tZaznam;n:integer);    {polozka n - normalni}
       procedure NE(z:tZaznam;n:integer);    {polozka n - negativni}
       procedure Prohod(k1,k2:integer);      {prohozeni polozek}
       procedure VZ(z:tZaznam;i:integer); {vypise zaznam}
       procedure VI;                      {vypise hlavicku}
       function NSTR:integer;             {vrati pocet stranek}
       function ASTR:integer;             {vraci aktualni stranku}
       {#K}
       procedure UP;                      {kurzor nahoru}
       procedure DOWN;                    {kurzor dolu}
       procedure pgDOWN;                  {dasli stranka}
       procedure pgUP;                    {predchozi stranka}
       procedure DEL;                     {smaze aktualni polozku}
       procedure INSERT(h:tZaznam);       {prida zaznam h nakonec}
       {TR}
       procedure S1; {setrizeni seznamu podle id}
       procedure S2; {setrizeni seznamu podle jmena}
       procedure S3; {setrizeni seznamu podle prijmeni}
       procedure S4; {setrizeni seznamu podle hrobu}

     end;

implementation

constructor hMenu.Init(x1,y1,a1,b1:integer);
begin
  np := 0;
  ap := 0;
  x := x1;
  y := y1;
  a := a1;
  b := b1;
  p.INIT;
end;

procedure hMenu.AB(a1,b1:integer);
begin
  Schovej;
  a := a1;
  b := b1;
  Zobraz;
end;

procedure hMenu.Vloz(h:tZaznam);
begin
  p.PRIDEJ(h);
  if (np = 0) then ap := 1;
  inc(np);
end;


procedure hMenu.Zobraz;
var z:tZaznam;
    i,j:integer;
begin
  j := 0;
  setcolor(B_ME);
  VI;
  for i:=a to b do begin
    p.VRAT(i,z);
    if (ap = i) then begin
      AK(z,j);
    end
    else NO(z,j);
    inc(j);
  end;
end;

procedure hMenu.Schovej;
var z:tZaznam;
    i,j:integer;
begin
  j := 0;
  setcolor(B_BG);
  VI;
  for i:=a to b do begin
    p.VRAT(i,z);
    NE(z,j);
    inc(j);
  end;
end;

procedure hMenu.AK(z:tZaznam;n:integer);
begin
  setcolor(B_AK);
  VZ(z,n);
end;

procedure hMenu.NO(z:tZaznam;n:integer);
begin
  setcolor(B_NO);
  VZ(z,n);
end;

procedure hMenu.NE(z:tZaznam;n:integer);
begin
  setcolor(B_BG);
  VZ(z,n);
end;

procedure hMenu.Prohod(k1,k2:integer);
begin
 p.PROHOD(k1,k2);
end;

procedure hMenu.VZ(z:tZaznam;i:integer);
begin
  SetTextStyle(2,0,4);
  OutTextXY(x+5,y+70+(i*15),ST(z.id));
  OutTextXY(x+30,y+70+(i*15),z.jmeno);
  OutTextXY(x+180,y+70+(i*15),z.prijmeni);
  OutTextXY(x+320,y+70+(i*15),z.datum_narozeni);
  OutTextXY(x+420,y+70+(i*15),z.datum_umrti);
  OutTextXY(x+520,y+70+(i*15),ST(z.id_hrob));
end;

procedure hMenu.VI;
begin
  SetTextStyle(2,0,6);
  OutTextXY(x,y,'HROBNIK 2.0');
  OutTextXY(x,y+25,ST(ASTR)+' / '+ST(NSTR)+'  pocet neboztiku: '+ST(np)+'    '+'F1 - HROBNIKOVA POMOC');
  SetTextStyle(2,0,4);
  OutTextXY(x+5,y+50,'id');
  OutTextXY(x+30,y+50,'jmeno');
  OutTextXY(x+180,y+50,'prijmeni');
  OutTextXY(x+320,y+50,'datum narozeni');
  OutTextXY(x+420,y+50,'datum umrti');
  OutTextXY(x+520,y+50,'hrob');
end;

function hMenu.NSTR:integer;
{vraci pocet stranek za predpokladu ze je 10 zaznamu na stranku}
begin
  if (np mod 10) = 0 then NSTR := (np div 10)
  else NSTR := (np div 10) + 1;
end;

function hMenu.ASTR:integer;
{vraci aktualni stranku za predpoklady ze je 10 zaznamu na stranku}
begin
  if (ap mod 10) = 0 then ASTR := (ap div 10)
  else ASTR := (ap div 10) + 1;
end;

{#K}
procedure hMenu.UP;
var z:tZaznam;
begin
  if (ap = a) and (ap <> 1) then begin
    Schovej;
    pgUP;
    Zobraz;
  end
  else begin
    if (ap > a) then begin
      p.VRAT(ap,z);
      NO(z,ap-((ASTR-1)*10)-1);
      dec(ap);
      p.VRAT(ap,z);
      AK(z,ap-((ASTR-1)*10)-1);
    end;
  end;
end;

procedure hMenu.DOWN;
var z:tZaznam;
begin
  if (ap = b) and (ap <> np) then begin
    Schovej;
    pgDOWN;
    Zobraz;
  end
  else begin
    if (ap < b) then begin
      p.VRAT(ap,z);
      NO(z,ap-((ASTR-1)*10)-1);
      inc(ap);
      p.VRAT(ap,z);
      AK(z,ap-((ASTR-1)*10)-1);
    end;
  end;
end;

procedure hMenu.pgDOWN;
begin
  Schovej;
  if (np > b) then begin
    a := a + 10;
    b := b + 10;
    if (b > np) then b := np;
  end;
  ap := a;
  Zobraz;
end;

procedure hMenu.pgUP;
begin
  Schovej;
  if (ap > 10) then begin
    a := a - 10;
    b := (a + 10) - 1;
  end;
  ap := b;
  Zobraz;
end;

procedure hMenu.DEL;
begin
  Schovej;
  if (p.ODEBER(ap) = TRUE) then begin
    dec(np);
    if (np < b) then b := np;
    if (ap > ((ASTR-1)*10)+1) then dec(ap);
    if (np < ((ASTR-1)*10)+1) then pgUP;
  end;
  Zobraz;
end;

procedure hMenu.INSERT(h:tZaznam);
var sch:boolean;
begin
  Vloz(h);
  if (ASTR = NSTR) and (np < (NSTR*10)+1) then inc(b);
  Zobraz;
end;

{#TR - BUBBLESORT}
procedure hMenu.S1;
var dv:boolean;
    i,j:integer;
    n1,n2:tZaznam;
begin
  j := 1;
  repeat
    dv := FALSE;
    for i:=1 to (np-j) do begin
      p.VRAT(i,n1);
      p.VRAT(i+1,n2);
      if n1.id > n2.id then begin
        Prohod(i,i+1);
        dv := TRUE;
      end;
    end;
    inc(j);
  until not dv {neboli ze nedoslo jiz k zadne zmene}
end;

procedure hMenu.S2;
var dv:boolean;
    i,j:integer;
    n1,n2:tZaznam;
begin
  j := 1;
  repeat
    dv := FALSE;
    for i:=1 to (np-j) do begin
      p.VRAT(i,n1);
      p.VRAT(i+1,n2);
      if n1.jmeno > n2.jmeno then begin
        Prohod(i,i+1);
        dv := TRUE;
      end;
    end;
    j := j + 1;
  until not dv {neboli ze nedoslo jiz k zadne zmene}
end;

procedure hMenu.S3;
var dv:boolean;
    i,j:integer;
    n1,n2:tZaznam;
begin
  j := 1;
  repeat
    dv := FALSE;
    for i:=1 to (np-j) do begin
      p.VRAT(i,n1);
      p.VRAT(i+1,n2);
      if n1.prijmeni > n2.prijmeni then begin
        Prohod(i,i+1);
        dv := TRUE;
      end;
    end;
    j := j + 1;
  until not dv {neboli ze nedoslo jiz k zadne zmene}
end;

procedure hMenu.S4;
var dv:boolean;
    i,j:integer;
    n1,n2:tZaznam;
begin
  j := 1;
  repeat
    dv := FALSE;
    for i:=1 to (np-j) do begin
      p.VRAT(i,n1);
      p.VRAT(i+1,n2);
      if n1.id_hrob > n2.id_hrob then begin
        Prohod(i,i+1);
        dv := TRUE;
      end;
    end;
    inc(j);
  until not dv {nedoslo jiz k zadne zmene}
end;

end.


