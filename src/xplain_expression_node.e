note

	description: "Xplain linked list of expressions"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

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

	make (a_item: XPLAIN_EXPRESSION; a_new_name: like new_name; a_next: detachable like Current)
		require
			item_not_void: a_item /= Void
			new_name_is_void_or_not_empty: a_new_name = Void or else not a_new_name.is_empty
		do
			make_node (a_item, a_next)
			new_name := a_new_name
		end


feature -- Access

	column_name: STRING
			-- The Xplain based column heading name; it is used by
			-- PostgreSQL output to create the proper function type for
			-- example. The XML_GENERATOR uses it to give clients some
			-- idea what the column name of a select is going to be.
		require
			have_column_name: new_name = Void implies item.column_name /= Void
		do
			if attached new_name as n then
				Result := n
			elseif attached item.column_name as c then
				Result := c
			else
				Result := "SHOULD NOT HAPPEN"
			end
		ensure
			result_is_not_empty: Result /= Void and then not Result.is_empty
		end

	path_name: STRING
			-- XML path name, keeping Xplain structure intact; user for
			-- path procedures
		require
			have_column_name: new_name = Void implies item.column_name /= Void
		do
			if attached new_name as n then
				Result := n
			elseif attached item.path_name as n then
				Result := n
			else
				Result := "SHOULD NOT HAPPEN"
			end
		ensure
			result_is_not_empty: Result /= Void and then not Result.is_empty
		end

	new_name: detachable STRING
			-- Optional new name; `new_name' is required if
			-- `item'.`column_name' is Void.


feature -- Commands

	give_column_names (a_position: INTEGER)
			-- Give this expression and all others following it a
			-- generated column name, if the expression doesn't have a
			-- column name and `new_name' is not set. It uses `a_position' to
			-- generate the name.
		require
			valid_position: a_position > 0
		do
			if not attached new_name then
				if item.column_name = Void then
					new_name := "column" + a_position.out
				end
				if attached next as n then
					n.give_column_names (a_position + 1)
				end
			end
		ensure
			column_name_set: not column_name.is_empty
		end


invariant

	new_name_is_void_or_not_empty: not attached new_name as n or else not n.is_empty

end
