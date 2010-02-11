{create database "playstation:/usr/local/database/oft2000/oft2000.gdb" user "sysdba" password "masterkey";

/* root: dboft2000              */
/* passwd: myPft2000            */

}

database oft2000.

base kilogram (R8,1).
base landcode (A3).
base landnaam (V30).
base landpostcodepositie (V30) required.
base plaatsnaam (V30) required.
base adressoort (I1) (1..2).
base straat (V50).
base postcode (V10).
base klantnr (I6).
base zoekcd (V10).
base klantprefix (V40).
base klantnaam (V70) required.
base telenum (V15).
base email (V40).
base commentaar (T).
base cpnaam (V80) required.
base cpnum (I2).
base functie (V80).
base groepomschrijving (V60).
base username (V30).
base icontop (I5) required.
base iconleft (I5) required.
base werkbladviewstyle (I1) required.
base clearformzoekeneverytime (B) required.
base bedrag (M) (0..1000000).
base opdrachtnr (I6) required.
base subopdrachtnr (A1).
base offerte (B) required.
base opdrachtdatum (D) required.
base offertedatum (D).
base aanvangsdatum (D).
base opleverdatum (D).
base sondering (B) required.
base blokgewicht (V15).
base productie (V15).
base hoogte (V15).
base breedte (V15).
base opdrachtomschrijving (V80).
base uitvoeringstijd (V15).
base kostenomschrijving (V80).
base opslagpercentage (R2,2) (0..100).
base paalomschrijving (V80).
base aantal palen (I4).
base draagvermogen (I5).
base diameter (I6).
base aantal voetplaten (I4).
base lengte (R5,2).
base wapening (V15).
base werkhoogte (V15).
base paalkop (V30).
base paalpunt (V30).
base aantal elementen pro paal (I3).
base contacttypeomschrijving (V80).
base tijdstip (D).
base contactomschrijving (V200).


type land (I2) = unique landcode, unique landnaam, landpostcodepositie.

insert land "1" its landcode = "NL", landnaam = "Nederland", landpostcodepositie = "Voor plaatsnaam".

type plaats (I5) = land, plaatsnaam.

{
create unique index idx_plaats on tplaats(id_land, plaatsnaam);

}


type adres (I6) = adressoort,
                  r1_straat, r2_straat, postcode,
                  optional plaats.

{
set term ^ ;
create procedure sp_SetLand(
  landnaam varchar(30))
returns (id_land integer)
as
begin

  if (:landnaam = '')
    then  begin
      id_land = Null;
    end
    else  begin

      select id_land
        from land
        where
          upper(landnaam) = upper(:landnaam)
        into :id_land;

      if (:id_land is Null) then
        execute procedure sp_InsertLand
          'XXX',
          :landnaam,
          'Voor land'
          returning_values :id_land;

    end

end ^
set term ; ^


set term ^ ;
create procedure sp_SetPlaats(
  landnaam varchar(30),
  plaatsnaam varchar(30))
returns (id_land integer, id_plaats integer)
as
begin

  execute procedure sp_SetLand
    :landnaam
    returning_values :id_land;

  if (:id_land is Null)
    then  begin
      id_plaats = Null;
    end
    else  begin

      select id_plaats
        from plaats
        where
          id_land = :id_land and
          upper(plaatsnaam) = upper(:plaatsnaam)
        into :id_plaats;

      if (:id_plaats is Null) then
        execute procedure sp_InsertPlaats
          :id_land,
          :plaatsnaam
          returning_values :id_plaats;

    end

end ^
set term ; ^


set term ^ ;
create procedure sp_SetAdres(
  id_adres integer,
  adressoort smallint,
  r1_straat varchar(50),
  r2_straat varchar(50),
  postcode varchar(10),
  plaatsnaam varchar(30),
  landnaam varchar(30))
returns (
  new_id_adres integer,
  id_land integer,
  id_plaats integer)
as
begin

  execute procedure sp_SetPlaats
    :landnaam,
    :plaatsnaam
    returning_values :id_land, :id_plaats;

  if (:id_adres is null)
    then  begin
      execute procedure sp_insertAdres
        :adressoort,
        :r1_straat,
        :r2_straat,
        :postcode,
        :id_plaats
        returning_values :new_id_adres;
    end
    else  begin
      update adres
        set
          r1_straat = :r1_straat,
          r2_straat = :r2_straat,
          postcode = :postcode,
          id_plaats = :id_plaats
        where
          id_adres = :id_adres;
      new_id_adres = :id_adres;
    end

end ^
set term ; ^

}

type relatie (I6) = unique klantnr, klantprefix, klantnaam, unique zoekcd,
                    optional vestigings_adres, optional post_adres,
                    telefoon_telenum, fax_telenum, mobiel_telenum,
                    email, commentaar.

