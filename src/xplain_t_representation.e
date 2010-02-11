indexing

	description:

		"Xplain text (memo field) representation"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"


class

	XPLAIN_T_REPRESENTATION

inherit

	XPLAIN_REPRESENTATION
		redefine
			is_blob,
			value_representation
		end


feature  -- Public state

	domain: STRING is "(T)"
			-- Give Xplain domain as string.


feature -- Status

	is_blob (sqlgenerator: SQL_GENERATOR): BOOLEAN is
			-- We need to be careful with storage space for blobs
		do
			Result := True
		end


feature

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
		do
			Result := sqlgenerator.value_representation_text
		end


feature -- Access

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING is
			-- return sql data type, call sql_generator to return this
		do
			result := mygenerator.datatype_text (Current)
		end

	default_value: STRING is ""
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.

	max_value (sqlgenerator: SQL_GENERATOR): STRING is
			-- maximum value that fits in this representation
		do
			std.error.put_string ("A (T) base doesn't have a maximum value.%N")
		end

	min_value (sqlgenerator: SQL_GENERATOR): STRING is
			-- minimum value that fits in this representation
		do
			std.error.put_string ("A (T) base doesn't have a minimum value.%N")
		end

	xml_schema_data_type: STRING is
			-- Best matching XML schema data type
		do
			Result := "string"
		end


end
