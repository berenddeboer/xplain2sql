indexing

	description:
		"expression that selects a single value from the database ('count employee' for example), used within value definition."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #10 $"

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

	make (a_select_value: XPLAIN_SELECTION_VALUE) is
			-- Initialize.
		require
			valid_value: a_select_value /= Void
		do
			select_value := a_select_value
		end


feature -- Access

	select_value: XPLAIN_SELECTION_VALUE


feature -- Status

	uses_its: BOOLEAN is
			-- Does expression has an its list somewhere?
		do
			if select_value.property /= Void then
				Result := select_value.property.uses_its
			end
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			Result := select_value.uses_parameter (a_parameter)
		end


feature -- SQL output

	column_name: STRING is
			-- The Xplain based column heading name, if any. It is used
			-- by PostgreSQL output to create the proper function type
			-- for example. The XML_GENERATOR uses it to give clients
			-- some idea what the column name of a select is going to be.
		do
			Result := select_value.property.column_name
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
		do
			Result := select_value.representation (sqlgenerator)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING is
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- attributes of the type it has to be prefixed by "new." for
			-- example.
		do
			-- init value not applicable
			Result := sqlvalue (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- return string
		do
			Result := select_value.sqlvalue (sqlgenerator)
		end

invariant

	have_select_value: select_value /= Void

end