{
set term ^ ;
create procedure sp_NextKlantNr
returns (klantnr integer)
as
begin
  select max(klantnr) + 1
    from relatie
    into :klantnr;
  if (:klantnr is Null) then  begin
    klantnr = 1;
  end
end ^
set term ; ^

}


type contactpersoon (I6) = relatie, cpnaam, cpnum, functie,
                           telefoon_telenum, fax_telenum,
                           mobiel_telenum, prive_telenum,
                           email, commentaar.

{
create index idx_contactpersoon1 on tcontactpersoon(id_relatie, cpnaam);

}


type groep (I6) = unique groepomschrijving.

type groeprelatie (I6) = relatie, groep.

{
create unique index idx_groeprelatie1 on tgroeprelatie(id_relatie, id_groep);
create unique index idx_groeprelatie2 on tgroeprelatie(id_groep, id_relatie);

}


type opdracht (I8) = opdrachtnr, subopdrachtnr, offerte,
                     opdrachtdatum, offertedatum,
                     aanvangsdatum, opleverdatum,
                     straat, optional plaats,
                     optional opdrachtgever_relatie,
                     optional opdrachtgever_contactpersoon,
                     optional aannemer_relatie,
                     optional aannemer_contactpersoon,
                     opdrachtomschrijving,
                     sondering,
                     blokgewicht,
                     productie,
                     hoogte,
                     breedte,
                     uitvoeringstijd,
                     k1_kostenomschrijving,
                     k1_bedrag,
                     k2_kostenomschrijving,
                     k2_bedrag,
                     opslagpercentage,
                     commentaar.

{
drop view opdracht;
create view
  opdracht(
    id_opdracht,
    opdrachtnr,
    subopdrachtnr,
    offerte,
    opdrachtdatum,
    offertedatum,
    aanvangsdatum,
    opleverdatum,
    straat,
    id_plaats,
    opdrachtgever_relatie,
    opdrachtgever_contactpersoon,
    aannemer_relatie,
    aannemer_contactpersoon,
    opdrachtomschrijving,
    sondering,
    blokgewicht,
    productie,
    hoogte,
    breedte,
    uitvoeringstijd,
    k1_kostenomschrijving,
    k1_bedrag,
    k2_kostenomschrijving,
    k2_bedrag,
    opslagpercentage,
    commentaar,
    fullopdrachtnr) as
  select
    id_opdracht,
    opdrachtnr,
    subopdrachtnr,
    offerte,
    opdrachtdatum,
    offertedatum,
    aanvangsdatum,
    opleverdatum,
    straat,
    id_plaats,
    opdrachtgever_relatie,
    opdrachtgever_contactpersoon,
    aannemer_relatie,
    aannemer_contactpersoon,
    opdrachtomschrijving,
    sondering,
    blokgewicht,
    productie,
    hoogte,
    breedte,
    uitvoeringstijd,
    k1_kostenomschrijving,
    k1_bedrag,
    k2_kostenomschrijving,
    k2_bedrag,
    opslagpercentage,
    commentaar,
    OpdrachtNr || SubOpdrachtNr
  from Topdracht;

create unique index idx_OpdrachtNr on topdracht(opdrachtnr, subopdrachtnr);
create index idx_Opdrachtgever on topdracht(opdrachtgever_relatie);
create index idx_Aanvangsdatum on topdracht(aanvangsdatum);
create index idx_Leverdatum on topdracht(opleverdatum);

set term ^ ;
create procedure sp_NextOpdrachtNr
returns (opdrachtnr integer)
as
begin
  select max(opdrachtnr) + 1
    from opdracht
    into :opdrachtnr;
  if (:opdrachtnr is Null) then  begin
    opdrachtnr = 1;
  end
end ^
set term ; ^

}


{
/* find an opdracht */
set term ^ ;
create procedure sp_FindOpdrachtNr(
  opdrachtnr integer,
  subopdrachtnr char(1))
returns (id_opdracht integer)
as
begin
  select id_opdracht
    from opdracht
    where
      opdrachtnr = :opdrachtnr and
      subopdrachtnr = :subopdrachtnr
    into :id_opdracht;
end ^
set term ; ^

}


type opdrachtpaal (I8) = opdracht, 
                         aantal palen,
                         paalomschrijving,
                         draagvermogen,                         
                         diameter,
                         aantal voetplaten,
                         lengte,
                         wapening,
                         werkhoogte,
                         paalkop,
                         paalpunt,
                         staal pro meter_bedrag,
                         aantal elementen pro paal,
                         bewerking pro element_bedrag,
                         voetplaten_bedrag,
                         wapening pro paal_kilogram,
                         wapening pro kg_bedrag,
                         betonvulling pro m3_bedrag,
                         commentaar.

