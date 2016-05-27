note

	description: "Traverses over universe to return all types."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"


class

	XPLAIN_UNIVERSE_TYPES_CURSOR [G, K -> HASHABLE]


inherit

	XPLAIN_UNIVERSE_PARTIAL_CURSOR [G, K]


create

	make


feature -- Access

	item_as_type: XPLAIN_TYPE
			-- As item, but typed.
		do
			Result ?= item
		end

	name_in_query (sqlgenerator: SQL_GENERATOR): STRING
			-- Name as it occurs in select statements.
		do
			Result := item_as_type.quoted_name (sqlgenerator)
		end


feature {NONE} -- Check

	skip_this_item: BOOLEAN
			-- Is `item' an XPLAIN_TYPE?
		do
			Result := item_as_type = Void
		end


end
