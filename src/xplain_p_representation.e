indexing

	description: "Xplain picture representation"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_P_REPRESENTATION

inherit

	XPLAIN_REPRESENTATION
		redefine
			is_blob
		end


feature  -- Access

	domain: STRING is "(P)"
			-- Give Xplain domain as string.

	xml_schema_data_type: STRING is
			-- Best matching XML schema data type
		do
			Result := "hexBinary"
		end


feature  -- required implementations

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING is
			-- return sql data type, call sql_generator to return this
		do
			result := mygenerator.datatype_picture (Current)
		end

	default_value: STRING is ""
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.

	max_value (sqlgenerator: SQL_GENERATOR): STRING is
			-- maximum value that fits in this representation
		do
			std.error.put_string ("A (P) base doesn't have a maximum value.%N")
		end

	min_value (sqlgenerator: SQL_GENERATOR): STRING is
			-- minimum value that fits in this representation
		do
			std.error.put_string ("A (P) base doesn't have a minimum value.%N")
		end

	is_blob (sqlgenerator: SQL_GENERATOR): BOOLEAN is
			-- we need to be careful with storage space for blobs
		do
			Result := True
		end

end
