# SDMS datamodel

database sdms.

# general
base comment (T).
base date (D).
base datetime (D).
base time (D).
base kind description (V40).
base short description (A10).
base long description (V80).
base description (V120).
base minute (I4).
base active (B).
base reason inactive (V120).


# which languages do we know about?
type language (I2) = short description, long description.

insert language "1" its
  short description = "EN",
  long description = "English".

insert language "2" its
  short description = "NL",
  long description = "Nederlands".


# multi lingual descriptions
base dummy1 (A1).
type multilangid (I9) = optional dummy1.
type mldescription (I9) = multilangid, language, description.

# assert mldescription its description <> "".


{
alter table mldescription
  add constraint chk_description_not_empty check (rtrim(description) <> '')
go

create unique clustered index idx_mldescriptionC on mldescription(id_multilangid, id_language)
go

}


# unit
base unit factor (R6,4).
base uvalue (R6,4).
type unit kind (I2) = multilangid.
type unit (I2) = unit kind, short description, multilangid, unit factor.
#type unitvalue (I9) = uvalue, unit.

# predefined unit kinds:

# Weight
insert multilangid "1" its dummy1 = "A".
insert mldescription "1" its 
  multilangid = "1", 
  language = "1",
  description = "Weight".
insert mldescription "2" its 
  multilangid = "1", 
  language = "2",
  description = "Gewicht".
insert unit kind "1" its multilangid = "1".

# Count
insert multilangid "2" its dummy1 = "A".
insert mldescription "3" its 
  multilangid = "2", 
  language = "1",
  description = "Count".
insert mldescription "4" its 
  multilangid = "2", 
  language = "2",
  description = "Aantal".
insert unit kind "2" its multilangid = "2".


# Weight.Kilogram
insert multilangid "3" its dummy1 = "A".
insert mldescription "5" its 
  multilangid = "3", 
  language = "1",
  description = "Kilogram".
insert mldescription "6" its 
  multilangid = "3", 
  language = "2",
  description = "Kilogram".
insert unit "1" its 
  unit kind = "1", 
  short description = "KG", 
  multilangid = "3",
  unit factor = 1.


# Count.Pallets
insert multilangid "5" its dummy1 = "A".
insert mldescription "9" its 
  multilangid = "5", 
  language = "1",
  description = "Pallets".
insert mldescription "10" its 
  multilangid = "5", 
  language = "2",
  description = "Pallets".
insert unit "2" its
  unit kind = "2", 
  short description = "plts", 
  multilangid = "5",
  unit factor = 1.

# Count.Colli
insert multilangid "6" its dummy1 = "A".
insert mldescription "11" its 
  multilangid = "6", 
  language = "1",
  description = "Colli".
insert mldescription "12" its 
  multilangid = "6", 
  language = "2",
  description = "Colli".
insert unit "3" its 
  unit kind = "2", 
  short description = "col", 
  multilangid = "6",
  unit factor = 1.


# attribute, kind of meta model.
# class defines the classes which can be extended with attributes.

base class (A13) = "contact", "resource", "product", "address", "order".
base Ainlined (B).
base Arequired (B).

type attribute kind (I4)      = multilangid.
type attribute (I6)           = attribute kind, parent_attribute, multilangid.
type attribute set (I2)       = class.
type attribute set item (I6)  = attribute set, attribute, 
                                Ainlined, Arequired.

{
create unique clustered index idx_attribute_set_itemC on "attribute set item"("id_attribute set", "id_attribute")
go

}


# predefined attribute kinds
# Equipment
insert multilangid "100" its dummy1 = "".
insert mldescription "100" its 
  multilangid = "100", 
  language = "1",
  description = "Equipment".
insert mldescription "101" its 
  multilangid = "100", 
  language = "2",
  description = "Uitrusting".
insert attribute kind "1" its
  multilangid = "100".


# all known attribute sets
insert attribute set "1" its class = "address".
insert attribute set "2" its class = "contact".
insert attribute set "3" its class = "product kind".
insert attribute set "4" its class = "product".
insert attribute set "5" its class = "resource".
insert attribute set "6" its class = "order".


