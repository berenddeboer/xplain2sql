note

	description:

		"Xplain real representation"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #9 $"


class XPLAIN_R_REPRESENTATION

inherit

	XPLAIN_REPRESENTATION
		redefine
			default_value,
			mw_needs_precision,
			mw_numeric_scale,
			mw_precision,
			value_representation,
			write_with_quotes
		end


create

	make


feature  -- Initialization

	make (abefore, aafter: INTEGER)
		require
			before_positive: abefore > 0
			after_not_negative: aafter >= 0
		do
			before := abefore
			after := aafter
		end


feature  -- Public state

	before: INTEGER
	after: INTEGER
			-- decimal places before and after decimal point

	domain: STRING
			-- Give Xplain domain as string.
		do
			create Result.make (2 + before + 1 + after + 1)
			Result.append_character ('(')
			Result.append_character ('R')
			Result.append_string (before.out)
			Result.append_character (',')
			Result.append_string (after.out)
			Result.append_character (')')
		end

	xml_schema_data_type: STRING
			-- Best matching XML schema data type
		do
			Result := "decimal"
		end


feature

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			Result := sqlgenerator.value_representation_float
		end

	write_with_quotes: BOOLEAN = False
			-- Should values of this type be surrounded by quotes?


feature  -- required implementations

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- Data type according to `mygenerator';
			-- used for data type in create table definitions, stored procedures,
			-- or middleware.
		do
			result := mygenerator.datatype_numeric (Current)
		end

	default_value: STRING
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.
		once
			Result := "0"
		end

	max_value (sqlgenerator: SQL_GENERATOR): STRING
			-- maximum value that fits in this representation
		local
			s: STRING
		do
			create Result.make_filled ('9', before)
			Result.append_character ('.')
			create s.make_filled ('9', after)
			Result.append_string (s)
		end

	min_value (sqlgenerator: SQL_GENERATOR): STRING
			-- minimum value that fits in this representation
		local
			s: STRING
		do
			create Result.make_filled ('9', before)
			Result.append_character ('.')
			create s.make_filled ('9', after)
			Result.append_string (s)
			Result.insert_character ('-', 1)
		end


feature -- middleware

	mw_needs_precision: BOOLEAN
		do
			Result := True
		end

	mw_numeric_scale: INTEGER
		do
			Result := after
		end

	mw_precision: INTEGER
		do
			Result := before + after
		end

invariant

	before_positive: before > 0
	after_not_negative: after >= 0

end
