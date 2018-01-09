
-- ignore this

# database
database test.

# test echo
echo "Hi Berend".

# test base A
base a1 (A1).
base a2 (A10) "ABC%".
base a3 (A123) = "abc".
base a4 (A10) = "abc", "def".
# a5 should generate warning
base a5 (A2) = "abc".
base a6 (A1) required.
base a7 (A2) = "", "aa", "bb".
base a8 (A80) required.

# test base C
base c1 (C1).

# test base B
base b1 (B).
base b2 (B) required.

# test base I
base i1 (I1).
base i2 (I1) = 1.
base i3 (I1) = 1, 2.
# should get warning for number 10, doesn't fit in domain.
base i4 (I1) = 1, 2, 3, 4, 5, 6, 10.
base i5 (I1) (1..*).
base i6 (I1) (*..0).
base i7 (I1) (*..*).
base i8 (I1) (0..1).
base i9 (I20) required.
# test behaviour if too large for most databases
base i10 (I99).
base i11 (I2) (0..*).

# test base M
base m1 (M).
base m2 (M) required.
base m3 (M) (0..1000).

# test base P
base p1 (P).

# test base R
base r1 (R1,1).
base r2 (R4,3) required.
base r3 (R4,0) (0..1000000).
base r4 (R10,2).

# test base T
base text1 (T).
base text2 (T) required.

# identifiers with spaces
base price pro meter (R4,2).
base another price pro meter (R4,2).

# test type
type t1 (I4) = a1, a4, a6, i8, i9.
type t2 (I1) = required a1, optional a4.
type t3 (I9) = t1, optional t2.
type t4 (A10) = a2, a1.
type t5 (I4) = r1, r2, r3, r4, t1.
type t6 (I4) = price pro meter, a8, text1.
type t7 (I10) = b1, b2.
type t8 (I4) = a1, t1.
type t9 (I4) = t8, i6, i7.
type tunused (I4) = t8, i6, i7.

# names with spaces
base b space (A10) = "abc", "def".
base i space (I4).
type t space (I4) = t8, i3, i4, b space, i space.
type t space space (I4) = t space.
type t spc spc spc (I4) = [t space space].

# a very long name
type t long long long long long long long long long long long long (I9) = i3.

# create self reference
type tsr1 (I4) = a1, next_tsr1.
type tsr2 (I4) = [previous_tsr2], a1.


# test constant definition
constant v1 (A40).
constant v2 (I1).
constant v3a (I4).
constant v3b (I4).
constant v3c (I4).
constant v4 (B).
constant v space (I2).
constant v space space (I2).

# test constant assignment
v1 = ("abc").
v2 = (0).
v3a = (( 1 * 17.5 ) / 10).
v3b = (v2 + 10).
v3c = (- v2 + 10).
v4 = (True).
v space = (1).
v space space = (v space).

# test value assignment and retrieval
value valv1 = v1.
value valv1.

# test insert
insert t1 "1" its a1 = "1", a4 = "abc", a6 = "Y", i8 = 0, i9 = 333.
insert t1 "10" its a1 = "1", a4 = "def", a6 = "Y", i8 = 0, i9 = 222.
insert t4 "ABC" its a1 = "1", a2 = "ABC".
insert t5 "1" its r1 = 1.0, r2 = 2.0, r3 = 3.0, r4 = 4.0, t1 = 1.
insert t5 "2" its r1 = 1.0, r2 = 2.001, r3 = 3.0, r4 = 4.0, t1 = 10.
insert t6 "5" its price pro meter = 1.0, a8 = "My 's test".

# test insert with '*' identification
insert t8 * its t1 = 1, a1 = "1".

# test if literal constant can be used in insert.
# we shouldn't do a select from XplainVariable, as most SQL dialects
# don't support that.
insert t1 * its a1 = "1", a4 = "abc", a6 = "Y", i8 = v2, i9 = 333.

# test insert to see if primary key error is given when
# non-integer instance id is given.
# use old-style identification to see if warning is generated.
#insert t1 "*" its a1 = "1", a4 = "abc", a6 = "Y", i8 = 0, i9 = 444.

# test get
get t1.
get t4.
get t4 "ABC".
get t1 where id() >= 1.
get t4 its a1.
get t3 its t1 its a4.
get t5 its r1, r3, t1 its a4.
get t9 its t8 its t1 its a1.
get t8 its t1 its a1.
get t5 its `r1', `r3'.

