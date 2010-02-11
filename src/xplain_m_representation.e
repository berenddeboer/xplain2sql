indexing

	description: "Xplain money representation"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_M_REPRESENTATION

inherit

	XPLAIN_REPRESENTATION
		redefine
			mw_needs_precision,
			mw_numeric_scale,
			mw_precision,
			value_representation,
			write_with_quotes
		end


feature  -- Access

	domain: STRING is "(M)"
			-- Give Xplain domain as string.

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
		do
			Result := sqlgenerator.value_representation_money
		end

	xml_schema_data_type: STRING is
			-- Best matching XML schema data type
		do
			Result := "decimal"
		end


feature -- Status

	write_with_quotes: BOOLEAN is
			-- return true if values of this type should be surrounded by quotes
		do
			result := False
		end

feature  -- required implementations

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING is
			-- return sql data type, call sql_generator to return this
		do
			result := mygenerator.datatype_money (Current)
		end

	default_value: STRING is "0"
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.

	max_value (sqlgenerator: SQL_GENERATOR): STRING is
			-- maximum value that fits in this representation
		do
			Result := sqlgenerator.SQLMaxInt
		end

	min_value (sqlgenerator: SQL_GENERATOR): STRING is
			-- minimum value that fits in this representation
		do
			Result := sqlgenerator.SQLMinInt
		end


feature -- middleware

	mw_needs_precision: BOOLEAN is
		do
			Result := True
		end

	mw_numeric_scale: INTEGER is
		do
			Result := 4
		end

	mw_precision: INTEGER is
		do
			Result := 15 + 4
		end

end
