{

create database "m:/src/bookset/data/bookset.gdb" user "sysdba" password "masterkey";

}

database bookset.

base voornaam (V20) required.
base tussenvoegsel (V10).
base achternaam (V30) required.
base telefoon (A15).
base sessiedatum (D) required.
base boeknummer (I6) (1..100000).
base oudboeknummer (I6).
base auteur (V40) required.
base titel (V80) required.
base genre (A1) = "A", "J", "K", "L", "T", "V".
base oudgenre (A1).
base inaf (A4).
base InBieb (B) required.
base uitgever (V20).
base prijs (M).
base oudnr (I4) (1..6000).
base straat (V40).
base postcode (A7).
base plaats (V30).
base actieomschrijving (V40) required.
base cassettenummer (I6) (1..100000).
base predikant (V25).
base bijbelboeknummer (I1) (1..3).
base bijbelboek (V30).
base bijbelhoofdstuk (I3) (1..150).
base bijbelvers (V10).
base opmerking (V32).
base datum (D).
base saldo (M).
base isbn (A10).


type actie (I3) = actieomschrijving.

type schrijver (I4) = voornaam, tussenvoegsel, achternaam,
                      straat, postcode, plaats, telefoon.

type sessie (I5) = sessiedatum, optional eerste_schrijver, optional tweede_schrijver.

type boek (I8) = boeknummer, auteur, titel, genre, inaf,
                 InBieb, uitgever, prijs, oudboeknummer, oudgenre,
                 actie.

type cassette (I8) = cassettenummer, predikant,
                     bijbelboeknummer, bijbelboek, bijbelhoofdstuk, bijbelvers,
                     opmerking, datum, inaf, InBieb,
                     actie.

type lener (I6) = voornaam, tussenvoegsel, achternaam,
                  straat, postcode, plaats, telefoon,
                  saldo.

type boekuitlening (I9) = geleend_sessie,
                          optional teruggebracht_sessie,
                          lener, boek, actie.

type cassetteuitlening (I9) = sessie, lener, cassette, actie.

type nbd (I9) = genre, auteur, titel, uitgever, prijs,
                isbn.


/* indexing */

{
create unique index idx_BoekNr on Tboek(boeknummer);

create index idx_Boek2 on Tboek(titel);

create index idx_Boek3 on Tboek(auteur);

create unique index idx_CassetteNr on Tcassette(cassettenummer);

create index idx_Lener on Tlener(achternaam, tussenvoegsel, voornaam, straat);

create index idx_BoekUitlening on Tboekuitlening(id_lener, id_boek);

create index idx_BoekUitlening2 on Tboekuitlening(id_lener, teruggebracht_sessie, id_boek);

create index idx_BoekUitlening3 on Tboekuitlening(id_boek, teruggebracht_sessie);

create index idx_CassetteUitlening on Tcassetteuitlening(id_lener, id_cassette);

}


/* security */

{

grant select on schrijver to schrijver;

grant select on boek to schrijver;

grant select,insert,update on lener to schrijver;

grant select,insert on boekuitlening to schrijver;

}


/* reporting/datawarehous */

base dag (A2) = "Ma", "Di", "Wo", "Do", "Vr", "Za".
base week (I2) (1..53).
base maand (I2) (1..12).
base jaar (I4) (1900..9999).
base aantalleners (I3).
base aantaluitgeleend (I4).
base aantalingenomen (I4).
base totaal (I4).
base omzet (M).
type uitleenhistorie (I9) = sessiedatum, dag, week, maand, jaar,
                            aantalleners, aantaluitgeleend, aantalingenomen, 
                            totaal, omzet.

{
create table dagreport(sessiedatum tsessiedatum, id_lener integer);

set term ^;
create procedure sp_dagreport
as
begin
  delete from dagreport;
  insert into dagreport(sessiedatum, id_lener)
    select sessiedatum,  id_lener
    from boekuitlening
    join sessie on sessie.id_sessie = boekuitlening.geleend_sessie
    where (sessiedatum >= '01-01-1998');
  insert into dagreport(sessiedatum, id_lener)
    select sessiedatum,  id_lener
    from boekuitlening
    join sessie on sessie.id_sessie = boekuitlening.teruggebracht_sessie
    where (sessiedatum >= '01-01-1998');
end ^
set term ; ^
}


/* basetable data */

{
/* actie */
insert into
  actie(
    actieomschrijving)
  values(
    'geen actie');

insert into
  actie(
    actieomschrijving)
  values(
    'niet uitlenen');

insert into
  actie(
    actieomschrijving)
  values(
    'innemen bij teruggave');

insert into
  actie(
    actieomschrijving)
  values(
    'innemen omdat al uitgeleend');

insert into
  actie(
    actieomschrijving)
  values(
    'innemen omdat niet bestaat');

insert into
  actie(
    actieomschrijving)
  values(
    'innemen omdat gereserveerd');


/* schrijvers */
insert into
  schrijver(
    voornaam, tussenvoegsel, achternaam,
    straat, postcode, plaats, telefoon)
  values(
    'Berend', 'de', 'Boer',
    'Peperstraat 29', '5311 CS', 'Gameren', '0418-564228');

}

end.