# test get with sort
get t1 per a1.
get t1 per a1, a4.
get t1 per i8, - a1.
get t8 per t1 its a1.

# test with sort on wrong attribute
# must reject
#get t1 per i1.

# test get with text before identification
get "id: " t1 its a1.

# test get with column renaming
get t1 its a1 as new name.
get t1 its a1 as new name, i9 as another name.
get t8 its t1 its a1 as new name, a1 as my name.

# test if self reference is optional
insert tsr1 "1" its a1 = "?".
insert tsr2 "1" its a1 = "?".

# get self reference
get tsr1 its next_tsr1 its next_tsr1.
get tsr2 its previous_tsr2 its previous_tsr2.
get tsr1 where next_tsr1 = null.
get tsr1 where next_tsr1 = null or next_tsr1 = null.
get tsr1 where next_tsr1 <> null.
get tsr1 where next_tsr1 its next_tsr1 = null.

# get with strings
get t1 its "a1: ", a1.

# get identifiers only
get t5 its "".

# test delete
delete t4 "ABC".
get t4.
delete t5.
get t5.

# test update
update t1 "1" its a1 = "2".
get t1.
update t1 "1" its a4 = "def", a6 = "0", i9 = 123.
get t1.
update t1 "1" its i9 = i9 + 1.
get t1 its i9.
update t space its b space = "abc".

# test its list in update.
update t8 its a1 = t1 its a1.

# test drop
# drop base
purge i1.
purge another price pro meter.
# drop type
purge t spc spc spc.
purge t space space.
purge tunused.
# drop constants
purge v1.
purge v space space.
purge v space.

# dropping of columns not yet implemented

# test get with function
get count t1.
get count t3 its t1.
get count t3 its t1 its a1.
get max t1 its i9.
get total t5 its r1.
get min t3 its t1 its i9.
get any t3.
get nil t5.

# existence with properties, should parser accept that??
get any t3 its t1.
get nil t5 its r1.

# test some, not always implementable.
# Output for this is flawed for certain:
get some t1.
# this one works better, but some should be really supported because
# t1 has more than one row.
#get some t1 its i9.
# this one should always work because t6 has just one row.
get some t6 its price pro meter.

# next_tsr1 can be null, should have a coalesce in the count
# to get an error if incorrect, we need at least one row in tsr1.
get count tsr1 its next_tsr1.

# for an optional attribute we emit two coalesces.
type toptional (I9) = optional i7.
get total toptional its i7.

