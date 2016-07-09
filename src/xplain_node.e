note

	description: "Xplain general node, used a lot when parsing."

	author:		"Berend de Boer <berend@pobox.com>"

class

	XPLAIN_NODE [G]


create

	make


feature -- Access

	item: G
			-- Current item

	next: detachable like Current
			-- Next node or Void


feature {NONE} -- Initialization

	make (an_item: like item; a_next: like next)
		require
			item_not_void: an_item /= Void
		do
			item := an_item
			next := a_next
		end


feature -- Status

	has (v: G): BOOLEAN
			-- Does container include `v'?
		local
			node: detachable like Current
		do
			from
				node := Current
			until
				Result or else
				node = Void
			loop
				Result := node.item ~ v
				node := node.next
			end
		end


feature -- List building

	last: detachable like Current
			-- Return last item in list.
		local
			node: like Current
		do
			from
				node := Current
			until
				not attached node.next
			loop
				if attached node.next as n then
					node := n
				end
			end
			Result := node
		ensure
			valid_result: Result /= Void
		end

	set_next (anext: detachable like Current)
			-- Set the next item.
		require
			is_last_node: next = Void
		do
			next := anext
		end

invariant

	item_not_void: item /= Void
	next_implies_there_is_a_last: attached next implies attached last

end
