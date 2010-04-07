indexing

	description: "Attempt to return the last auto-generated-primary-key."
	author:      "Berend de Boer <berend@pobox.com>"
	copyright:   "Copyright (c) 2002, Berend de Boer"
	date:        "$Date: 2008/12/15 $"
	revision:    "$Revision: #7 $"

class

	XPLAIN_LAST_AUTO_PK_EXPRESSION

inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION

create

	make


feature {NONE} -- Initialization

	make (a_type: XPLAIN_TYPE) is
			-- Initialize.
		require
			type_not_void: a_type /= Void
		do
			type := a_type
		end


feature -- Access

	type: XPLAIN_TYPE

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- Representation is value representation.
		do
			-- Should depend on `type', but as we talk about
			-- auto-generated pk's, it's always an integer.
			Result := sqlgenerator.value_representation_integer (9)
		end


feature -- Status

	uses_its: BOOLEAN is
			-- Does expression has an its list somewhere?
		do
			Result := False
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			Result := False
		end


feature -- SQL code

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Return parameter value expression as string.
		do
			Result := sqlgenerator.sql_last_auto_generated_primary_key (type)
		end


invariant

	type_not_void: type /= Void

end
