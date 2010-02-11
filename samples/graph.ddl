database graph.

base description (A40).
base length (I4).

type node (A1) = description.
type arc (I4) = from_node, to_node, length.


# nodes

insert node "A" its description = "loc1".
insert node "B" its description = "loc2".
insert node "C" its description = "loc3".
insert node "D" its description = "loc4".
insert node "E" its description = "loc5".
insert node "F" its description = "loc6".
insert node "G" its description = "loc7".
insert node "H" its description = "loc8".


# arcs, matching figure 3 in "Fast recursive processing..."

insert arc * its from_node = "A", to_node ="B", length = 1.
insert arc * its from_node = "A", to_node ="B", length = 2.
insert arc * its from_node = "A", to_node ="C", length = 3.
insert arc * its from_node = "A", to_node ="F", length = 4.

insert arc * its from_node = "B", to_node ="D", length = 6.

insert arc * its from_node = "C", to_node ="B", length = 5.
insert arc * its from_node = "C", to_node ="D", length = 7.
insert arc * its from_node = "C", to_node ="E", length = 8.

insert arc * its from_node = "D", to_node ="E", length = 9.

insert arc * its from_node = "E", to_node ="G", length = 10.


# first part

extend node with first path = 0.

# The Xplain translation

# Initialization:

value counter = 0.

extend node with round visited = counter.

extend node with this round =
  nil arc
  per to_node.

# repeat until finished:

value counter = counter + 1.

update node its round visited = counter
  where
    this round.

purge node its this round.

extend node with this round =
  any arc its from_node
    where
      from_node its round visited = counter
  per to_node.

value finished =
  nil node
  where
    this round.

value cycles detected =
  any node
  where
    this round and round visited <> 0.

extend node with previous first path = first path.

purge node its first path.

extend node with first path =
  max arc its length + from_node its previous first path
  per to_node.


# The cascade

cascade node its first path =
  max arc its length + from_node its first path
  per to_node.

end.