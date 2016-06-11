note

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

	domain: STRING = "(T)"
			-- Give Xplain domain as string.


feature -- Status

	is_blob (sqlgenerator: SQL_GENERATOR): BOOLEAN
			-- We need to be careful with storage space for blobs
		do
			Result := True
		end


feature

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			Result := sqlgenerator.value_representation_text
		end


feature -- Access

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- return sql data type, call sql_generator to return this
		do
			result := mygenerator.datatype_text (Current)
		end

	default_value: STRING = ""
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.

	xml_schema_data_type: STRING
			-- Best matching XML schema data type
		do
			Result := "string"
		end


end
