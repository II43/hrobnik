program HROBNIK; {program urceny ke sprave hrbitova}

uses Crt;

type TDen = 1..31;
type TMesic = 1..12;

type TDatum = record
  den:TDen;
  mesic:TMesic;
  rok: integer;
end;

type TNeboztik = record 	{specifikace daneho neboztika}
  {promenne vztahujici se k neboztikovi samemu}
  id:integer; 			{identificni cislo neboztika}
  jmeno:string; 			{jmeno neboztika - maximalne 20 znaku}
  prijmeni:string;			{prijmeni neboztika - maximalne 15 znaku}
  datum_narozeni:TDatum;	{datum narozeni}
  datum_umrti:TDatum;		{datum umrti}
  {promenne vztahujici se k hrobu ve kterem je neboztik ulozen}
  id_hrob:integer;
end;

type TSoubor = file of TNeboztik;

var soubor:TSoubor;        		{globalni soubor, ktery je prave otevreny}
var a_jmenosouboru:string;  	{jmeno prave otevreneho souboru}
var konec:boolean;		{ukonceni programu ANO/NE}
var soubor_otevren:boolean;             {otevren nejaky soubor ANO/NE}
var pn:integer;			{celkovy pocet neboztiku v prave otevrenem souboru}

var ch_z,i_z:boolean; {promenne pro kontrolovani vypisu chybove a informativni zpravy}
var ch_zprava,i_zprava:string; {zpravy samotne}

procedure PUVODNIBARVY; {vrati nastavene barvy zpatky na dosovy standard}
begin
  textcolor(lightGray);
  textbackground(black);
end;

