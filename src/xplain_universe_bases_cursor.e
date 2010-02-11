indexing

	description: "Traverses over universe to return all bases."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"


class

	XPLAIN_UNIVERSE_BASES_CURSOR [G, K -> HASHABLE]


inherit

	XPLAIN_UNIVERSE_PARTIAL_CURSOR [G, K]


create

	make


feature -- Access

	item_as_base: XPLAIN_BASE is
			-- As item, but typed.
		do
			Result ?= item
		end

	name_in_query (sqlgenerator: SQL_GENERATOR): STRING is
			-- Name as it occurs in select statements.
		do
			Result := item_as_base.q_sql_select_name (sqlgenerator, Void)
		end

feature {NONE} -- Check

	skip_this_item: BOOLEAN is
			-- Is `item' an XPLAIN_BASE?
		do
			Result := item_as_base = Void
		end


end
