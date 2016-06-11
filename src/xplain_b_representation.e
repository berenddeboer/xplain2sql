note

	description:

		"Xplain Boolean representation"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"


class

	XPLAIN_B_REPRESENTATION


inherit

	XPLAIN_REPRESENTATION
		redefine
			value_representation
		end


feature

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			Result := sqlgenerator.value_representation_boolean
		end

feature  -- Access

	domain: STRING = "(B)"
			-- Give Xplain domain as string.

	xml_schema_data_type: STRING
			-- Best matching XML schema data type
		do
			Result := "boolean"
		end


feature  -- required implementations

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- return sql data type, call sql_generator to return this
		do
			result := mygenerator.datatype_boolean (Current)
		end

	default_value: STRING = "0"
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.

end
