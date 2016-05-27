note

	description: "Traverses over universe to return a subset of types."

	usage: "Effect skip_this_item in descendents."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #2 $"


deferred class

	XPLAIN_UNIVERSE_PARTIAL_CURSOR [G, K -> HASHABLE]


inherit

	DS_HASH_TABLE_CURSOR [G, K]
		redefine
			start,
			forth,
			is_first
		end


feature -- Access

	name_in_query (sqlgenerator: SQL_GENERATOR): STRING
			-- Name as it occurs in select statements and such, not the
			-- type name. Unfortunately, some names need a role, how to
			-- handle that?
		require
			have_item: not after
			sqlgenerator_not_void: sqlgenerator /= Void
		deferred
		ensure
			got_name: Result /= Void and then not Result.is_empty
		end


feature -- Status report

	is_first: BOOLEAN


feature -- Cursor movement

	start
		do
			precursor
			if not after then
				if skip_this_item then
					forth
				end
			end
			is_first := not after
		end

	forth
		do
			is_first := False
			precursor
			if not after then
				if skip_this_item then
					forth
				end
			end
		end


feature {NONE} -- Check

	skip_this_item: BOOLEAN
			-- True if this item must be skipped.
		deferred
		end


end