{
create index idx_opdrachtpaal on topdrachtpaal(id_opdracht);
}



{
/* contact registration */
}


type contacttype (I8) = unique contacttypeomschrijving.

insert contacttype "1" its contacttypeomschrijving = "Overig".
insert contacttype "2" its contacttypeomschrijving = "Telefoon".
insert contacttype "3" its contacttypeomschrijving = "Offerte gemaakt".
insert contacttype "4" its contacttypeomschrijving = "Opdracht gemaakt".
insert contacttype "5" its contacttypeomschrijving = "Opdracht verstuurd".

type contact (I8) = tijdstip,
                    optional relatie, 
                    optional contactpersoon, 
                    optional opdracht,
                    contactomschrijving,
                    contacttype,
                    commentaar.


{
/* variables */
}

variable documentdir (V120).
variable verstek bedrag bewerking pro element (M).
variable verstek bedrag voetplaten (M).
variable verstek kilogram wapening pro paal (R8,1).
variable verstek bedrag betonvulling (M).
variable verstek opslagpercentage (R2,2).

documentdir = "m:\src\wiertsema\oft2000\doc".
verstek bedrag bewerking pro element = 10.
verstek bedrag voetplaten = 25.
verstek kilogram wapening pro paal = 9.
verstek bedrag betonvulling = 500.
verstek opslagpercentage = 10.


{
/* user settings */

}

type gebruiker (I3) = unique username, werkbladviewstyle, clearformzoekeneverytime.

type werkbladrelatie (I6) = gebruiker, relatie.

{
create unique index idx_werkbladrelatie on twerkbladrelatie(id_gebruiker, id_relatie);

}


{
/* triggers which reference more tables */

set term ^ ;
create trigger tr_BeforeDeleteRelatie for trelatie before delete
as
begin
  delete from contactpersoon
    where id_relatie = old.id_relatie;

  delete from werkbladrelatie
    where id_relatie = old.id_relatie;
end ^
set term ; ^

set term ^ ;
create trigger tr_AfterDeleteRelatie for trelatie after delete
as
begin
  delete from adres
    where id_adres = old.vestigings_adres;

  delete from adres
    where id_adres = old.post_adres;
end ^
set term ; ^

set term ^ ;
create trigger tr_BeforeDeleteOpdracht for topdracht before delete
as
begin
  delete from opdrachtpaal
    where id_opdracht = old.id_opdracht;
end ^
set term ; ^

}



{

grant all on adres to dboft2000;
grant all on tadres to dboft2000;
grant all on contactpersoon to dboft2000;
grant all on tcontactpersoon to dboft2000;
grant all on contact to dboft2000;
grant all on tcontact to dboft2000;
grant all on contacttype to dboft2000;
grant select on tcontacttype to dboft2000;
grant all on gebruiker to dboft2000;
grant all on tgebruiker to dboft2000;
grant all on groep to dboft2000;
grant all on groeprelatie to dboft2000;
grant all on land to dboft2000;
grant all on tland to dboft2000;
grant all on opdracht to dboft2000;
grant all on topdracht to dboft2000;
grant all on opdrachtpaal to dboft2000;
grant all on topdrachtpaal to dboft2000;
grant all on plaats to dboft2000;
grant all on tplaats to dboft2000;
grant all on relatie to dboft2000;
grant all on trelatie to dboft2000;
grant select on XplainVariable to dboft2000;
grant all on werkbladrelatie to dboft2000;
grant all on twerkbladrelatie to dboft2000;

grant execute on procedure SP_INSERTADRES to dboft2000;
grant execute on procedure SP_INSERTCONTACT to dboft2000;
grant execute on procedure SP_INSERTCONTACTPERSOON to dboft2000;
grant execute on procedure SP_INSERTGEBRUIKER to dboft2000;
grant execute on procedure SP_INSERTGROEP to dboft2000;
grant execute on procedure SP_INSERTGROEPRELATIE to dboft2000;
grant execute on procedure SP_INSERTLAND to dboft2000;
grant execute on procedure SP_INSERTOPDRACHT to dboft2000;
grant execute on procedure SP_INSERTOPDRACHTPAAL to dboft2000;
grant execute on procedure SP_INSERTPLAATS to dboft2000;
grant execute on procedure SP_INSERTRELATIE to dboft2000;
grant execute on procedure sp_insertwerkbladrelatie to dboft2000;

grant execute on procedure sp_FindOpdrachtNr to dboft2000;
grant execute on procedure sp_NextKlantNr to dboft2000;
grant execute on procedure sp_NextOpdrachtNr to dboft2000;
grant execute on procedure sp_setAdres to dboft2000;
grant execute on procedure sp_setLand to dboft2000;
grant execute on procedure sp_setPlaats to dboft2000;

/* commit work; */

}

end.