note

	description:

		"Xplain approximate numeric representation.%
		%Uses platform defaults to get the largest representation%
		%on that platform."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"


class

	XPLAIN_F_REPRESENTATION


inherit

	XPLAIN_REPRESENTATION
		redefine
			write_with_quotes
		end


feature -- Status

	write_with_quotes: BOOLEAN
			-- return true if values of this type should be surrounded by quotes
		do
			result := False
		end


feature  -- Access

	domain: STRING = "(F)"
			-- Give Xplain domain as string.

	xml_schema_data_type: STRING
			-- Best matching XML schema data type
		do
			Result := "double"
		end


feature  -- required implementations

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- return sql data type, call sql_generator to return this
		do
			result := mygenerator.datatype_float (Current)
		end

	default_value: STRING = "0"
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.

	max_value (sqlgenerator: SQL_GENERATOR): STRING
			-- maximum value that fits in this representation
		do
			Result := sqlgenerator.SQLMaxInt
		end

	min_value (sqlgenerator: SQL_GENERATOR): STRING
			-- minimum value that fits in this representation
		do
			Result := sqlgenerator.SQLMinInt
		end

end
