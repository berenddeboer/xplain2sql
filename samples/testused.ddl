# to be used file

base a1 (A1).
base a2 (A10) "ABC%".
base a3 (A123) = "abc".
base a4 (A10) = "abc", "def".
# a5 should generate warning
base a5 (A2) = "abc".
base a6 (A1) required.
base a7 (A2) = "", "aa", "bb".


base i1 (I1).
base i2 (I1) = 1.
base i3 (I1) = 1, 2.
base i4 (I1) = 1, 2, 3, 4, 5, 6, 10.
base i5 (I1) (1..*).
base i6 (I1) (*..0).
base i7 (I1) (*..*).
base i8 (I1) (0..1).
base i9 (I20) required.


type t1 (I4) = a1, a4, a6, i8, i9.
