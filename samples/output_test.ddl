# This test should actually test outputs, not just parsing.

database output.

base a1 (A10).
type t1 (I9) = a1.
type t2 (I9) = t1, a1.

insert t1 * its a1 = "1".
insert t1 * its a1 = "2".

insert t2 * its t1 = 1, a1 = "2".

extend t2 with e2 = false.

extend t1 with e1 = count t2 where e2 per t1.

# count should be zero
get count t1 where e1 > 0.

# count should be two
get count t1 where e1 = 0.


base a3 (A10).
base b4 (B).
type t3 (I9) = a3.
type t4 (I9) = t3, b4.

insert t3 * its a3 = "1".
insert t3 * its a3 = "2".

insert t4 * its t3 = 1, b4 = false.

extend t3 with e1 = count t4 where b4 per t3.

# count should be zero
get count t3 where e1 > 0.

# count should be two
get count t3 where e1 = 0.


base a5 (A10).
base b6 (B).
type t5 (I9) = a5.
type t6 (I9) = b6.
type t7 (I9) = t5, t6.

insert t5 * its a5 = "1".
insert t5 * its a5 = "2".

insert t6 * its b6 = false.

insert t7 * its t5 = 1, t6 = 1.

extend t5 with e1 = count t7 where t6 its b6 per t5.

# count should be zero
get count t5 where e1 > 0.

# count should be two
get count t5 where e1 = 0.


# Test if assert returns proper value
insert user "1" its user_name = "John".
insert user "2" its user_name = "Peter".
insert role "1" its role_name = "Administrator".
insert role "2" its role_name = "Sales".
insert user role * its user = 1, role = 2.
insert user role * its user = 2, role = 1.

assert user its has permission =
  any user role
  where
    role its role_name = "Administrator"
 per
   user.

# Should return scalar value 0
get some user "1" its has permission.

# Should return scalar value 0.
value permission = some user "1" its has permission.
value permission.

end.