program HROBAR;
{HROBNIK 2.0 - PROGRAM PRO SPRAVU HRBITOVA}
{Lukas Lansky}

uses GRAPH,GRAFIKA,CRT,HRMENU,HROB,MAT,BEEP;

type tSoubor = file of tZaznam;

const K_UP = chr(72);
      K_DOWN = chr(80);
      K_LEFT = chr(75);
      K_RIGHT = chr(77);
      K_DEL = chr(83);
      K_INSERT = chr(82);
      K_PGDOWN = chr(81);
      K_PGUP = chr(73);
      K_F1 = chr(59);
      K_F2 = chr(60);
      K_F3 = chr(61);
      K_F4 = chr(62);
      K_F5 = chr(63);
      K_F6 = chr(64);
      K_F7 = chr(65);
      K_F8 = chr(66);
      K_F9 = chr(67);
      K_F10 = chr(68);
      K_1 = chr(49);
      K_2 = chr(50);
      K_3 = chr(51);
      K_4 = chr(52);
      K_ENTER = chr(13);
      K_ESC = chr(27);
      K_SHIFT_DEL = chr(7);

var menu:hMenu;
    key:char;
    konec:boolean;
    i,min,max:integer;
    z:tZaznam; {pomocny zaznam}
    s:tSoubor; {hlavni soubor}


procedure PressKey;
var klavesa:char;
begin
  klavesa := readkey;
end;

procedure ZN(var z:tZaznam;id:integer);
{zadavani neboztika do jedne radky v dosovem modu}
var radka:integer;
begin
  clrscr;
  textcolor(lightGreen);
  writeln('PRIDANI NEBOZTIKA DO DATABAZE');
  writeln;
  textcolor(lightRed);
  writeln('id','':2,'jmeno','':10,'prijmeni','':7,'':5,'datum narozeni','':3,'datum umrti','':4,'idh');
  textcolor(lightGray);
  textbackground(black);
  radka := whereY;
  z.id := id;
  gotoXY(1,radka);
  writeln(z.id);
  gotoXY(5,radka);
  readln(z.jmeno);
  gotoXY(20,radka);
  readln(z.prijmeni);
  gotoXY(40,radka);
  readln(z.datum_narozeni);
  gotoXY(57,radka);
  readln(z.datum_umrti);
  gotoXY(72,radka);
  readln(z.id_hrob);
end;

procedure VN(n:tZaznam);
{vypise udaje v dosovem modu}
begin
  write(n.id:4,n.jmeno:15,n.prijmeni:15,'':5,n.datum_narozeni:8,'':9,n.datum_umrti:8,'':6,n.id_hrob);
  writeln;
end;

procedure VNZ;
{vypise zahlavi pro proceduru VN}
begin
  textcolor(lightRed);
  writeln('id':4,'jmeno':15,'prijmeni':15,'':5,'datum narozeni':10,'':3,'datum umrti':10,'idh':7);
  textcolor(lightGray);
end;

