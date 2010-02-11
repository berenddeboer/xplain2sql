# Example from Can We Rely on SQL
# Plus additions from "Improving SQL Applications by 
# Introducing Semantic Principles"


database sales.

base day (A3) = "Mon", "Tue", "Wed", "Thu", "Fri", "Sat".
base week (I2).
base amount (R4,2).
base description (A13).
base stock (I4).
base price (R4,2).
base number (I4).
base name (A60).
base street (A60).
base zipcode (A10).
base city (A40).

type item (A4) = description, stock, price.
type sale (A4) = week, day, item, number, amount.
#type sale (A4) = week, day, item, number, unit_price, amount.
#init default sale its number = 1.
#init sale its unit_price = item its price.
type invoiced sale (A4) = [sale], name, street, zipcode, city.

insert item "i1" its description = "table", stock = 20, price = 234.00.
insert item "i2" its description = "chair", stock = 50, price = 114.00.
insert item "i3" its description = "lamp", stock = 15, price = 378.00.

insert sale "s1" its week = 1, day = "Mon", 
  item = "i2", number = 1, amount = 114.00.
insert sale "s2" its week = 1, day = "Thu", 
  item = "i1", number = 2, amount = 468.00.
insert sale "s3" its week = 1, day = "Wed", 
  item = "i3", number = 1, amount = 378.00.
insert sale "s4" its week = 2, day = "Mon", 
  item = "i1", number = 1, amount = 234.00.
insert sale "s5" its week = 2, day = "Sat", 
  item = "i2", number = 4, amount = 456.00.


# get all items.

get item.


# get all sold items and when they're sold.

get sale its week, day, item its description.


# Determine the turnover per item.

extend item with turnover =
  total sale its amount
  per item.

get item its turnover.


# Determine items for which the turnover decreased in 
# week 2 compared with week 1.

extend item with turnover1 =
  total sale its amount
  where week = 1
  per item.

extend item with turnover2 =
  total sale its amount
  where week = 2
  per item.

get item its description
  where turnover1 > turnover2.


end.
