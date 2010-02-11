# Supplier example, chapter 6 in Semantic Data Modeling.

database supplier.

# First the DDL.

base company name (A30).
base town (A30).
base make (A20).
base price (R9,2).
base user name (A30).
base quantity (I6) (1..999999).

type supplier (A4)  = company name, business_town.
type article (A6)   = make, price.
type user (A4)      = user name, home_town.
type customer (A4)  = supplier, user.
type supply (I8)    = customer, article, quantity.


# Example 13: Which users are customers of all suppliers?

extend user with number =
    count customer
    per user.

value numberofsuppliers =
    count supplier.

get user its user name, home_town
    where number = numberofsuppliers.


# Example 14: Select suppliers with the same users as customer as the
# supplier identified by S3.

extend user with S3 customer =
    any customer
    where supplier = "S3"
    per user.

extend supplier with numberofS3customers =
    count customer
    where user its S3 customer
    per supplier.

value number S3 =
    count user
    where S3 customer.

get supplier its company name, business_town
    where number S3 = numberofS3customers.


# Example 15: Select suppliers with the same users as customer as the
# supplier with identification S3.

extend supplier with numberofcustomers =
    count customer
    per supplier.

# already exists
#extend user with S3 customer =
#    any customer
#    where supplier = "S3"
#    per user.

extend supplier with number =
    count customer
    where user its S3 customer
    per supplier.

value numberS3 =
    count user
    where S3 customer.

get supplier its company name, business_town
  where 
    numberS3 = number and
    number = numberofcustomers.


end.
