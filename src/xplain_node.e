indexing

	description: "Xplain general node, used a lot when parsing."

	author:		"Berend de Boer <berend@pobox.com>"
	copyright:	"Copyright (c) 1999, Berend de Boer"
	date:			"$Date: 2008/12/15 $"
	revision:	"$Revision: #6 $"

class

	XPLAIN_NODE [G]


feature -- Access

	item: G
			-- Current item

	next: like Current
			-- Next node or Void


feature {NONE} -- Initialization

	make (an_item: G; a_next: like Current) is
		require
			item_not_void: an_item /= Void
		do
			item := an_item
			next := a_next
		end


feature -- Status

	has (v: G): BOOLEAN is
			-- Does container include `v'?
		local
			node: like Current
		do
			from
				node := Current
			until
				Result or else
				node = Void
			loop
				Result := node.item.is_equal (v)
				node := node.next
			end
		end


feature -- List building

	last: like Current is
			-- Return last item in list.
		local
			node: like Current
		do
			from
				node := Current
			until
				node.next = Void
			loop
				node := node.next
			end
			Result := node
		ensure
			valid_result: Result /= Void
		end

	set_next (anext: like Current) is
			-- Set the next item.
		require
			is_last_node: next = Void
		do
			next := anext
		end

invariant

	item_not_void: item /= Void

end