# test where clause.
get t1 where a1 = "1".
get t1 where a1 = "".
get t1 where a1 = """".
get t3 its t1 its a4 where t1 its i9 = 333.
get t3 its t1 its a4 where t1 its i9 * 2 > 600.
get t4 "AB" where a1 = "1".
# where with booleans, hard for dialects that don't have True booleans
# like SQL Server and InterBase.
get t7 where b1.
get t7 where (b1).
get t7 where not b1.
get t7 where (not b1).

# where with wild card characters.
get t1 where a1 = "_".
get t1 where a4 = "a*".
get t1 where a4 = "a_c".
get t1 where a4 = "a*b*".
get t1 where a4 = "*c".
get t1 where a4 = combine("a", "*").

# test simple init
base t10i10 (I2) (1..*).
type t10 (I4) = t1, a1, a4, a6, i8, i9, b1, b2, another_i9, t10i10.
init t10 its a4 = "abc".
init t10 its i8 = 0.
init default t10 its b1 = False.
init default t10 its b2 = True.
init default t10 its i9 = 0.
# override, should give warning
init default t10 its i9 = -1.
init default t10 its t1 = 1.
#but complex init in case dialect does support only constants as inits.
init t10 its another_i9 = 33 * 2.
init t10 its t10i10 = 1 + 1.

insert t10 "1" its a1 = "Y", a6 = "X".

# after insert

# test more complex init
# first define it
# init b1 does not work on InterBase 6 has it does not have booleans
type t11 (I4) = a1, a4, a6, i8, i9, another_i9, b1.
init t11 its i9 = 3.
init t11 its a1 = a6.
init t11 its another_i9 = i8 + 10.
init default t11 its b1 = (a4 = "abc").

# now i9 and a1 don't have to be specified in insert
insert t11 "1" its a4 = "abc", a6 = "X", i8 = 0.

# init such that insert in sp should be just 'insert default values'
# does not work on InterBase, gives error.
type t14 (I4) = a1.
init t14 its a1 = "A".

#most complex init: just not supported by InterBase up to version 6 yet.
type t12 (I4) = a1, t1.
init t12 its a1 = t1 its a1.

# test if-then-else in init statement
type t12b (I4) = i8, i9.
init t12b its i8 = if i9 > 5 then 0 else 1.
insert t12b * its i9 = 1.
insert t12b * its i9 = 10.
get t12b.

# test if * range does work
type t13 (I3) = i5, i11.
insert t13 "1" its i5 = 1, i11 = 99.

# test value
value val1 = 1.
value val2 = "test".
value val3 = count t1.
value val4 = v2.
value val5 = 2/5 + 3/7.
value val6 = val5.
value val2.
value val5.
value val7 = total t5 its r1.
value val8 = True.
# not supported in SQL Server it seems:
# value val9 = True and False.
value val space = "test".
value val space.
value vdate = systemdate.

# new kind of value selection
value val20 = some t11 "1" its a4.
value val21 = some t3 "1" its t1 its a1.
value mysome1 = some t6.
value mysome2 = some t6 "5".

# boolean values
value val30 = true.
value val31 = false.
value valu32 = val30 and val31.
value valu33 = val30 or val31.

# select type instead of base
value val34 = some t3 "1" its t1.

# test extend
extend t1 with mytest = 1.
get t1 its mytest.
extend t1 with mytest2 = 1 + 2.
extend t1 with t5count = count t5 per t1.
extend t1 with t5min = min t5 its r1 per t1.
extend t1 with t5any = any t5 per t1.
extend t1 with t5nil = nil t5 per t1.
get t1 its mytest, t5count.

# update with extend
update t1 its i8 = mytest.
update t1 its i9 = t5count.
update t1 its i8 = 0
  where mytest = 1.

# delete with extend
delete t1 where mytest = 3.

# update extend itself
# because a literal is used, every dialect should be able to support it
# but you will need the -noextendview flag.
update t1 its mytest = 2.

# Because it references itself, also every dialect should be able to support it
update t1 its mytest = mytest + 1.

# Because the where clause refers to the extend, it should work for
# all dialects
update t1 its mytest = 0
  where
    mytest > 2.

update t1 its mytest = mytest - 1
  where
    mytest > 2.

# update extend with other attribute.
update t1 its mytest = i8.

# get with per on extend

get t1 its mytest per mytest.
get t1 per mytest.


# update from value
# gives error on Oracle, because the value table doesn't preserve its rows.
# so basically the value table on Oracle is useless, just interesting to
# get things compile, but you can't use it.
update t1 its i8 = val1.
update t1 its i8 = 0
  where i8 <> val1.

# torture test of the join builder
type ta (I1) = a1.
type tb (I1) = ta, other_ta.
type tc (I1) = ta.
type td (I1) = tb, tc, his_ta, her_ta.
type te (I1) = first_tc, second_tc.

get td its tb, tb its ta, tb its ta its a1.
get td its tc its ta its a1, tb its ta its a1.
get td its his_ta its a1, her_ta its a1.
get td its his_ta its a1, her_ta.
get td its tb its ta its a1, tb its other_ta its a1.

get te its
    first_tc,
    first_tc its ta,
    first_tc its ta its a1,
    second_tc,
    second_tc its ta,
    second_tc its ta its a1.

get td its tc
  where
    tc = 1 and
    his_ta its a1 = "a" and
    (tc its ta its a1 = "A" or
    tc its ta its a1 = "B").

# self reference join torture test

type node (I4) = a1, parent_node.

get node its parent_node its parent_node its parent_node.
get node its parent_node its parent_node its parent_node its parent_node.

# visual inspection only, is extended table correctly joined with from table?
# had bug where it was joined with the last! parent_node
extend node with temp = "a".

get node its
  parent_node its parent_node,
  temp.

get node its
  parent_node its parent_node,
  parent_node its parent_node,
  parent_node its parent_node its parent_node,
  temp.

get node its
  parent_node its parent_node,
  parent_node its parent_node,
  parent_node its a1,
  parent_node its a1,
  temp.

# this query does not work on MySQL 5. Comment it out when testing:
get node its
  temp,
  parent_node its temp.

# test extend with per property with role.
extend ta with tbcount = count tb per other_ta.

# test inheritance

type inh1 (I4) = [t1].
type inh2 (I4) = [t1], [t2].

# test system functions
# DB2 likes 128.
# This creates an insert sp with default values, which doesn't work
# for InterBase.
# MySQL 5 doesn't support systemfunctions, comment out when testing.
base tfname (A128).
base tfdate (D).
type tf1 (I9) = tfname, tfdate.
init tf1 its tfname = loginname.
init tf1 its tfdate = systemdate.


# string functions
get t1 its combine (a1, ".").
get t1 where a1 = combine ("test", "%").
get t1 where a1 = combine ("test", "%", a1).

# test indexes
# this should generate exception
# index t1 its faults = ano1.
index t1 its firstindex = a1.
index t1 its `second index' = a1, a4.

unique index t2 its `first index' = a1.
unique clustered index t2 its `second index' = a1, a4.


# test asserts
type t20 (I4) = a1, a4, a6, i8, i9, t1.
assert t20 its assert1 (*..*) = i8 * i9.
assert t20 its assert2 (*..*) = i8 * 0.10.
assert t20 its assert3 = t1 its i8 * 2.
assert t20 its assert4 (*..*) = i8 * i9 * t1 its i8.
assert t20 its assert5 = 1.
assert t20 its assert6 = assert5 * 2.
assert t20 its assert7 = i8 / 2.
assert t1 its assert5 = count t20 per t1.

assert t3 its b1 = t1 its a1.
assert t3 its b2 = b1.


# test includes

.include "include.ddl"

get tinclude its a1.


# test stored procedures

base short text (A60).
base long text (T).

type name (I9) =
  unique short text, long text.

insert name * its short text = "hello".

# empty procedure
# does not work on InterBase and Oracle.

procedure empty =
end.

# simple get.

procedure retrieve names =

get name.

end.

# only ids

procedure retrieve name ids =

get name its "".

end.

# get instance.

procedure retrieve name instance with name =

get name ?name.

end.


# get names with text

procedure retrieve names by text with short text =

get name
  where short text = ?short text.

end.

# insert support

procedure `insert name1' with short text =

insert name *
  its short text = ?short text.

end.

procedure `insert name2' with short text =

insert name *
  its short text = ?short text.

value last id = inserted name.

value last id.

end.

procedure `insert name3' with short text, long text =

insert name * its
  short text = ?short text,
  long text = ?long text.

end.


# value support

procedure `retrieve value1' =

value v = count name.

value v.

end.


procedure `retrieve value2' =

value v = 200.

value v.

end.


procedure `retrieve value3' =

value v = count name.
value w = any name.

value v.

end.


# extend and update support
# does not work on InterBase/Oracle

procedure `text extend1' =

extend t1 with acol = 1.

update t1 its a1 = "Z".

get t1 its acol.

end.


# some value tests

procedure test values =

value pv1 = False.
value pv2 = (True).
# this does not work on InterBase (no case/when):
value pv3 = (1 = 2).
value pv4 = any name.
value pv5 = count name.
# the following two also doesn't work on InterBase (no case/when):
value pv6 = (pv5 > 0).
value pv7 = (not pv1).
value pv8 = 1.
value pv9 = pv8 * 10.
# extends inside so doesn't work with InterBase/Oracle:
extend t1 with acol1 = pv8.
extend t1 with acol2 = pv5.

# update values
value pv8 = 2.

end.

# give value another value, should declare it just once

procedure test set values twice =

value pv9 = 1.
value pv9 = 2.

end.


# procedures with a get with function

procedure testmin =

get min t1 its i8.

end.

procedure testmax =

get max t space its i space.

end.

procedure testtotal =

get total t1 its i8.

end.

procedure testcount1 =

get count t space.

end.

procedure testcount2 =

get count t space its i space.

end.

procedure testsome =

get some t space.

end.

procedure testany =

get any t space.

end.

procedure testnil =

get nil t space.

end.


# postgresql: properly should create a float output as type, not an int output.

procedure correcttype =

get t20 its assert7.

end.


# postgresql: test if we can insert sql into the declare block

procedure user sql {  rec record } =

get t1.

end.


# purge procedures

# procedure empty not created on InterBase/Oracle, so purging won't work.
purge empty.
purge retrieve names.

end.