# with attributes you can add fields on the fly to any type.
# That type should have the attributevalue set field.
base attribute ivalue (I9).
base attribute cvalue (I9).
base attribute bvalue (I9).

type attributevalue set (I9)      = attribute set.
type attributevalue (I9)          = attributevalue set, attribute set item.
type attributevalue integer (I9)  = [attributevalue], attribute ivalue.
type attributevalue char (I9)     = [attributevalue], attribute cvalue.
type attributevalue boolean (I9)  = [attributevalue], attribute bvalue.
type equipmentvalue (I9)          = [attributevalue], attribute bvalue.

# assert attribute value its noinlinedvalue (True) = attribute set item its inlined.

{ 
create unique clustered index idx_attributevalueC on attributevalue (id_attributevalue, [id_attribute set item])
go

}


# a resource (type) or address (type) can have equipment.
# Need for equipment can be specified by product (type) or order.
# Equipments are modelled as special attributes.


# Simple calendar.
base calendar name (V40).
base weekday (I1) (0..6).
type week calendar (I9) = calendar name.
type calendar instance (I9) = week calendar, start_date.
type opening time (I9) = week calendar, weekday, from_time, till_time.


{
create unique clustered index "idx_calendar instanceC" on "calendar instance" ("id_week calendar", start_date)
create unique clustered index "idx_opening timeC" on "opening time" ("id_week calendar", weekday, from_time)
go

}


# phone/email base
base phone (V20).
base fax (V20).
base email (V60).
base website (V80).

# address
base country name (V40).
base city name (V60).
base address code (V40).
base street name (V80).
base door number (V5).
base door number postfix (V20).
base area description (V80).
base zipcode (V10).
base contact person (V60).

type country (I3) = country name.
type city (I5) = city name, country.

# id of location in network
base localisation id (I9). 

type address kind (I3) =
    multilangid, attributevalue set,
    pickup_minute, delivery_minute,
    optional week calendar.

type address (I6) = 
    address kind, address code,
    street name, door number, door number postfix,
    area description, 
    zipcode, city, 
    phone, fax, email,
    contact person,
    attributevalue set,
    pickup_minute, delivery_minute,
    localisation id,
    optional week calendar,
    active, comment.

{
create unique index idx_city1 on city(id_country, [city name])
go

}


# some addresses are depots
type depot (I6) = [address].


# contact
base contact name (V80).
base fileas name (V80).
base contact code (A10).
type contact (I6) = unique contact code, contact name, fileas name,
                    phone, fax, email, website,
                    optional visiting_address,
                    optional pobox_address,
                    optional billing_address,
                    attributevalue set, 
                    active, comment.
type contact address (I6) = [address], contact.

{
create index idx_contact_address1 on [contact address] (id_contact)
go

}


# a contact can fulfill several roles
type role (I4) = multilangid.
type contact role (I6) = contact, role.

{
create unique clustered index idx_contact_roleC on [contact role] (id_contact, id_role)
go

}


# for every contact special text or notes can be specified
type text kind (I2) = multilangid.
type contact text (I6) = contact, text kind, long description.

{
create unique clustered index idx_context_textC on [contact text] (id_contact, [id_text kind])
go

}


# A user can place any contact on his desktop

base user name (V30).
type user (I6) = user name.
type desktop (I6) = user, contact.


# product
type product kind (I4) = multilangid, attributevalue set.
type product (I8) = product kind, multilangid, attributevalue set.

#assert product its attribute class (A13) ("product") = attributevalue set its attribute set its class.


# order
# an order is or an A order, or an B order, or both. If it is both, then
# this implies it is an AB order.

base tentative (B).
base reference (V40).

type order (I9) = 
    contact, tentative,
    order_reference,    
    product,
    attributevalue set, comment.

type A order (I9) = 
    [order], 
    pickup_address, pickup from_date, pickup till_date,
    pickup_reference.

type B order (I9) = 
    [order],
    delivery_address, delivery from_date, delivery till_date,
    delivery_reference.

type AB order (I9) = 
    [A order], [B order].


# per order per unit we can assign the amount of a product for that order.

type order amount (I9) =
    order, uvalue, unit.

{
create unique clustered index idx_order_amountC on [order amount] (id_order, id_unit)
go

}


