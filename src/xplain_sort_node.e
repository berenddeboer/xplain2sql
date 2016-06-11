note

	description:
		"Xplain node to describe sort order in get statement."

	author:		"Berend de Boer <berend@pobox.com>"
	copyright:	"Copyright (c) 2000, Berend de Boer"


class

	XPLAIN_SORT_NODE


inherit

	XPLAIN_NODE [XPLAIN_ATTRIBUTE_NAME_NODE]
		rename
			make as make_node
		end

create

	make


feature -- Creation

	make (a_item: XPLAIN_ATTRIBUTE_NAME_NODE; a_ascending: BOOLEAN; a_next: detachable like Current)
		require
			has_item: a_item /= Void
			a_item_contains_types: a_item.item.abstracttype_if_known /= Void
		do
			make_node (a_item, a_next)
			ascending := a_ascending
			a_item.item.abstracttype.hack_anode (a_item)
		end


feature -- State

	ascending: BOOLEAN
			-- sorted ascending or descending


end