{#3}
procedure ONS(var soubor:tSoubor;jmenosouboru:string);
{otevri novy soubor}
begin
  assign(soubor,jmenosouboru);
  rewrite(soubor);
end;

procedure OS(var soubor:tSoubor;jmenosouboru:string);
{otevri existujici soubor}
begin
  assign(soubor,jmenosouboru);
  reset(soubor);
end;

procedure ULOZ(var soubor:tSoubor);
{ulozeni databaze do binarniho souboru}
var i:integer;
begin
  Seek(soubor,0);
  for i:=1 to menu.np do begin
    menu.p.VRAT(i,z);
    write(soubor,z);
  end;
end;

procedure NACTI(var soubor:tSoubor);
{nacteni databaze z binarniho souboru}
var i:integer;
begin
  i := 1;
  menu.p.DONE;
  min := 1;
  max := 10;
  menu.INIT(50,50,min,max);
  Seek(soubor,0);
  while not eof(soubor) do begin
    read(soubor,z);
    menu.Vloz(z);
    inc(i);
  end;
  if (menu.np < max) then begin
    max := menu.np;
    menu.b := max;
  end;
end;

procedure ULOZ_BIN;
{ulozeni databaze do binarniho souboru}
var jm:string;    {jmeno binarniho souboru}
    fb:tSoubor;   {binarni soubor}
    i:integer;
begin
  textcolor(lightGreen);
  writeln('ULOZENI DATABAZE DO BINARNIHO SOUBORU'); writeln;
  textcolor(lightGray);
  write('zadejte jmeno souboru: '); readln(jm);
  ONS(fb,jm); {otevreni noveho souboru}
  ULOZ(fb);
  close(fb);
end;

procedure NACTI_BIN;
{nacteni databaze z binarniho souboru}
var jm:string;    {jmeno binarniho souboru}
    fb:tSoubor;   {binarni soubor}
    i:integer;
begin
  textcolor(lightGreen);
  writeln('NACTENI DATABAZE Z BINARNIHO SOUBORU'); writeln;
  textcolor(lightGray);
  write('zadejte jmeno souboru: '); readln(jm);
  OS(fb,jm); {otevreni existujiciho souboru}
  NACTI(fb);
  close(fb);
end;

procedure ULOZ_TXT;
{ulozeni databaze do textoveho souboru}
var jm:string; {jmeno textoveho souboru}
    ft:text;   {textovy soubor}
    i:integer;
begin
  textcolor(lightGreen);
  writeln('ULOZENI DATABAZE DO TEXTOVE SOUBORU'); writeln;
  textcolor(lightGray);
  write('zadejte jmeno souboru: '); readln(jm);
  assign(ft,jm);
  rewrite(ft);
  for i:=1 to menu.np do begin
    menu.p.VRAT(i,z);
    writeln(ft,z.id,' ',z.jmeno,' ',z.prijmeni,' ',z.datum_narozeni,'-',z.datum_umrti,' ',z.id_hrob);
  end;
  close(ft);
end;

procedure ULOZ_HTML;
{ulozeni databaze do html souboru}
var jm,jh:string; {jmeno textoveho souboru}
    ft:text;   {textovy soubor}
    i:integer;
begin
  textcolor(lightGreen);
  writeln('ULOZENI DATABAZE DO HTML SOUBORU'); writeln;
  textcolor(lightGray);
  write('zadejte jmeno souboru: '); readln(jm);
  assign(ft,jm);
  rewrite(ft);
  write('zadejte jmeno hrbitova: '); readln(jh);
  writeln(ft,'<html>');
  writeln(ft,'<head>');
  writeln(ft,'<title>',jh,'</title>');
  writeln(ft,'</head>');
  writeln(ft,'<body>');
  writeln(ft,'<table bgcolor="#CAE4FF" border="1">');
  writeln(ft,'<tr bgcolor="004993">');
  writeln(ft,'<td width="40">ID</td>');
  writeln(ft,'<td width="120">JMENO</td>');
  writeln(ft,'<td width="140">PRIJMENI</td>');
  writeln(ft,'<td width="100">DATUM NAROZENI</td>');
  writeln(ft,'<td width="100">DATUM UMRTI</td>');
  writeln(ft,'<td width="60">HROB</td>');
  writeln(ft,'</tr>');
  for i:=1 to menu.np do begin
    menu.p.VRAT(i,z);
    writeln(ft,'<tr>');
    writeln(ft,'<td>',z.id,'</td>');
    writeln(ft,'<td>',z.jmeno,'</td>');
    writeln(ft,'<td>',z.prijmeni,'</td>');
    writeln(ft,'<td>',z.datum_narozeni,'</td>');
    writeln(ft,'<td>',z.datum_umrti,'</td>');
    writeln(ft,'<td>',z.id_hrob,'</td>');
    writeln(ft,'</tr>');
  end;
  close(ft);
end;


{#3 - VYHLEDAVANI}
procedure VJ(jmeno:string);
{vyhledavani podle jmena}
var z1:tZaznam;    {zaznam}
    vpn,i:integer; {pocet nalezenych zaznamu}
begin
  vpn := 0;
  VNZ;             {vypise zahlavi}
  for i:=1 to menu.np do begin
    menu.p.VRAT(i,z1);
    if (z1.jmeno = jmeno) then begin
      inc(vpn);
      VN(z1);
    end;
  end;
  if vpn = 0 then writeln('zadny neboztik tohoto jmena nenalezen');
end;

procedure VJ_1;
{vyhledavani podle jmena - nastaveni}
var jm:string;
begin
  textcolor(lightGreen);
  writeln('VYHLEDAVANI V DATABAZI PODLE JMENA NEBOZTIKA'); writeln;
  textcolor(lightGray);
  write('zadejte jmeno neboztika: '); readln(jm);
  VJ(jm);
  PressKey;
end;

procedure VP(prijmeni:string);
{vyhledavani podle prijmeni}
var z1:tZaznam;    {zaznam}
    vpn,i:integer; {pocet nalezenych zaznamu}
begin
  vpn := 0;
  VNZ;             {vypise zahlavi}
  for i:=1 to menu.np do begin
    menu.p.VRAT(i,z1);
    if (z1.prijmeni = prijmeni) then begin
      inc(vpn);
      VN(z1);
    end;
  end;
  if vpn = 0 then writeln('zadny neboztik tohoto prijmeni nenalezen');
end;

procedure VP_1;
{vyhledavani podle prijmeni - nastaveni}
var jm:string;
begin
  textcolor(lightGreen);
  writeln('VYHLEDAVANI V DATABAZI PODLE PRIJMENI NEBOZTIKA'); writeln;
  textcolor(lightGray);
  write('zadejte prijmeni neboztika: '); readln(jm);
  VP(jm);
  PressKey;
end;

procedure VID(id:integer);
{vyhledavani podle identifikacniho cisla}
var z1:tZaznam;    {zaznam}
    vpn,i:integer; {pocet nalezenych zaznamu}
begin
  vpn := 0;
  VNZ;             {vypise zahlavi}
  for i:=1 to menu.np do begin
    menu.p.VRAT(i,z1);
    if (z1.id = id) then begin
      inc(vpn);
      VN(z1);
    end;
  end;
  if vpn = 0 then writeln('zadny neboztik tohoto ID nenalezen');
end;

procedure VID_1;
{vyhledavani podle ID - nastaveni}
var j:integer;
begin
  textcolor(lightGreen);
  writeln('VYHLEDAVANI V DATABAZI PODLE ID NEBOZTIKA'); writeln;
  textcolor(lightGray);
  write('zadejte ID neboztika: '); readln(j);
  VID(j);
  PressKey;
end;

procedure VHR(hr:integer);
{vyhledavani podle identifikacniho cisla hrobu}
var z1:tZaznam;    {zaznam}
    vpn,i:integer; {pocet nalezenych zaznamu}
begin
  vpn := 0;
  VNZ;             {vypise zahlavi}
  for i:=1 to menu.np do begin
    menu.p.VRAT(i,z1);
    if (z1.id_hrob = hr) then begin
      inc(vpn);
      VN(z1);
    end;
  end;
  if vpn = 0 then writeln('zadny neboztik tohoto hrobu nenalezen');
end;

procedure VHR_1;
{vyhledavani podle hrobu - nastaveni}
var j:integer;
begin
  textcolor(lightGreen);
  writeln('VYHLEDAVANI V DATABAZI PODLE HROBU NEBOZTIKA'); writeln;
  textcolor(lightGray);
  write('zadejte cislo hrobu neboztika: '); readln(j);
  VHR(j);
  PressKey;
end;

procedure HELP;
begin
  SetColor(15);
  SetTextStyle(2,0,8);
  OutTextXY(50,50,'HROBNIKOVA POMOC');
  SetTextStyle(2,0,4);
  OutTextXY(50,80,'sipka nahoru'); OutTextXY(200,80,'pohyb kurzoru nahoru');
  OutTextXY(50,95,'sipka dolu'); OutTextXY(200,95,'pohyb kurzoru dolu');
  OutTextXY(50,110,'PAGE UP'); OutTextXY(200,110,'predchozi stranka');
  OutTextXY(50,125,'PAGE DOWN'); OutTextXY(200,125,'nasledujici stranka');
  OutTextXY(50,140,'F2'); OutTextXY(200,140,'ulozeni databaze do binarniho souboru');
  OutTextXY(50,155,'F3'); OutTextXY(200,155,'nacteni databaze z binarniho souboru');
  OutTextXY(50,170,'F5'); OutTextXY(200,170,'ulozeni databaze do TXT souboru');
  OutTextXY(50,185,'F6'); OutTextXY(200,185,'ulozeni databaze do HTML souboru');
  OutTextXY(50,200,'F7'); OutTextXY(200,200,'vyhledavani podle jmena neboztika');
  OutTextXY(50,215,'F8'); OutTextXY(200,215,'vyhledavani podle prijmeni neboztika');
  OutTextXY(50,230,'F9'); OutTextXY(200,230,'vyhledavani podle hrobu neboztika');
  OutTextXY(50,245,'F10'); OutTextXY(200,245,'vyhledavani podle identifikacniho cisla neboztika');
  OutTextXY(50,260,'1'); OutTextXY(200,260,'serazeni podle identifikacniho cisla');
  OutTextXY(50,275,'2'); OutTextXY(200,275,'serazeni podle jmena');
  OutTextXY(50,290,'3'); OutTextXY(200,290,'serazeni podle prijmeni');
  OutTextXY(50,305,'4'); OutTextXY(200,305,'serazeni podle hrobu');
  OutTextXY(50,320,'DEL'); OutTextXY(200,320,'smazani aktualni polozky');
  OutTextXY(50,335,'INSERT'); OutTextXY(200,335,'vlozeni noveho zaznamu nakonec databaze');
  OutTextXY(50,350,'ESC'); OutTextXY(200,350,'ukoncit program');

  PressKey;
  ClearDevice;
end;


begin
  grINIT;
  konec := FALSE;
  min := 1;
  max := 10;
  menu.Init(50,50,min,max);
  for i:=1 to 19 do begin
    z.id := i;
    z.jmeno := 'Kvetoslav'+ST(i);
    z.prijmeni := 'Novak'+ST(i);
    z.datum_narozeni := ST(i)+'.1.1950';
    z.datum_umrti := ST(i)+'.12.2000';
    z.id_hrob := 100-i;
    menu.Vloz(z);
  end;
  menu.Zobraz;
  repeat
    key := ReadKey;
    case key of
      K_UP: menu.UP;
      K_DOWN: menu.DOWN;
      K_PGDOWN: menu.pgDOWN;
      K_PGUP: menu.pgUP;
      K_DEL: menu.DEL;
      K_INSERT: begin
                  grCRT;           {zpet do dosoveho modu}
                  ZN(z,menu.np+1); {procedure na zadavani neboztika}
                  grRESTORE;       {zpet do grafickeho modu}
                  menu.INSERT(z);    {vloz zaznam}
                end;
      K_F1: begin
              menu.Schovej;
              HELP;
              menu.Zobraz;
            end;
      K_F2: begin
              grCRT;
              ULOZ_BIN;
              grRESTORE;
              menu.Zobraz;
            end;
      K_F3: begin
              grCRT;
              NACTI_BIN;
              grRESTORE;
              menu.Zobraz;
            end;
      K_F5: begin
              grCRT;
              ULOZ_TXT;
              grRESTORE;
              menu.Zobraz;
            end;
      K_F6: begin
              grCRT;
              ULOZ_HTML;
              grRESTORE;
              menu.Zobraz;
            end;
      K_F7: begin
              grCRT;
              VJ_1;
              grRESTORE;
              menu.Zobraz;
            end;
      K_F8: begin
              grCRT;
              VP_1;
              grRESTORE;
              menu.Zobraz;
            end;
      K_F9: begin
              grCRT;
              VHR_1;
              grRESTORE;
              menu.Zobraz;
            end;
      K_F10: begin
              grCRT;
              VID_1;
              grRESTORE;
              menu.Zobraz;
            end;
      K_1: begin
             menu.Schovej;
             menu.S1;
             menu.Zobraz;
           end;
      K_2: begin
             menu.Schovej;
             menu.S2;
             menu.Zobraz;
           end;
      K_3: begin
             menu.Schovej;
             menu.S3;
             menu.Zobraz;
           end;
      K_4: begin
             menu.Schovej;
             menu.S4;
             menu.Zobraz;
           end;
      K_ESC: konec := TRUE;
    end;
  until (konec = TRUE);
  menu.Schovej;
  grEND;
end.
