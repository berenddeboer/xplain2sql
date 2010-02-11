indexing

	description: "Xplain integer representation"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #9 $"

class

	XPLAIN_I_REPRESENTATION

inherit

	XPLAIN_REPRESENTATION
		redefine
			default_value,
			value_representation,
			write_with_quotes
		end


create

	make

feature {NONE}  -- Initialization

	make (alength: INTEGER) is
		require
			valid_length: alength > 0
		do
			length := alength
		end


feature -- Access

	domain: STRING is
			-- Give Xplain domain as string.
		do
			create Result.make (2 + length + 1)
			Result.append_character ('(')
			Result.append_character ('I')
			Result.append_string (length.out)
			Result.append_character (')')
		end

	length: INTEGER
			-- Maximum number of digits in this integer

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
		do
			Result := sqlgenerator.value_representation_integer (length)
		end

	xml_schema_data_type: STRING is
			-- Best matching XML schema data type
		local
			trajectory: XPLAIN_TRAJECTORY
			min: INTEGER
			max: INTEGER
		do
			trajectory ?= domain_restriction
			if trajectory /= Void and then trajectory.min.is_integer then
				min := trajectory.min.to_integer
			else
				min := -1
			end
			if trajectory /= Void and then trajectory.max.is_integer then
				max := trajectory.max.to_integer
			else
				max := 1
			end
			if min < 0 then
				inspect length
				when 1..2 then Result := "byte"
				when 3..4 then Result := "short"
				when 5..9 then Result := "int"
				when 10..18 then Result := "long"
				else
					if max < 0 then
						Result := "negativeInteger"
					elseif max = 0 then
						Result := "nonPositiveInteger"
					else
						Result := "integer"
					end
				end
			else -- min >= 0
				inspect length
				when 1..2 then Result := "unsignedByte"
				when 3..4 then Result := "unsignedShort"
				when 5..9 then Result := "unsignedInt"
				when 10..18 then Result := "unsignedLong"
				else
					if min = 0 then
						Result := "nonNegativeInteger"
					else
						Result := "positiveInteger"
					end
				end
			end
		end


feature -- Status

	write_with_quotes: BOOLEAN is
			-- Should values of this type be surrounded by quotes?
		do
			Result := False
		end


feature  -- required implementations

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING is
			-- return sql data type, call sql_generator to return this
		do
			Result := mygenerator.datatype_int (Current)
		end

	default_value: STRING is
			-- A default value to be used when a complex init is used and
			-- the column is not null and needs some value because the
			-- SQL dialect does not have the necessary before-insert
			-- trigger.
		once
			Result := "0"
		end

	max_value (sqlgenerator: SQL_GENERATOR): STRING is
			-- maximum value that fits in this representation
		do
			create Result.make_filled ('9', length)
		end

	min_value (sqlgenerator: SQL_GENERATOR): STRING is
			-- minimum value that fits in this representation
		do
			create Result.make_filled ('9', length)
			Result.insert_character ('-', 1)
		end


invariant

	length_positive: length > 0

end
