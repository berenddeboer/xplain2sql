note

	description:
		"expression that selects a single value from the database ('count employee' for example), used within value definition."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

class

	XPLAIN_SELECTION_EXPRESSION


inherit

	XPLAIN_EXPRESSION
		redefine
			column_name
		end


create

	make


feature {NONE} -- Initialization

	make (a_select_value: XPLAIN_SELECTION_VALUE)
			-- Initialize.
		require
			valid_value: a_select_value /= Void
		do
			select_value := a_select_value
		end


feature -- Access

	select_value: XPLAIN_SELECTION_VALUE


feature -- Status

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			if attached select_value.property as property then
				Result := property.uses_its
			end
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result := select_value.uses_parameter (a_parameter)
		end


feature -- SQL output

	column_name: detachable STRING
			-- The Xplain based column heading name, if any. It is used
			-- by PostgreSQL output to create the proper function type
			-- for example. The XML_GENERATOR uses it to give clients
			-- some idea what the column name of a select is going to be.
		do
			if attached select_value.property as property then
				Result := property.column_name
			end
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			Result := select_value.representation (sqlgenerator)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- attributes of the type it has to be prefixed by "new." for
			-- example.
		do
			-- init value not applicable
			Result := sqlvalue (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- return string
		do
			Result := select_value.sqlvalue (sqlgenerator)
		end

invariant

	have_select_value: select_value /= Void

end
