note

	description:

		"Xplain character representation"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #11 $"


class

	XPLAIN_A_REPRESENTATION


inherit

	XPLAIN_REPRESENTATION
		redefine
			default_value,
			value_representation,
			mw_column_value
		end


create

	make


feature  -- Initialization

	make (alength: INTEGER)
		require
			length_positive: alength > 0
		do
			length := alength
		end


feature  -- public

	domain: STRING
			-- Give Xplain domain as string.
		local
			len: STRING
		do
			len := length.out
			create Result.make (2 + len.count + 1)
			Result.append_character ('(')
			Result.append_character ('A')
			Result.append_string (len)
			Result.append_character (')')
		end

	length: INTEGER
			-- Maximum length of characters.

	xml_schema_data_type: STRING
			-- Best matching XML schema data type
		do
			Result := "string"
		end


feature

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			Result := sqlgenerator.value_representation_char (length)
		end


feature  -- required implementations

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- SQL data type
		do
			result := mygenerator.datatype_varchar (Current)
		end

	default_value: STRING
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.
		once
			Result := "''"
		end

	max_value (sqlgenerator: SQL_GENERATOR): STRING
			-- Maximum value that fits in this representation
		do
			std.error.put_string ("An (A) base doesn't have a maximum value.%N")
			Result := "not applicable"
		end

	min_value (sqlgenerator: SQL_GENERATOR): STRING
			-- Minimum value that fits in this representation
		do
			std.error.put_string ("An (A) base doesn't have a minimum value.%N")
			Result := "not applicable"
		end


feature -- middleware specific routines

	mw_column_value (mygenerator: MIDDLEWARE_GENERATOR; column_name: STRING): STRING
			-- return piece of code to get contents
			-- getting values is usually type specific,
			-- not column_name specific
		do
			Result := mygenerator.get_column_value_string (column_name)
		end


invariant

	length_positive: length > 0

end