# a contact should be able to group pickups or deliveries.

type pickup group (I9) = optional dummy1.

type pickup group item (I9) = 
    pickup group, order.

type delivery group (I9) = optional dummy1.

type delivery group item (I9) = 
    delivery group, order.


# a contact should be able to specify order of pickup or delivery

type pickup after (I9) =
    previous_order, next_order.

type delivery after (I9) =
    previous_order, next_order.


# it should be possible to specify the transports along which
# an order is transported from A to B. A transport is the basic
# unit of planning.
base transport sequence (I2).
type transport task (I9) = address.
type transport (I9) = 
    order, 
    start_transport task, stop_transport task, 
    transport sequence.

{
create clustered index idx_transportC on [transport] (id_order, [transport sequence])
go
}


# assert valid first transport (True) =
#   transport its order its A_address =
#   min transport its from_transport task its address
#   per order


# resource
base driver name (V80).
base charter name (V80).

type resource kind (I2)  = 
    multilangid, attributevalue set.
type resource (I6)       = 
    resource kind, multilangid, attributevalue set,       
    active, reason inactive, comment.

type resource group (I6) = [resource].

type truck (I6) =
    [resource], charter name.
type driver (I6) = 
    [resource], driver name.


# it's possible to specify max capacities for resource kind and resource.

type resource kind capacity (I7) =
    resource kind, uvalue, unit.

type resource capacity (I7) =
    resource, uvalue, unit.

{
create unique clustered index "idx_resource kind capacityC" on "resource kind capacity" ("id_resource kind", id_unit)
create unique clustered index "idx_resource capacityC" on "resource capacity" ("id_resource", id_unit)
go

}

# not all resource kinds are allowed at all address kinds.
# not specified is allowed.

base allowed (B).

type allowed resource kind (I9) =
    address kind, resource kind, allowed.

{
create unique clustered index "idx_allowed resource kindC" on "allowed resource kind" ("id_address kind", "id_resource kind")
go

}


# not all resource kinds can be combined with all other resource kinds
# not specified is allowed.

type resource kind coupling (I9) =
    from_resource kind, to_resource kind, allowed.

{
create unique clustered index "idx_resource kind couplingC" on "resource kind coupling" ("from_resource kind", "to_resource kind")
go

}


#
# Calculator specific stored procedures.
#

# sp_get_equipment can be used to get equipments and requisites.

{
create procedure sp_calc_get_equipment 
  @id integer as
}

get equipmentvalue its attributevalue its attribute set item its attribute
  where attributevalue its attributevalue set = :id.

{
go
}


# get a single address

{
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_calc_get_address]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
   drop procedure [dbo].[sp_calc_get_address]
go

create procedure sp_calc_get_address
  (@id integer) as
}

get address "@id" its attributevalue set.

{
go
}


# get a single resource

{
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_calc_get_resource]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
   drop procedure [dbo].[sp_calc_get_resource]
go

create procedure sp_calc_get_resource
  (@id integer) as
}

get resource "@id" its attributevalue set.

{
go
}


# get all resources

{
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_calc_get_all_resources]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
   drop procedure [dbo].[sp_calc_get_all_resources]
go

create procedure sp_calc_get_all_resources as
}

get resource its attributevalue set.

{
go
}


# get resource capacity

{
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_calc_get_resource_capacity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
   drop procedure [dbo].[sp_calc_get_resource_capacity]
go

create procedure sp_calc_get_resource_capacity
  (@id integer) as
}

get resource capacity its uvalue, unit
  where resource = :id.

{
go
}


# get order amount

{
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_calc_get_order_amount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
   drop procedure [dbo].[sp_calc_get_order_amount]
go

create procedure sp_calc_get_order_amount
  (@id integer) as
}

get order amount its uvalue, unit
  where order = :id.

{
go
}


# get order transport

{
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_calc_get_transport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
   drop procedure [dbo].[sp_calc_get_transport]
go

create procedure sp_calc_get_transport
  (@id integer) as
}

get transport its 
    start_transport task,
    start_transport task its address,
    start_transport task its address its localisation id,
    stop_transport task,
    stop_transport task its address,
    stop_transport task its address its localisation id
  where order = :id.

{
go
}


end.
