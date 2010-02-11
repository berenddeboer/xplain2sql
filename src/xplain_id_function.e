indexing

	description: "Enhanced Xplain function id()"
	usage: "To be used when id is queried in where clause, for example you want to exclude certain ids from retrieval."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #7 $"


class

	XPLAIN_ID_FUNCTION


inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION


create

	make


feature {NONE} -- Initialization

	make (a_type: XPLAIN_TYPE) is
			-- Return primary key info for `a_type'.
		require
			a_type_not_void: a_type /= Void
		do
			type := a_type
		ensure
			type_set: type = a_type
		end


feature -- Access

	type: XPLAIN_TYPE
			-- Type which primary key is returned.


feature -- Status

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			Result := False
		end


feature -- SQL output

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- Return correct representation for this expression.
			-- Used to generate representations for value and extend statements.
		do
			-- representation of pk
			Result := type.representation
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Return expression in generator syntax.
		do
			create Result.make_from_string (type.quoted_name (sqlgenerator))
			Result.append_character ('.')
			Result.append_string (type.q_sqlpkname (sqlgenerator))
		end


invariant

	type_not_void: type /= Void

end
