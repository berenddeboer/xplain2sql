note

	description:

		"Xplain date and time representation"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

class

	XPLAIN_D_REPRESENTATION

inherit

	XPLAIN_REPRESENTATION
		redefine
			value_representation,
			min_value,
			max_value
		end


feature  -- Access

	domain: STRING = "(D)"
			-- Give Xplain domain as string.

	xml_schema_data_type: STRING
			-- Best matching XML schema data type
		once
			Result := "dateTime"
		end


feature  -- Required implementations

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- return sql data type, call sql_generator to return this
		do
			result := mygenerator.datatype_datetime (Current)
		end

	default_value: STRING = "0"
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.

	max_value (sqlgenerator: SQL_GENERATOR): STRING
			-- maximum value that fits in this representation
		do
			Result := sqlgenerator.as_string (once "9999-12-31")
		end

	min_value (sqlgenerator: SQL_GENERATOR): STRING
			-- minimum value that fits in this representation
		do
			Result := sqlgenerator.as_string (sqlgenerator.minimum_date_value)
		end


feature

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			Result := sqlgenerator.value_representation_date
		end


end
