note

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

	domain: STRING = "(P)"
			-- Give Xplain domain as string.

	xml_schema_data_type: STRING
			-- Best matching XML schema data type
		do
			Result := "hexBinary"
		end


feature  -- required implementations

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- return sql data type, call sql_generator to return this
		do
			result := mygenerator.datatype_picture (Current)
		end

	default_value: STRING = ""
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.

	is_blob (sqlgenerator: SQL_GENERATOR): BOOLEAN
			-- we need to be careful with storage space for blobs
		do
			Result := True
		end

end
