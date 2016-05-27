note

	description:

		"Singleton collection of all executable (not just used) Xplain statements."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"

class

	XPLAIN_STATEMENTS


create

	make


feature {NONE} -- Initialization

	make
		do
			create statements.make
		end


feature -- Statement list

	statements: DS_LINKED_LIST [XPLAIN_STATEMENT]
			-- All Xplain statements.


feature -- add objects

	add (statement: XPLAIN_STATEMENT)
		require
			statement_not_void: statement /= Void
		do
			-- perhaps `put_first' because parser returns them in reverse order??
			statements.put_first (statement)
		ensure
			one_more_statement: statements.count = old statements.count + 1
			statement_added: statements.has (statement)
		end


feature {NONE} -- Singleton part

	frozen singleton_memory: XPLAIN_STATEMENTS
		once
			Result := Current
		end


invariant

	is_actually_singleton: Current = singleton_memory
	have_statements: statements /= Void
	-- no_void_statement: for_each s in statements it_holds s /= Void

end
