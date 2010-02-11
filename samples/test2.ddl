database test2.

base a1 (A10).
base a2 (A10).
base b1 (B).
base b2 (B) required.
base i (I4).

type t1 (I1) = a1, optional test_a1.

base date (D).

base bot name (A128).

type bot (I9) = bot name, last seen_date, i, t1.
type authorised bot (I9) = [bot], last received work_date.

#type bot work (I9) = authorised bot, i.

# procedure test =

# #extend bot with work = any bot work per authorised bot its bot.
# extend bot with is authorised =
#   any authorised bot
#   per
#    bot.

# get bot its is authorised.

# end.

#get bot its work.

#get bot where bot name = "*test".

procedure test =


extend bot with included =
  (i > 0).

get bot
  where
    included.

end.


end.
