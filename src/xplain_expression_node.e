indexing

	description: "Xplain linked list of expressions"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #7 $"

class

	XPLAIN_EXPRESSION_NODE

inherit

	XPLAIN_NODE [XPLAIN_EXPRESSION]
		rename
			make as make_node
		end


create

	make


feature {NONE} -- Initialization

	make (a_item: XPLAIN_EXPRESSION; a_new_name: STRING; a_next: like Current) is
		require
			item_not_void: a_item /= Void
			new_name_is_void_or_not_empty: a_new_name = Void or else not a_new_name.is_empty
		do
			make_node (a_item, a_next)
			new_name := a_new_name
		end


feature -- Access

	column_name: STRING is
			-- The Xplain based column heading name; it is used by
			-- PostgreSQL output to create the proper function type for
			-- example. The XML_GENERATOR uses it to give clients some
			-- idea what the column name of a select is going to be.
		require
			have_column_name: new_name = Void implies item.column_name /= Void
		do
			if new_name = Void then
				Result := item.column_name
			else
				Result := new_name
			end
		ensure
			result_is_not_empty: Result /= Void and then not Result.is_empty
		end

	path_name: STRING is
			-- XML path name, keeping Xplain structure intact; user for
			-- path procedures
		require
			have_column_name: new_name = Void implies item.column_name /= Void
		do
			if new_name = Void then
				Result := item.path_name
			else
				Result := new_name
			end
		ensure
			result_is_not_empty: Result /= Void and then not Result.is_empty
		end

	new_name: STRING
			-- Optional new name; `new_name' is required if
			-- `item'.`column_name' is Void.


feature -- Commands

	give_column_names (a_position: INTEGER) is
			-- Give this expression and all others following it a
			-- generated column name, if the expression doesn't have a
			-- column name and `new_name' is not set. It uses `a_position' to
			-- generate the name.
		require
			valid_position: a_position > 0
		do
			if new_name = Void then
				if item.column_name = Void then
					new_name := "column" + a_position.out
				end
				if next /= Void then
					next.give_column_names (a_position + 1)
				end
			end
		ensure
			column_name_set: not column_name.is_empty
		end


invariant

	new_name_is_void_or_not_empty: new_name = Void or else not new_name.is_empty

end
