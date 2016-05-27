note

	description: "Traverses over universe to return all constants."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"


class

	XPLAIN_UNIVERSE_CONSTANTS_CURSOR [G, K -> HASHABLE]


inherit

	XPLAIN_UNIVERSE_PARTIAL_CURSOR [G, K]


create

	make


feature -- Access

	item_as_constant: XPLAIN_VARIABLE
			-- As item, but typed.
		do
			Result ?= item
		end

	name_in_query (sqlgenerator: SQL_GENERATOR): STRING
			-- Name as it occurs in select statements.
		do
			Result := item_as_constant.quoted_name (sqlgenerator)
		end

feature {NONE} -- Check

	skip_this_item: BOOLEAN
			-- Is `item' an XPLAIN_VARIABLE?
		do
			Result := item_as_constant = Void
		end


end
