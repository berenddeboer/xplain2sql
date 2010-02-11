# Bank case study, chapter 13 in Semantic Data Modeling.

# representations are not given in this example, so I made some guesses.
# Other deviations:
# 1. case is not yet supported, it's replaced by mycase, a char
#    attribute you have to provide when inserting rows.
# 2. purchase_value doesn't parse because of the keyword VALUE.
# 3. end_number doesn't parse because of the keyword END.
# 4. Currency was not defined.
# 5. postal_code is probably not a role, but should be postalcode
#
# Other deviations are noted per query.
#
# The dutch version [Bekke83] is more correct.

database bank.

base mycase (A32) required.
base currency code (A3).
base rate (R9,5).
base address (A80).
base postalcode (A10).
base giro (I7).
base town (A30).
base telephone number (A15).
base bank (A30).
base region (A30).
base name (A60).
base identification (A30).
base balance (R9,2).
base date (D).
base interest (R2,5).
base limit (I9).
base cheque card (A15).
base Eurocheque (A15).
base redemption method (I2).
base indication (I2).
base condition (I2).
base commission (R2,5).
base stockvalue (R4,3).
base number (I6).

type currency (I4)          = currency code, exchange_rate.
type office (I6)            = address, postalcode, town, telephone number,
                              postal_giro, bank, mycase.
type `head office' (I6)     = [office], region.
type branch (I6)            = [office], `head office'.
type holder (I9)            = name, address, postalcode, town, office,
                              identification.
type account (I9)           = holder, balance, transaction_date,
                              currency, mycase.
type current account (I9)   = [account], dr_interest, cr_interest, cr_limit,
                              cheque card, Eurocheque.
type mortgage account (I9)  = [account], current account, interest,
                              redemption method, collection_indication.
type saving account (I9)    = [account], condition, interest.
type business account (I9)  = [account], dr_interest, cr_interest,
                              cr_commission, cr_limit.
type stock (I9)             = account, nominal_stockvalue,
                              purchase_stockvalue, purchase_date, mycase.
type share (I9)             = [stock], number.
type bond (I9)              = [stock], start_number, last_number.


# fill with some data

insert office "1" its
    address = "Kalverstraat",
    postalcode = "1000 AA",
    town = "Amsterdam",
    telephone number = "123-456",
    mycase = "head office",
    postal_giro = 1,
    bank = "".
insert `head office' "1" its
    office = 1,
    region = "The Netherlands".

insert office "2" its
    address = "Leidseplein",
    postalcode = "1000 AA",
    town = "Amsterdam",
    telephone number = "",
    mycase = "branch",
    postal_giro = 1,
    bank = "".
insert branch "2" its
    office = 2,
    `head office' = 1.

insert office "3" its
    address = "Coolsingel",
    postalcode = "1200 AA",
    town = "Rotterdam",
    telephone number = "020-123456",
    mycase = "branch",
    postal_giro = 1,
    bank = "".
insert branch "3" its
    office = 3,
    `head office' = 1.


# queries

# Calculate the nominal value of shares and bonds per account
# Bug in original query: first extend in first query should be on share
# (not on account).

extend share with amount =
    number * stock its nominal_stockvalue.

extend bond with amount =
    (last_number - start_number + 1) *
    stock its nominal_stockvalue.

extend account with shartot =
    total share its amount
    per stock its account.

extend account with bondtot =
    total bond its amount
    per stock its account.

get account its holder, holder its office, shartot, bondtot, shartot + bondtot.


# Determine the account with the highest balance, subject to the
# exchange rate for each currency (currency being defined as composite type,
# leading to the valid statement: currency its exchange_rate).

extend account with cash =
    balance * currency its exchange_rate.

value maximum = max account its cash.

get account its holder, holder its office, cash
    where cash = maximum.


# Identify the branches without mortgage accounts.
# Bug in original query: per clause was missing holder.

extend office with mortgages =
    any account
    where mycase = "mortgage account"
    per holder its office.

get office its address, postalcode, town
    where mycase = "branch" and not mortgages.


# Determine the total value of shares for each regional head office
# holding shares.

extend office with totalshares =
    total share its number * stock its nominal_stockvalue
    per stock its account its holder its office.

extend office with office region =
    some `head office' its region
    per office.

get office its address, postalcode, town, office region, totalshares
    where mycase = "head office" and totalshares > 0.


# Select the branches located in towns with head offices.
# Bug in original query: it's not possible to get regions if you are
# questioning offices (head office is not an attribute of office.

extend office with same =
    any branch
    where office its town = `head office' its office its town
    per office.

get office its address, postalcode, town
    where mycase = "branch" and same.

end.