{#1 PROCEDURY PRO PRACI SE SOUBOREM}

procedure OTEVRINOVYSOUBOR(var soubor:TSoubor;jmenosouboru:string);
begin
  assign(soubor,jmenosouboru);
  rewrite(soubor);
end;

procedure OTEVRISOUBOR(var soubor:TSoubor;jmenosouboru:string);
begin
  assign(soubor,jmenosouboru);
  reset(soubor);
end;

procedure ZAVRISOUBOR(var soubor:TSoubor);
begin
  close(soubor);
end;

procedure ZAPISNEBOZTIKA(var soubor:TSoubor;n:TNeboztik);
begin
  write(soubor,n);
end;

procedure PRECTINEBOZTIKA(var soubor:TSoubor;var n:TNeboztik);
begin
  read(soubor,n);
end;

{#2 PROCEDURY PRO VYPIS NA OBRAZOVKU}

procedure VypisDatum(datum:TDatum); {vypise datum na obrazovku a neodradkuje}
begin
  write(datum.den:2,'.',datum.mesic:2,'.',datum.rok:4);
end;

procedure VypisNeboztika(n:TNeboztik); {vypise udaje o danem neboztikovi n na jeden radek a odradkuje}
begin
  write(n.id:4,n.jmeno:15,n.prijmeni:15,'':5);
  VypisDatum(n.datum_narozeni);
  write('':7);
  VypisDatum(n.datum_umrti);
  writeln('':7,n.id_hrob);
end;

procedure VypisZahlaviProVypisNeboztika; {vypise zahlavi pro proceduru VypisNeboztika}
begin
  textcolor(lightGreen);
  writeln('id':4,'jmeno':15,'prijmeni':15,'':5,'datum narozeni':10,'':3,'datum umrti':10,'idh':7);
  PuvodniBarvy;
end;

procedure VYPISVSECHNYNEBOZTIKY(var soubor:TSoubor); {vypise vsechny neboztiky z daneho souboru vcetne zahlavi}
var n:TNeboztik;
begin
  seek(soubor,0);
  VypisZahlaviProVypisNeboztika;
  while not eof(soubor) do begin
    PRECTINEBOZTIKA(soubor,n);  
    VypisNeboztika(n);
  end; 
end;

{#3 ZADAVANI NEBOZTIKA Z KLAVESNICE}

procedure VypisZahlaviProZadavaniNeboztika; {vypise zahlavi pro proceduru ZadejNeboztika}
begin
  textcolor(lightRed);
  writeln('id','':2,'jmeno','':10,'prijmeni','':7,'':5,'datum narozeni','':3,'datum umrti','':4,'idh');
  PuvodniBarvy;
end;

procedure PrevedDatum(var datum:TDatum;sdatum:string); {prevede retezec na format TDatum}
var pomocny_retezec:string;
var MistoChyby:integer;
begin
  {readln(sdatum);}
  if sdatum[2] = '.' then begin
    pomocny_retezec := copy(sdatum,1,1);
    val(pomocny_retezec,datum.den,MistoChyby);
    if sdatum[4] = '.' then begin
      pomocny_retezec := copy(sdatum,3,1);
      val(pomocny_retezec,datum.mesic,MistoChyby);
      pomocny_retezec := copy(sdatum,5,4);
      val(pomocny_retezec,datum.rok,MistoChyby);
    end;
    if sdatum[5] = '.' then begin
      pomocny_retezec := copy(sdatum,3,2);
      val(pomocny_retezec,datum.mesic,MistoChyby);
      pomocny_retezec := copy(sdatum,6,4);
      val(pomocny_retezec,datum.rok,MistoChyby);
    end;
  end;
  if sdatum[3] = '.' then begin
    pomocny_retezec := copy(sdatum,1,2);
    val(pomocny_retezec,datum.den,MistoChyby);
    if sdatum[5] = '.' then begin
      pomocny_retezec := copy(sdatum,4,1);
      val(pomocny_retezec,datum.mesic,MistoChyby);
      pomocny_retezec := copy(sdatum,6,4);
      val(pomocny_retezec,datum.rok,MistoChyby);
    end;
    if sdatum[6] = '.' then begin
      pomocny_retezec := copy(sdatum,4,2);
      val(pomocny_retezec,datum.mesic,MistoChyby);
      pomocny_retezec := copy(sdatum,7,4);
      val(pomocny_retezec,datum.rok,MistoChyby);
    end;
  end;
end;

function ZkontrolujDatum(d:TDatum):boolean;
var ok:boolean;
begin
  if (d.den > 0) and (d.den < 32) and (d.mesic > 0) and (d.mesic < 13) then ok := TRUE
  else ok := FALSE;
  ZkontrolujDatum := ok;
end;

procedure ResetDatum(var d:TDatum);
begin
  d.den := 1;
  d.mesic := 1;
  d.rok := 2000;
end;

procedure ZadejNeboztika(var n:TNeboztik;id:integer); {zadavani neboztika do jedne radky}
var radka:integer;
var sdatum:string;
begin
  radka := whereY;
  n.id := id;
  gotoXY(1,radka);
  writeln(n.id);
  gotoXY(5,radka);
  readln(n.jmeno);
  gotoXY(20,radka);
  readln(n.prijmeni);
  gotoXY(40,radka);
  readln(sdatum);
  PrevedDatum(n.datum_narozeni,sdatum);
  if ZkontrolujDatum(n.datum_narozeni) = FALSE then ResetDatum(n.datum_narozeni);
  gotoXY(57,radka);
  readln(sdatum);
  PrevedDatum(n.datum_umrti,sdatum);
  if ZkontrolujDatum(n.datum_umrti) = FALSE then ResetDatum(n.datum_umrti);
  gotoXY(72,radka);
  readln(n.id_hrob);
end;

function V_POCETNEBOZTIKU(var soubor:TSoubor):integer; {funkce vraci pocet neboztiku v souboru}
var n:TNeboztik;
var pn:integer;
begin
  seek(soubor,0);
  pn := 0;
  while not eof(soubor) do begin
    seek(soubor,filepos(soubor)+1);  
    pn := pn + 1;
  end;   
  V_POCETNEBOZTIKU := pn;
end;

{#4 MENU PRO KOMUNIKACI S UZIVATELEM}


function HMENU:integer; {vraci zvolenou volbu}
var volba:integer;
begin
  write(' HROBNIK 1.0 - AKTUALNE OTEVRENY SOUBOR: ',a_jmenosouboru);
  if (soubor_otevren = TRUE) then writeln(' (',pn,')')
  {zde nekde by bylo vypsani informativni a chybove zpravy,neni dodelano, ale pokud by to bylo nutne lze na pozadani dodelat}
  else writeln;
  writeln;
  writeln(' volba       funkce');
  writeln('   1         otevreni noveho souboru');
  writeln('   2         otevreni stavajiciho souboru');
  writeln('   3         pridani neboztika na konec prave otevreneho souboru');
  writeln('   4         vypsani vsech neboztiku z prave otevreneho souboru');
  writeln('   5         vyhledani neboztiku podle prijmeni');
  writeln('   6         vyhledani neboztiku podle jmena');
  writeln('   7         vyhledani neboztiku podle datumu narozeni');
  writeln('   8         vyhledani neboztiku podle datumu umrti');
  writeln('   9         vyhledani neboztiku podle cisla hrobu');
  writeln('   10        setrideni podle prijmeni (A-Z)');
  writeln('   11        setrideni podle jmena (A-Z)');
  writeln('   12        setrideni podle datumu narozeni (novy-stary)');
  writeln('   13        setrideni podle datumu umrti (novy-stary)');
  writeln('   14        setrideni podle cisla hrobu (1-X)');
  writeln('   15        setrideni podle identifikacniho cisla (0-X)');
  writeln('   16        prohozeni dvou zaznamu podle poradi (1-X) ');
  writeln('   17        smazani zaznamu podle identifikacniho cisla neboztika (0-X)');
  writeln('   18        zavri stavajici soubor');
  writeln('   19        ukonci program');
  writeln;
  write('zadejte volbu: '); readln(volba);
  HMENU:=volba;
end;

{#H1 VYHLEDAVANI}

procedure VyhledejPodleJmena(jmeno:string;var soubor:TSoubor);
var n:TNeboztik;
var vpn:integer;
begin
  vpn := 0;
  seek(soubor,0);
  VypisZahlaviProVypisNeboztika;
  while not eof(soubor) do begin
    PRECTINEBOZTIKA(soubor,n);  
    if n.jmeno = jmeno then begin
      VypisNeboztika(n);
      vpn := vpn + 1;
    end;
  end; 
  if vpn = 0 then writeln('zadny neboztik tohoto jmena nenalezen');
end;

procedure VyhledejPodlePrijmeni(prijmeni:string;var soubor:TSoubor);
var n:TNeboztik;
var vpn:integer;
begin
  vpn := 0;
  seek(soubor,0);
  VypisZahlaviProVypisNeboztika;
  while not eof(soubor) do begin
    PRECTINEBOZTIKA(soubor,n);  
    if n.prijmeni = prijmeni then begin
      VypisNeboztika(n);
      vpn := vpn + 1;
    end;
  end; 
  if vpn = 0 then writeln('zadny neboztik tohoto prijmeni nenalezen');
end;

procedure VyhledejPodleDatumuNarozeni(datum:TDatum;var soubor:TSoubor);
var n:TNeboztik;
var vpn:integer;
begin
  vpn := 0;
  seek(soubor,0);
  VypisZahlaviProVypisNeboztika;
  while not eof(soubor) do begin
    PRECTINEBOZTIKA(soubor,n);  
    if (n.datum_narozeni.den = datum.den) and (n.datum_narozeni.mesic = datum.mesic) then begin
      if (n.datum_narozeni.rok = datum.rok) then begin
      	VypisNeboztika(n);
      	vpn := vpn + 1;
      end;
    end;
  end; 
  if vpn = 0 then writeln('zadny neboztik tohoto datumu narozeni nenalezen');
end;

procedure VyhledejPodleDatumuUmrti(datum:TDatum;var soubor:TSoubor);
var n:TNeboztik;
var vpn:integer;
begin
  vpn := 0;
  seek(soubor,0);
  VypisZahlaviProVypisNeboztika;
  while not eof(soubor) do begin
    PRECTINEBOZTIKA(soubor,n);  
    if (n.datum_umrti.den = datum.den) and (n.datum_umrti.mesic = datum.mesic) and (n.datum_umrti.rok = datum.rok) then begin
      VypisNeboztika(n);
      vpn := vpn + 1;
    end;
  end; 
  if vpn = 0 then writeln('zadny neboztik tohoto datumu umrti nenalezen');
end;

procedure VyhledejPodleIdHrobu(id_hrob:integer;var soubor:TSoubor);
var n:TNeboztik;
var vpn:integer;
begin
  vpn := 0;
  seek(soubor,0);
  VypisZahlaviProVypisNeboztika;
  while not eof(soubor) do begin
    PRECTINEBOZTIKA(soubor,n);  
    if n.id_hrob = id_hrob then begin
      VypisNeboztika(n);
      vpn := vpn + 1;
    end;
  end; 
  if vpn = 0 then writeln('zadny neboztik daneho cisla hrobu nenalezen');
end;

procedure ProhodZaznamy(var soubor:TSoubor;z1:integer;z2:integer); {prohodi dva zaznamy v souboru}
var i:integer;
var n1:TNeboztik;
var n2:TNeboztik;
begin
  seek(soubor,z1); read(soubor,n1);
  seek(soubor,z2); read(soubor,n2);
  seek(soubor,z1); write(soubor,n2);
  seek(soubor,z2); write(soubor,n1);
end;

{#S  SERAZENI PODLE KLICE}

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
    end
    else pozice := pozice + 1;
  end;  
end;

function DATUMMIN(d1:TDatum;d2:TDatum):boolean;
{porovna dva datumu a vrati TRUE jestlize datum1 je pred datum2}
begin
  DATUMMIN := FALSE;
  if d1.rok < d2.rok then DATUMMIN := TRUE;
  if d1.rok = d2.rok then begin
    if d1.mesic < d2.mesic then DATUMMIN := TRUE;
    if d1.mesic = d2.mesic then begin
      if d1.den < d2.den then DATUMMIN := TRUE;
    end; 
  end;
end;

function MIN(c1:integer;c2:integer):boolean;
{porovna dve cisla a vrati TRUE jestilize c1 je mensi nez c2}
begin
  MIN := FALSE;
  if c1 < c2 then MIN := TRUE;
end;

{ve vsech serazovacich procedurach je pouzit bubblesort}

procedure SeradAZPodleJmena(var soubor:TSoubor); {serazeni abecedne podle jmena}
var dv:boolean;i:integer;j:integer;pn:integer;
var n1,n2:TNeboztik;
begin
  pn := V_POCETNEBOZTIKU(soubor);
  j := 2;
  repeat
    dv := FALSE;
    for i:=0 to (pn-j) do begin
      seek(soubor,i); 
      read(soubor,n1);
      read(soubor,n2);
      if AMIN(n1.jmeno,n2.jmeno) = FALSE then begin
        ProhodZaznamy(soubor,i,i+1);
        dv := TRUE;
      end;  
    end;
    j := j + 1;
  until not dv {neboli ze nedoslo jiz k zadne zmene} 
end;

procedure SeradAZPodlePrijmeni(var soubor:TSoubor); {serazeni abecedne podle prijmeni}
var dv:boolean;i:integer;j:integer;pn:integer;
var n1,n2:TNeboztik;
begin
  pn := V_POCETNEBOZTIKU(soubor);
  j := 2;
  repeat
    dv := FALSE;
    for i:=0 to (pn-j) do begin
      seek(soubor,i); 
      read(soubor,n1);
      read(soubor,n2);
      if  AMIN(n1.prijmeni,n2.prijmeni) = FALSE then begin
        ProhodZaznamy(soubor,i,i+1);
        dv := TRUE;
      end;  
    end;
    j := j + 1;
  until not dv {neboli ze nedoslo jiz k zadne zmene} 
end;

procedure SeradPodleDatumuNarozeni(var soubor:TSoubor); {serazeni datumu narozeni od nejnovejsiho do nejstarsiho}
var dv:boolean;i:integer;j:integer;pn:integer;
var n1,n2:TNeboztik;
begin
  pn := V_POCETNEBOZTIKU(soubor);
  j := 2;
  repeat
    dv := FALSE;
    for i:=0 to (pn-j) do begin
      seek(soubor,i); 
      read(soubor,n1);
      read(soubor,n2);
      if DATUMMIN(n1.datum_narozeni,n2.datum_narozeni) =TRUE then begin
        ProhodZaznamy(soubor,i,i+1);
        dv := TRUE;
      end;  
    end;
    j := j + 1;
  until not dv {neboli ze nedoslo jiz k zadne zmene} 
end;

procedure SeradPodleDatumuUmrti(var soubor:TSoubor); {serazeni datumu umrti od nejnovejsiho do nejstarsiho}
var dv:boolean;i:integer;j:integer;pn:integer;
var n1,n2:TNeboztik;
begin
  pn := V_POCETNEBOZTIKU(soubor);
  j := 2;
  repeat
    dv := FALSE;
    for i:=0 to (pn-j) do begin
      seek(soubor,i); 
      read(soubor,n1);
      read(soubor,n2);
      if DATUMMIN(n1.datum_umrti,n2.datum_umrti) =TRUE then begin
        ProhodZaznamy(soubor,i,i+1);
        dv := TRUE;
      end;  
    end;
    j := j + 1;
  until not dv {neboli ze nedoslo jiz k zadne zmene} 
end;

procedure SeradPodleIdHrobu(var soubor:TSoubor); {serazeni podle cisla hrobu od nejmensiho po nejvetsi}
var dv:boolean;i:integer;j:integer;pn:integer;
var n1,n2:TNeboztik;
begin
  pn := V_POCETNEBOZTIKU(soubor);
  j := 2;
  repeat
    dv := FALSE;
    for i:=0 to (pn-j) do begin
      seek(soubor,i); 
      read(soubor,n1);
      read(soubor,n2);
      if MIN(n1.id_hrob,n2.id_hrob) = FALSE then begin
        ProhodZaznamy(soubor,i,i+1);
        dv := TRUE;
      end;  
    end;
    j := j + 1;
  until not dv {neboli ze nedoslo jiz k zadne zmene} 
end;

procedure SeradPodleIdNeboztika(var soubor:TSoubor); {serazeni podle id neboztika od nejmensiho po nejvetsi}
var dv:boolean;i:integer;j:integer;pn:integer;
var n1,n2:TNeboztik;
begin
  pn := V_POCETNEBOZTIKU(soubor);
  j := 2;
  repeat
    dv := FALSE;
    for i:=0 to (pn-j) do begin
      seek(soubor,i); 
      read(soubor,n1);
      read(soubor,n2);
      if MIN(n1.id,n2.id) = FALSE then begin
        ProhodZaznamy(soubor,i,i+1);
        dv := TRUE;
      end;  
    end;
    j := j + 1;
  until not dv {neboli ze nedoslo jiz k zadne zmene} 
end;

{#M MAZANI ZAZNAMU PODLE KLICE}

procedure SmazNeboztikaPodleId(var soubor:TSoubor;id:integer);
var dsoubor:TSoubor;n:TNeboztik;
begin
  seek(soubor,0);
  OTEVRINOVYSOUBOR(dsoubor,'temp.$$$');
  while not eof(soubor) do begin
    PRECTINEBOZTIKA(soubor,n);  
    if n.id <> id then ZAPISNEBOZTIKA(dsoubor,n)
    else pn := pn - 1;
  end;
  ZAVRISOUBOR(soubor);
  erase(soubor);
  OTEVRINOVYSOUBOR(soubor,a_jmenosouboru);
  seek(dsoubor,0);
  while not eof(dsoubor) do begin
    PRECTINEBOZTIKA(dsoubor,n);
    ZAPISNEBOZTIKA(soubor,n);
  end;
  ZAVRISOUBOR(dsoubor);
  erase(dsoubor);
end;

{JINE}

procedure ChybovaZprava(ret:string); {da programu najevo, ze chybova zprava, ceka na sve vypsani}
begin
  ch_z := TRUE;
  ch_zprava := ret;
end;

procedure InfoZprava(ret:string); {da programu najevo, ze informativni zprava, ceka na sve vypsani}
begin
  i_z := TRUE;
  i_zprava := ret;
end;

procedure PressKey;
var klavesa:char;
begin
  writeln; writeln('stiskem klavesy se vratite do hlavniho menu');
  klavesa := readkey;
end;


{ROZCESTNIK}

procedure V1; {procedure pro otevreni noveho souboru}
var ret:string;
begin
  clrscr;
  writeln('OTEVRENI NOVEHO SOUBORU');
  writeln('upozorneni: pokud zadate jmeno jiz existujiciho souboru, tak tento soubor bude premazan');
  writeln;
  write('zadejte jmeno souboru: '); readln(ret);
  if soubor_otevren = TRUE then begin
    ZAVRISOUBOR(soubor);
    soubor_otevren := FALSE;
  end;
  OTEVRINOVYSOUBOR(soubor,ret);
  a_jmenosouboru := ret;
  soubor_otevren := TRUE;
  pn := 0; 
end;

procedure V2; {otevreni jiz stavajiciho souboru}
var ret:string;
begin
  clrscr;
  writeln('OTEVRENI EXISTUJICIHO SOUBORU');
  writeln('upozorneni: tento soubor musi bezpodminecne existovat');
  writeln;
  write('zadejte jmeno souboru: '); readln(ret);
   if soubor_otevren = TRUE then begin
    ZAVRISOUBOR(soubor);
    soubor_otevren := FALSE;
  end;
  OTEVRISOUBOR(soubor,ret);
  a_jmenosouboru := ret;
  soubor_otevren := TRUE;
  pn := V_POCETNEBOZTIKU(soubor); {zapise do globalni promenne pn, celkovy pocet neboztiku ze souboru}
end;

procedure V3; {pridani noveho neboztika na konec souboru}
var n:TNeboztik;
begin
  clrscr;
  writeln('PRIDANI NEBOZTIKA DO DATABAZE');
  writeln('upozorneni: datumy je nutno zadavat ve formatu DD.MM.RRRR');
  writeln;
  VypisZahlaviProZadavaniNeboztika;
  ZadejNeboztika(n,pn);  
  ZAPISNEBOZTIKA(soubor,n);
  pn := pn + 1; {da promenne spravujici pocet neboztiku najevo, ze jeden pribyl} 
end;

procedure V4; {vypsani vsech neboztiku na obrazovku}
begin
  clrscr;
  writeln('VYPSANI VSECH NEBOZTIKU Z DATABAZE');
  VYPISVSECHNYNEBOZTIKY(soubor);
  PressKey;
end;

procedure V5; {vyhledani neboztiku ze souboru podle prijmeni}
var ret:string;
begin
  clrscr;
  writeln('VYHLEDANI NEBOZTIKU Z DATABAZE PODLE PRIJMENI');
  write('zadejte prijmeni ktere chcete vyhledat: '); readln(ret);
  VyhledejPodlePrijmeni(ret,soubor); 
  PressKey;
end;

procedure V6; {vyhledani neboztiku ze souboru podle jmena}
var ret:string;
begin
   clrscr;
   writeln('VYHLEDANI NEBOZTIKU Z DATABAZE PODLE JMENA');
   write('zadejte jmeno ktere chcete vyhledat: '); readln(ret);
   VyhledejPodleJmena(ret,soubor);
   PressKey;
end;

procedure V7; {vyhledani neboztiku podle datumu narozeni}
var datum:TDatum;ret:string;
begin
   clrscr;
   writeln('VYHLEDANI NEBOZTIKU Z DATABAZE PODLE DATUMU NAROZENI');
   write('zadejte datum narozeni ktere chcete vyhledat: '); readln(ret);
   PrevedDatum(datum,ret);
   if ZkontrolujDatum(datum) = FALSE then ResetDatum(datum);
   VyhledejPodleDatumuNarozeni(datum,soubor);
   PressKey;
end;

procedure V8; {vyhledani neboztiku podle datumu umrti}
var datum:TDatum;ret:string;
begin
   clrscr;
   writeln('VYHLEDANI NEBOZTIKU Z DATABAZE PODLE DATUMU UMRTI');
   write('zadejte datum umrti ktere chcete vyhledat: '); readln(ret);
   PrevedDatum(datum,ret);
   if ZkontrolujDatum(datum) = FALSE then ResetDatum(datum);
   VyhledejPodleDatumuUmrti(datum,soubor);
   PressKey;
end;

procedure V9; {vyhledani neboztiku podle cisla hrobu}
var n:integer;
begin
   clrscr;
   writeln('VYHLEDANI NEBOZTIKU Z DATABAZE PODLE CISLA HROBU');
   write('zadejte cislo hrobu ktere chcete vyhledat: '); readln(n);
   VyhledejPodleIdHrobu(n,soubor);
   PressKey;
end;

procedure V10; {serazeni neboztiku v souboru abecedne podle prijemni}
begin
  SeradAZPodlePrijmeni(soubor);
end;

procedure V11; {serazeni neboztiku v souboru abecedne podle jmena}
begin
  SeradAZPodleJmena(soubor);
end;

procedure V12; {serazeni neboztiku v souboru od nejnovejsiho po nejstarsi podle datumu narozeni}
begin
   SeradPodleDatumuNarozeni(soubor);
end;

procedure V13; {serazeni neboztiku v souboru od nejnovejsiho po nejstarsi podle datumu umrtii}
begin
   SeradPodleDatumuUmrti(soubor);
end;

procedure V14; {serazeni neboztiku podle cisla hrobu v nemz se nachazeji}
begin
   SeradPodleIdHrobu(soubor);
    InfoZprava('databaze serazena podle cisel hrobu od nejmensiho po nejvetsi');
end;

procedure V15; {serazeni neboztiku podle jejich identifikacniho cisla}
begin
   SeradPodleIdNeboztika(soubor);
   InfoZprava('databaze serazena podle identifikacnich cisel neboztiku');
end;

procedure V16; {prohozeni dvou neboztiku podle poradi}
var z1,z2:integer;
begin
  clrscr;
  writeln('PROHOZENI DVOU NEBOZTIKU PODLE PORADI');
  write('zadejte poradove cislo prvniho neboztika: '); readln(z1);
  write('zadejte poradove cislo druheho neboztika: '); readln(z2);
  ProhodZaznamy(soubor,z1-1,z2-1);
end;

procedure V17; {mazani neboztika podle jeho identifikacniho cisla}
var n:integer;
begin
  clrscr;
  writeln('SMAZANI NEBOZTIKA PODLE JEHO IDENTIFIKACNIHO CISLA');
  write('zadejte identifikacni cislo neboztika, ktereho chcete smazat: '); readln(n);
  SmazNeboztikaPodleId(soubor,n);
end;

procedure V18; {zavreni prave otevreneho souboru}
begin
  ZAVRISOUBOR(soubor);
  a_jmenosouboru := 'zadny';
  soubor_otevren := FALSE;
end;

procedure V19; {ukonceni programu}
begin 
   konec := TRUE; 
end;



procedure VOLBA(v:integer);
begin
  case soubor_otevren of
    FALSE: begin
 	    case v of
	      1: V1;
 	      2: V2;
	      18: V18;
	      19: V19;
  	    end;
	  end;
    TRUE: begin
	  case v of
	    1: V1;
	    2: V2;
	    3: V3;
	    4: V4;
	    5: V5;
	    6: V6;
	    7: V7;
	    8: V8;
	    9: V9;
	    10: V10;
	    11: V11;
	    12: V12;
	    13: V13;
	    14: V14;
	    15: V15;
	    16: V16;
	    17: V17;
	    18: V18;
	    19: V19;
	  end;
	end;   
  end; 
end;

var i:integer;

{HLAVNI TELO PROGRAMU}
begin
 soubor_otevren := FALSE;
 a_jmenosouboru := 'zadny';
 konec:=FALSE;
 ch_z := FALSE; {nastavi vypis chybove zpravy na FALSE}
 i_z := FALSE;  {nastavi vypis informativni zpravy na FALSE}
 while konec = FALSE do begin
   clrscr;
   i := HMENU;
   VOLBA(i);
 end;
end.